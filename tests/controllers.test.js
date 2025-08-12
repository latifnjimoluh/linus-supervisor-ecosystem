const fs = require('fs');
jest.mock('../models', () => {
  const actual = jest.requireActual('../models');
  return { ...actual, GeneratedScript: { findByPk: jest.fn() } };
});
const { GeneratedScript } = require('../models');
const request = require('supertest');
const app = require('../app');

const cases = [
  { method: 'get', path: '/auth/me', status: 401 },
  { method: 'get', path: '/permissions', status: 401 },
  { method: 'get', path: '/roles', status: 401 },
  { method: 'get', path: '/users', status: 401 },
  { method: 'get', path: '/logs', status: 401 },
  { method: 'get', path: '/logs/export', status: 401 },
  { method: 'get', path: '/settings', status: 401 },
  { method: 'get', path: '/settings/notifications', status: 401 },
  { method: 'get', path: '/vms', status: 401 },
  { method: 'get', path: '/templates', status: 401 },
  { method: 'post', path: '/terraform/deploy', status: 401 },
  { method: 'get', path: '/monitoring', status: 401 },
  { method: 'get', path: '/dashboard', status: 401 },
  { method: 'get', path: '/dashboard/summary', status: 401 },
  { method: 'get', path: '/dashboard/servers', status: 401 },
  { method: 'post', path: '/dashboard/servers', status: 401 },
  { method: 'delete', path: '/dashboard/servers/1', status: 401 },
  { method: 'get', path: '/dashboard/stats', status: 401 },
  { method: 'get', path: '/dashboard/insights', status: 401 },
  { method: 'get', path: '/alerts', status: 401 },
  { method: 'get', path: '/ai-cache', status: 401 },
  { method: 'get', path: '/deployments/history', status: 401 },
  { method: 'get', path: '/deployments/1/summary', status: 401 },
  { method: 'get', path: '/deployments/check-space', status: 401 },
  { method: 'post', path: '/deployments/analyze', status: 401 },
  { method: 'post', path: '/templates/1/restore', status: 401 },
  { method: 'post', path: '/scripts/1/analyze', status: 401 },
  { method: 'delete', path: '/scripts/1', status: 401 },
  { method: 'post', path: '/scripts/1/restore', status: 401 },
];

afterEach(() => {
  jest.restoreAllMocks();
});

describe('protected routes', () => {
  cases.forEach((c) => {
    it(`${c.method.toUpperCase()} ${c.path} returns ${c.status}`, async () => {
      const res = await request(app)[c.method](c.path);
      expect(res.status).toBe(c.status);
    });
  });
});

describe('open routes', () => {
  it('GET /scripts/preview returns generated script', async () => {
    const res = await request(app).get('/scripts/preview/123/test');
    expect(res.status).toBe(200);
    expect(res.body.format).toBe('bash');
    expect(res.body.script).toContain('Configuring test');
  });

  it('POST /assistant/chat without message returns 400', async () => {
    const res = await request(app)
      .post('/assistant/chat')
      .set('Content-Type', 'application/json')
      .send({});
    expect(res.status).toBe(400);
  });
});

describe('script retrieval', () => {
  it('GET /scripts/generated/:id returns script with content', async () => {
    const mock = {
      id: 1,
      script_path: '/scripts/test.sh',
      toJSON() { return { id: this.id, script_path: this.script_path }; }
    };
    GeneratedScript.findByPk.mockResolvedValue(mock);
    jest.spyOn(fs, 'existsSync').mockReturnValue(false);
    const res = await request(app).get('/scripts/generated/1');
    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({ id: 1, script_path: '/scripts/test.sh', content: null });
  });
});
