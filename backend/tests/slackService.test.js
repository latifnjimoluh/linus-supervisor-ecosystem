jest.mock('axios');
const axios = require('axios');
const { sendSlackMessage } = require('../services/slackService');

test('posts message to slack webhook', async () => {
  axios.post.mockResolvedValue({});
  process.env.SLACK_WEBHOOK_URL = 'http://example.com';
  await sendSlackMessage('hello');
  expect(axios.post).toHaveBeenCalledWith('http://example.com', { text: 'hello' });
});
