const buckets = new Map();

module.exports = function chatRateLimiter({ windowMs = 300000, limit = 30 } = {}) {
  return (req, res, next) => {
    const id = req.user?.id || req.ip || 'unknown';
    const now = Date.now();
    const bucket = buckets.get(id) || [];
    const recent = bucket.filter((ts) => ts > now - windowMs);
    recent.push(now);
    buckets.set(id, recent);
    if (recent.length > limit) {
      return res.status(429).json({ error: 'rate_limited' });
    }
    next();
  };
};
