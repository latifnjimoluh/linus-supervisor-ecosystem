jest.mock('net-snmp', () => ({
  createSession: jest.fn(() => ({
    get: (oids, cb) => cb(null, [{ value: 2 }]),
    close: jest.fn()
  })),
  isVarbindError: jest.fn(() => false)
}), { virtual: true });

jest.mock('../services/slackService', () => ({ sendSlackMessage: jest.fn() }));
const { sendSlackMessage } = require('../services/slackService');

const { checkInterfaceStatus } = require('../services/snmpService');

test('sends slack alert when interface is down', async () => {
  const status = await checkInterfaceStatus('10.0.0.1', 'public', 1);
  expect(status).toBe(2);
  expect(sendSlackMessage).toHaveBeenCalled();
});
