const errorHandler = require('../middlewares/errorHandler');
const log = require('../middlewares/log');

describe('log middleware', () => {
  it('calls next', () => {
    const req = { method: 'GET', originalUrl: '/test' };
    const res = {};
    const next = jest.fn();
    log(req, res, next);
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
