const attempts = new Map();

module.exports = function loginLimiter({ windowMs = 150 * 60 * 1000, limit = 5 } = {}) {
  return (req, res, next) => {
    const now = Date.now();
    const ip = req.ip || req.connection.remoteAddress || 'unknown';
    const bucket = attempts.get(ip) || [];
    const recent = bucket.filter((ts) => ts > now - windowMs);
    recent.push(now);
    attempts.set(ip, recent);
    if (recent.length > limit) {
      return res
        .status(429)
        .json({ message: 'Trop de tentatives de connexion. Réessayez plus tard.' });
    }
    next();
  };
};
