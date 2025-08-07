const test = require('node:test');
const assert = require('node:assert/strict');
const { startServer, closeServer } = require('./server');

const cases = [
  { method: 'GET', path: '/auth/me', status: 401 },
  { method: 'GET', path: '/permissions', status: 401 },
  { method: 'GET', path: '/roles', status: 401 },
  { method: 'GET', path: '/users', status: 401 },
  { method: 'GET', path: '/logs', status: 401 },
  { method: 'GET', path: '/settings', status: 401 },
  { method: 'GET', path: '/settings/notifications', status: 401 },
  { method: 'GET', path: '/vms', status: 401 },
  { method: 'GET', path: '/templates', status: 401 },
  { method: 'POST', path: '/terraform/deploy', status: 401 },
  { method: 'GET', path: '/monitoring', status: 401 },
  { method: 'GET', path: '/dashboard/summary', status: 401 },
  { method: 'GET', path: '/alerts', status: 401 },
  { method: 'GET', path: '/ai-cache', status: 401 },
  { method: 'GET', path: '/servers', status: 401 },
];

for (const c of cases) {
  test(`${c.method} ${c.path} returns ${c.status}`, async () => {
    const server = await startServer();
    const port = server.address().port;
    const res = await fetch(`http://localhost:${port}${c.path}`, { method: c.method });
    assert.equal(res.status, c.status);
    await closeServer(server);
  });
}

// open routes

test('GET /scripts/preview returns generated script', async () => {
  const server = await startServer();
  const port = server.address().port;
  const res = await fetch(`http://localhost:${port}/scripts/preview/123/test`);
  assert.equal(res.status, 200);
  const body = await res.json();
  assert.equal(body.format, 'bash');
  assert.ok(body.script.includes('Configuring test'));
  await closeServer(server);
});

test('POST /assistant/chat without message returns 400', async () => {
  const server = await startServer();
  const port = server.address().port;
  const res = await fetch(`http://localhost:${port}/assistant/chat`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  });
  assert.equal(res.status, 400);
  await closeServer(server);
});
