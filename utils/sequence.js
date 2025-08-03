const fs = require('fs');

function getNextSequence(dir, prefix = '', suffix = '') {
  if (!fs.existsSync(dir)) return '001';
  const regex = new RegExp(`^${prefix}(\\d{3})${suffix}$`);
  const numbers = fs.readdirSync(dir).map(name => {
    const match = name.match(regex);
    return match ? parseInt(match[1], 10) : 0;
  });
  const max = numbers.length ? Math.max(...numbers) : 0;
  return String(max + 1).padStart(3, '0');
}

module.exports = { getNextSequence };
