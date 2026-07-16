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

const before = Number(run('SELECT hits FROM hit_counter WHERE id = 1').rows[0][0]);
run('UPDATE hit_counter SET hits = hits + 1 WHERE id = 1');
const after = Number(run('SELECT hits FROM hit_counter WHERE id = 1').rows[0][0]);
assert.equal(after, before + 1);

run("INSERT INTO guestbook (name, message, created_at) VALUES ('smoke test', 'real MySQL write', NOW())");
const inserted = Number(run("SELECT COUNT(*) FROM guestbook WHERE name = 'smoke test'").rows[0][0]);
assert.equal(inserted, 1);

console.log(JSON.stringify({
  version,
  statements: statements.length,
  hitCounter: { before, after },
  insertedGuestbookRows: inserted,
}));

shutdown();
