const { checkInterfaceStatus } = require('../../services/snmpService');

exports.checkInterface = async (req, res) => {
  const { host, community = 'public', ifIndex } = req.query;
  if (!host || !ifIndex) {
    return res.status(400).json({ message: 'host and ifIndex required' });
  }
  try {
    const status = await checkInterfaceStatus(host, community, ifIndex);
    res.json({ status });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
