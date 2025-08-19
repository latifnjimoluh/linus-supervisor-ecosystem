const metrics = {
  total: 0,
  successes: 0,
  errors: {},
  durations: [],
  tokens: 0,
};

function record({ success, durationMs, errorType, tokens = 0 }) {
  metrics.total++;
  metrics.durations.push(durationMs);
  if (success) {
    metrics.successes++;
  } else {
    metrics.errors[errorType] = (metrics.errors[errorType] || 0) + 1;
  }
  metrics.tokens += tokens;
}

function percentile(arr, p) {
  if (!arr.length) return 0;
  const sorted = [...arr].sort((a, b) => a - b);
  const idx = Math.ceil((p / 100) * sorted.length) - 1;
  return sorted[Math.max(0, Math.min(idx, sorted.length - 1))];
}

function getStats() {
  const successRate = metrics.total ? metrics.successes / metrics.total : 0;
  const p50 = percentile(metrics.durations, 50);
  const p95 = percentile(metrics.durations, 95);
  return {
    successRate,
    p50,
    p95,
    errors: metrics.errors,
    tokens: metrics.tokens,
  };
}

module.exports = { record, getStats };
