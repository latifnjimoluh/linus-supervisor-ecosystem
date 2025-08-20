const child_process = require('child_process');
jest.mock('child_process', () => ({ exec: jest.fn() }));

const { runTraceroute } = require('../services/tracerouteService');

describe('tracerouteService', () => {
  afterEach(() => { child_process.exec.mockReset(); });

  it('returns output on success', async () => {
    child_process.exec.mockImplementation((cmd, opts, cb) => cb(null, 'trace ok', ''));
    await expect(runTraceroute('8.8.8.8')).resolves.toContain('trace ok');
  });

  it('throws error on failure', async () => {
    child_process.exec.mockImplementation((cmd, opts, cb) => cb(new Error('fail'), '', 'fail'));
    await expect(runTraceroute('8.8.8.8')).rejects.toThrow('traceroute failed');
  });
});
