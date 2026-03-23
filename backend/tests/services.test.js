const iaService = require('../services/iaService');
const userService = require('../services/userService');
const { streamChat, concatDeltas } = require('../services/llm');

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

describe('llm streamChat', () => {
  it('concatenates deltas', async () => {
    const encoder = new TextEncoder();
    const chunks = [
      'data: {"choices":[{"delta":{"content":"He"}}]}\n\n',
      'data: {"choices":[{"delta":{"content":"llo"}}]}\n\n',
      'data: [DONE]\n\n',
    ];
    const fetchMock = () =>
      Promise.resolve({
        ok: true,
        body: {
          getReader() {
            let i = 0;
            return {
              read() {
                if (i >= chunks.length) return Promise.resolve({ done: true });
                return Promise.resolve({ done: false, value: encoder.encode(chunks[i++]) });
              },
            };
          },
        },
      });
    let out = '';
    const full = await streamChat({ messages: [], onDelta: (t) => (out += t), fetchFn: fetchMock });
    expect(out).toBe('Hello');
    expect(full).toBe('Hello');
  });

  it('supports abort', async () => {
    const encoder = new TextEncoder();
    const fetchMock = ({ signal }) =>
      Promise.resolve({
        ok: true,
        body: {
          getReader() {
            return {
              read() {
                return new Promise((resolve, reject) => {
                  if (signal.aborted) return reject(new Error('aborted'));
                  setTimeout(() => {
                    if (signal.aborted) return reject(new Error('aborted'));
                    resolve({
                      done: false,
                      value: encoder.encode('data: {"choices":[{"delta":{"content":"Hi"}}]}\n\n'),
                    });
                  }, 50);
                });
              },
            };
          },
        },
      });
    const ac = new AbortController();
    const p = streamChat({ messages: [], onDelta: () => {}, signal: ac.signal, fetchFn: fetchMock });
    setTimeout(() => ac.abort(), 10);
    await expect(p).rejects.toBeDefined();
  });

  it('concatDeltas joins array', () => {
    expect(concatDeltas(['a', 'b', 'c'])).toBe('abc');
  });
});
