const fetch = global.fetch;

/**
 * Stream chat completion from LLM API.
 * @param {Object} params
 * @param {Array} params.messages - conversation history
 * @param {AbortSignal} [params.signal] - abort signal
 * @param {(delta:string)=>void} params.onDelta - callback for each token
 * @param {Function} [params.fetchFn] - custom fetch implementation (for tests)
 * @returns {Promise<string>} full concatenated response
 */
async function streamChat({ messages, signal, onDelta, fetchFn }) {
  const apiKey = process.env.LLM_API_KEY || '';
  const base = process.env.LLM_BASE_URL || 'https://api.openai.com/v1/chat/completions';
  const model = process.env.LLM_MODEL || 'gpt-3.5-turbo';
  const fetchImpl = fetchFn || fetch;

  const res = await fetchImpl(base, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(apiKey ? { Authorization: `Bearer ${apiKey}` } : {}),
    },
    body: JSON.stringify({ model, messages, stream: true }),
    signal,
  });

  if (!res.ok || !res.body) {
    throw new Error(`LLM_request_failed_${res.status}`);
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let full = '';

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    const chunk = decoder.decode(value, { stream: true });
    const lines = chunk.split('\n');
    for (const line of lines) {
      if (!line.startsWith('data:')) continue;
      const data = line.replace(/^data:\s*/, '').trim();
      if (!data || data === '[DONE]') continue;
      try {
        const json = JSON.parse(data);
        const token = json.choices?.[0]?.delta?.content;
        if (token) {
          full += token;
          onDelta(token);
        }
      } catch (err) {
        // ignore malformed chunks
      }
    }
  }
  return full;
}

function concatDeltas(deltas) {
  return deltas.join('');
}

module.exports = { streamChat, concatDeltas };
