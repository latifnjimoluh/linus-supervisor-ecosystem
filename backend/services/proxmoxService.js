// backend/services/proxmoxService.js
const axios = require('axios');
const https = require('https');

class ProxmoxService {
  /**
   * @param {Object} settings
   * @param {string} settings.proxmox_api_url         - Ex: "https://IP:8006/api2/json"
   * @param {string} settings.proxmox_api_token_id    - Ex: "root@pam"
   * @param {string} settings.proxmox_api_token_name  - Ex: "token-id"
   * @param {string} settings.proxmox_api_token_secret
   * @param {string} [settings.proxmox_node]          - Ex: "pve"
   * @param {number} [settings.timeout=15000]         - ms
   * @param {boolean} [settings.rejectUnauthorized=false] - disable TLS verify (lab)
   */
  constructor({
    proxmox_api_url,
    proxmox_api_token_id,
    proxmox_api_token_name,
    proxmox_api_token_secret,
    proxmox_node,
    timeout = 15000,
    rejectUnauthorized = false,
  }) {
    if (!proxmox_api_url) throw new Error('proxmox_api_url manquant');
    if (!proxmox_api_token_id || !proxmox_api_token_name || !proxmox_api_token_secret) {
      throw new Error('Jeton API Proxmox incomplet (id/name/secret)');
    }

    this.baseURL = proxmox_api_url.replace(/\/$/, ''); // retire le / final si présent
    this.node = proxmox_node || null;

    const headers = {
      Authorization: `PVEAPIToken=${proxmox_api_token_id}!${proxmox_api_token_name}=${proxmox_api_token_secret}`,
    };

    this.http = axios.create({
      baseURL: this.baseURL,
      timeout,
      headers,
      httpsAgent: new https.Agent({ rejectUnauthorized }),
      maxContentLength: Infinity,
      maxBodyLength: Infinity,
    });
  }

  _normalizePath(path) {
    return path.startsWith('/') ? path : `/${path}`;
  }

  // Proxmox renvoie souvent { data: (...) }, on renvoie directement (...)
  _unwrap(payload) {
    if (payload && typeof payload === 'object' && 'data' in payload) {
      return payload.data;
    }
    return payload;
  }

  async request(method, path, { params, data } = {}) {
    try {
      const res = await this.http.request({
        method,
        url: this._normalizePath(path),
        params,
        data,
        // Laisse axios lever en cas de !2xx
        validateStatus: (s) => s >= 200 && s < 300,
      });
      return this._unwrap(res.data);
    } catch (err) {
      const status = err.response?.status;
      const raw = err.response?.data;
      const details = this._unwrap(raw);
      const pmxMsg =
        (details && (details.errors || details.message)) ||
        (typeof raw === 'string' ? raw : null);
      const msg = pmxMsg || err.message || 'Erreur inconnue';

      const e = new Error(
        `Proxmox ${method.toUpperCase()} ${this._normalizePath(path)}${
          status ? ` (HTTP ${status})` : ''
        }: ${msg}`
      );
      e.status = status ?? null;
      e.data = details ?? raw ?? null;
      e.original = err;
      throw e;
    }
  }

  get(path, params) {
    return this.request('get', path, { params });
  }

  post(path, data) {
    return this.request('post', path, { data });
  }

  put(path, data) {
    return this.request('put', path, { data });
  }

  delete(path, params) {
    return this.request('delete', path, { params });
  }
}

module.exports = { ProxmoxService };
