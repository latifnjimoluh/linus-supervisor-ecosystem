const iaService = require('../services/iaService');
const userService = require('../services/userService');

describe('iaService', () => {
  it('generateScript returns script object', async () => {
    const result = await iaService.generateScript('test', {});
    expect(result).toHaveProperty('script');
  });
});

describe('userService', () => {
  it('getAllUsers rejects without database', async () => {
    await expect(userService.getAllUsers({})).rejects.toBeDefined();
  });
});
