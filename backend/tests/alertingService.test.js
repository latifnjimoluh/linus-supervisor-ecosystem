jest.mock('../models', () => ({
  Alert: {
    create: jest.fn(async (data) => ({
      ...data,
      id: 1,
      toJSON: () => ({ ...data, id: 1 })
    }))
  }
}));

jest.mock('../utils/notificationQueue', () => ({ enqueue: jest.fn() }));

jest.mock('../services/slackService', () => ({ sendSlackMessage: jest.fn() }));
const { sendSlackMessage } = require('../services/slackService');

const { handleResourceMetrics } = require('../services/alertingService');

test('sends slack message when alert is created', async () => {
  process.env.ALERT_EMAIL_TO = 'test@example.com';
  await handleResourceMetrics({ hostname: 'srv1', cpu_usage: 95 }, {}, {});
  expect(sendSlackMessage).toHaveBeenCalled();
});
