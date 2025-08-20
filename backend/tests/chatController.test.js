jest.mock('../models', () => ({
  ChatConversation: {
    create: jest.fn(async () => ({ id: 1 })),
    findOne: jest.fn(async () => ({ id: 1, user_id: 1 })),
  },
  ChatMessage: {
    create: jest.fn(async () => {}),
  },
}));

jest.mock('../utils/chatMetrics', () => ({ record: jest.fn() }));

let createConversation, streamMessage;

beforeEach(() => {
  jest.resetModules();
  process.env.USE_GEMINI = 'false';
  ({ createConversation, streamMessage } = require('../controllers/chat/chatController'));
});

function mockRes() {
  return {
    status: jest.fn().mockReturnThis(),
    json: jest.fn(),
  };
}

test('creates conversation even when Gemini disabled', async () => {
  const req = { user: { id: 1 } };
  const res = mockRes();
  await createConversation(req, res);
  expect(res.status).toHaveBeenCalledWith(201);
  expect(res.json).toHaveBeenCalledWith({ conversation_id: 1 });
});

test('returns echo response when Gemini disabled', async () => {
  const req = { user: { id: 1 }, body: { conversation_id: 1, user_text: 'hello' } };
  const res = mockRes();
  await streamMessage(req, res);
  expect(res.json).toHaveBeenCalledWith({ reply: 'Gemini désactivé : hello' });
});
