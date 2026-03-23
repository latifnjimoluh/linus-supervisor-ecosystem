const levels = ['error', 'warn', 'info', 'debug'];
const current = levels.indexOf(process.env.LOG_LEVEL || 'info');

function format(level, message, meta) {
  const base = `[${new Date().toISOString()}] ${level.toUpperCase()}: ${message}`;
  return meta ? `${base} ${JSON.stringify(meta)}` : base;
}

const logger = {};
levels.forEach((level, idx) => {
  logger[level] = (msg, meta) => {
    if (idx <= current) {
      // eslint-disable-next-line no-console
      console.log(format(level, msg, meta));
    }
  };
});

module.exports = logger;
