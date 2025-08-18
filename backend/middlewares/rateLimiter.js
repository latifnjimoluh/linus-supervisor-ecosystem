const buckets = new Map();

module.exports = function rateLimiter({ windowMs = 60000000000, limit = 60 } = {}) {
  return (req, res, next) => {
    const now = Date.now();
    const ip = req.ip || req.connection.remoteAddress || 'unknown';
    const bucket = buckets.get(ip) || [];
    const recent = bucket.filter((ts) => ts > now - windowMs);
    recent.push(now);
    buckets.set(ip, recent);
    if (recent.length > limit) {
      return res.status(429).json({ error: 'rate_limited' });
    }
    next();
  };
};
