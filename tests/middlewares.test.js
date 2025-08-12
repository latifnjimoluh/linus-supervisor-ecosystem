const errorHandler = require('../middlewares/errorHandler');
const { logRequest } = require('../middlewares/log');

jest.mock('../models', () => ({ Log: { create: jest.fn().mockResolvedValue({}) } }));

describe('log middleware', () => {
  it('calls next', async () => {
    const req = { method: 'GET', originalUrl: '/test' };
    const res = {};
    const next = jest.fn();
    await logRequest(req, res, next);
    expect(next).toHaveBeenCalled();
  });
});

describe('errorHandler', () => {
  it('sends json error response', () => {
    const err = new Error('boom');
    const req = {};
    const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
    const next = jest.fn();
    errorHandler(err, req, res, next);
    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalled();
  });
});
