const request = require('supertest');
const app = require('../app');

describe('app routes', () => {
  it('unknown route returns 404', async () => {
    const res = await request(app).get('/unknown');
    expect(res.status).toBe(404);
  });

  it('users route without token returns 401', async () => {
    const res = await request(app).get('/users');
    expect(res.status).toBe(401);
  });
});
