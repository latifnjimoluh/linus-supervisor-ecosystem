const axios = require('axios');
const https = require('https');

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

class ProxmoxService {
  constructor(settings) {
    this.apiUrl = settings.proxmox_api_url;
    this.tokenId = settings.proxmox_api_token_id;
    this.tokenName = settings.proxmox_api_token_name;
    this.tokenSecret = settings.proxmox_api_token_secret;
    this.node = settings.proxmox_node;
    this.headers = {
      Authorization: `PVEAPIToken=${this.tokenId}!${this.tokenName}=${this.tokenSecret}`,
    };
  }

  async request(method, path, data) {
    try {
      const res = await axios({
        method,
        url: `${this.apiUrl}${path}`,
        data,
        httpsAgent,
        headers: this.headers,
      });
      return res.data;
    } catch (err) {
      console.error('❌ Proxmox request error:', err.message);
      throw err;
    }
  }

  get(path) {
    return this.request('get', path);
  }

  post(path, data) {
    return this.request('post', path, data);
  }

  delete(path) {
    return this.request('delete', path);
  }
}

module.exports = { ProxmoxService };
