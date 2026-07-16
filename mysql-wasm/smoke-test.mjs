import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const moduleFile = path.resolve(process.argv[2]);
const dumpFile = path.resolve(process.argv[3]);
const moduleDirectory = path.dirname(moduleFile);
const { default: createMysqlModule } = await import(pathToFileURL(moduleFile));

const mysql = await createMysqlModule({
  locateFile: name => path.join(moduleDirectory, name),
  print: message => console.log('[mysql stdout]', message),
  printErr: message => console.error('[mysql stderr]', message),
});
const state = mysql.cwrap('mysql_wasm_state', 'number', []);
const initError = mysql.cwrap('mysql_wasm_error', 'string', []);
const query = mysql.cwrap('mysql_wasm_query', 'string', ['string']);
const shutdown = mysql.cwrap('mysql_wasm_shutdown', null, []);

const initDeadline = Date.now() + 300_000;
let initState = state();
while ((initState === 0 || initState === 1) && Date.now() < initDeadline) {
  await new Promise(resolve => setTimeout(resolve, 50));
  initState = state();
}
assert.equal(initState, 2, `MySQL initialization failed: ${initError() || `state ${initState}`}`);

const run = sql => {
  const result = JSON.parse(query(sql));
  assert.equal(result.error, undefined, `${result.error || 'query failed'}\n${sql}`);
  return result;
};

const dump = await readFile(dumpFile, 'utf8');
const statements = dump.split(/;\s*\r?\n/)
  .map(chunk => chunk.split('\n')
    .filter(line => !line.trim().startsWith('--'))
    .join('\n')
    .trim())
  .filter(Boolean);

for (const statement of statements) run(statement);

const version = run('SELECT VERSION()').rows[0][0];
assert.match(version, /^5\.7\.44/);

const blogName = run("SELECT option_value FROM wp_options WHERE option_name = 'blogname'").rows[0][0];
assert.equal(blogName, "Austin's Real Browser WordPress");

const before = Number(run("SELECT comment_count FROM wp_posts WHERE ID = 1").rows[0][0]);
run("INSERT INTO wp_comments (comment_post_ID, comment_author, comment_date, comment_date_gmt, comment_content, comment_approved, comment_agent) VALUES (1, 'smoke test', NOW(), NOW(), 'real MySQL write', '1', 'WordPress/6.8.3; MySQL-WASM')");
run('UPDATE wp_posts SET comment_count = comment_count + 1 WHERE ID = 1');
const after = Number(run("SELECT comment_count FROM wp_posts WHERE ID = 1").rows[0][0]);
assert.equal(after, before + 1);
const inserted = Number(run("SELECT COUNT(*) FROM wp_comments WHERE comment_author = 'smoke test'").rows[0][0]);
assert.equal(inserted, 1);

console.log(JSON.stringify({
  version,
  statements: statements.length,
  blogName,
  commentCount: { before, after },
  insertedCommentRows: inserted,
}));

shutdown();
