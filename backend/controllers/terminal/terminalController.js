const axios = require('axios');
const https = require('https');
const { Deployment, UserSetting } = require('../../models');
const { logAction } = require('../../middlewares/log');

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

function getHeaders(tokenId, tokenName, tokenSecret) {
  return { Authorization: `PVEAPIToken=${tokenId}!${tokenName}=${tokenSecret}` };
}

// List VMs with status and IP from database for terminal connection
exports.listTerminalVMs = async (req, res) => {
  try {
    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: 'Paramètres Proxmox introuvables.' });
    }

    const url = `${settings.proxmox_api_url}/cluster/resources?type=vm`;
    const headers = getHeaders(
      settings.proxmox_api_token_id,
      settings.proxmox_api_token_name,
      settings.proxmox_api_token_secret
    );
    const response = await axios.get(url, { httpsAgent, headers });
    const vms = response.data?.data || [];

    const results = await Promise.all(
      vms.map(async (vm) => {
        const deployment = await Deployment.findOne({ where: { vm_id: String(vm.vmid) } });
        const ip = deployment && deployment.status === 'apply' ? deployment.vm_ip : null;
        return {
          id: String(vm.vmid),
          name: vm.name,
          status: vm.status,
          ip,
        };
      })
    );

    await logAction(req, 'terminal_list_vms');
    res.json(results);
  } catch (err) {
    console.error('❌ Erreur listTerminalVMs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};
