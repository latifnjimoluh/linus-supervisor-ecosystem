const { runTraceroute } = require('../../services/tracerouteService');

exports.run = async (req, res) => {
  const target = req.body?.target || req.query?.target;
  if (!target) return res.status(400).json({ message: 'target required' });
  try {
    const output = await runTraceroute(target);
    res.json({ target, output });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};
