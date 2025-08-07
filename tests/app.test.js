const test = require('node:test');
const assert = require('node:assert/strict');
const { startServer, closeServer } = require('./server');

test('unknown route returns 404', async () => {
  const server = await startServer();
  const port = server.address().port;
  const res = await fetch(`http://localhost:${port}/unknown`);
  assert.equal(res.status, 404);
  await closeServer(server);
});

test('users route without token returns 401', async () => {
  const server = await startServer();
  const port = server.address().port;
  const res = await fetch(`http://localhost:${port}/users`);
  assert.equal(res.status, 401);
  await closeServer(server);
});
