const [
  debugUrl = 'http://127.0.0.1:9227',
  pageUrl = 'http://127.0.0.1:8000/',
  expectedTitle = "austin's BAD IDEAS zone",
  timeoutArg = '180000',
] = process.argv.slice(2);

const timeoutMs = Number(timeoutArg);
const deadline = Date.now() + timeoutMs;
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

async function findPageTarget() {
  while (Date.now() < deadline) {
    try {
      const response = await fetch(`${debugUrl}/json/list`);
      if (response.ok) {
        const targets = await response.json();
        const target = targets.find(candidate =>
          candidate.type === 'page' && candidate.url.startsWith(pageUrl));
        if (target?.webSocketDebuggerUrl) return target;
      }
    } catch (_) {
      // Chrome may not have opened its debugging socket yet.
    }
    await sleep(250);
  }
  throw new Error(`Chrome did not expose ${pageUrl} within ${timeoutMs}ms`);
}

async function main() {
  const target = await findPageTarget();
  const socket = new WebSocket(target.webSocketDebuggerUrl);
  const pending = new Map();
  const browserErrors = [];
  let commandId = 0;

  socket.addEventListener('message', event => {
    const message = JSON.parse(String(event.data));
    if (message.id) {
      const request = pending.get(message.id);
      if (!request) return;
      pending.delete(message.id);
      if (message.error) request.reject(new Error(message.error.message));
      else request.resolve(message.result);
      return;
    }

    if (message.method === 'Runtime.exceptionThrown') {
      const details = message.params.exceptionDetails;
      browserErrors.push(details.exception?.description || details.text);
    }
    if (message.method === 'Log.entryAdded' && message.params.entry.level === 'error') {
      browserErrors.push(message.params.entry.text);
    }
  });

  await new Promise((resolve, reject) => {
    socket.addEventListener('open', resolve, { once: true });
    socket.addEventListener('error', () => reject(new Error('Chrome debugging WebSocket failed')), {
      once: true,
    });
  });

  const command = (method, params = {}) => new Promise((resolve, reject) => {
    const id = ++commandId;
    pending.set(id, { resolve, reject });
    socket.send(JSON.stringify({ id, method, params }));
  });

  await command('Runtime.enable');
  await command('Log.enable');

  let previousProgress = '';
  let latestSnapshot = null;
  while (Date.now() < deadline) {
    const evaluation = await command('Runtime.evaluate', {
      expression: `(() => ({
        title: document.title,
        status: document.querySelector('#boot-status')?.textContent || '',
        hasGuestbook: Boolean(document.querySelector('form[onsubmit*="__signGuestbook"]')),
        hasVisitorCounter: document.body?.innerText.includes('You are visitor number') || false,
        body: document.body?.innerText.slice(0, 2000) || ''
      }))()`,
      returnByValue: true,
    });
    latestSnapshot = evaluation.result.value;

    const progress = `${latestSnapshot.title} | ${latestSnapshot.status}`;
    if (progress !== previousProgress) {
      console.log(`[browser] ${progress}`);
      previousProgress = progress;
    }

    const rendered = latestSnapshot.title === expectedTitle
      && latestSnapshot.hasGuestbook
      && latestSnapshot.hasVisitorCounter;
    if (rendered) {
      console.log('[browser] MySQL and PHP rendered the guestbook and visitor counter.');
      socket.close();
      return;
    }

    if (latestSnapshot.title === '500 Internal Browser Error') break;
    await sleep(250);
  }

  socket.close();
  const errors = browserErrors.length ? `\nBrowser errors:\n${browserErrors.join('\n')}` : '';
  throw new Error(
    `Page did not render within ${timeoutMs}ms. Last snapshot:\n`
      + `${JSON.stringify(latestSnapshot, null, 2)}${errors}`,
  );
}

main().catch(error => {
  console.error(error.stack || error);
  process.exitCode = 1;
});
