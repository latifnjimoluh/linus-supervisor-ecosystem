// routes/terminal/sshRoutes.js
const express = require('express');
const router = express.Router();
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const { execSSHCommand, SshError } = require('../../utils/sshClient');
const { UserSetting } = require('../../models');

const SSH_TIMEOUT = parseInt(process.env.SSH_HANDSHAKE_TIMEOUT_MS || '10000', 10);

// POST /terminal/ssh/test
router.post('/ssh/test', verifyToken, checkPermission('vm.list'), logRequest, async (req, res) => {
  try {
    const { vm_id, ip, ssh_user } = req.body;
    if (!vm_id || !ip || !ssh_user) return res.status(400).json({ ok: false, message: 'vm_id, ip, ssh_user requis' });
    const s = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!s?.ssh_private_key_path) return res.status(400).json({ ok: false, message: 'Clé SSH manquante côté serveur' });

    const fs = require('fs'); const path = require('path');
    const key = fs.readFileSync(path.resolve(s.ssh_private_key_path), 'utf-8');

    // simple check: run 'echo ok'
    const { stdout } = await execSSHCommand({ host: ip, username: ssh_user, privateKey: key, command: 'echo ok', timeout: SSH_TIMEOUT });
    if (stdout.toLowerCase().includes('ok')) return res.json({ ok: true });
    return res.status(500).json({ ok: false, message: 'SSH ok mais commande de test a échoué' });
  } catch (e) {
    if (e instanceof SshError) {
      return res.status(e.httpStatus).json({ ok: false, code: e.code, message: e.message });
    }
    return res.status(500).json({ ok: false, message: e.message });
  }
});

// POST /terminal/ssh/exec
router.post('/ssh/exec', verifyToken, checkPermission('vm.list'), logRequest, async (req, res) => {
  try {
    const { vm_id, ip, ssh_user, command } = req.body;
    if (!vm_id || !ip || !ssh_user || !command) {
      return res.status(400).json({ message: 'vm_id, ip, ssh_user, command requis' });
    }
    const s = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!s?.ssh_private_key_path) return res.status(400).json({ message: 'Clé SSH manquante côté serveur' });

    const fs = require('fs'); const path = require('path');
    const key = fs.readFileSync(path.resolve(s.ssh_private_key_path), 'utf-8');

    const result = await execSSHCommand({ host: ip, username: ssh_user, privateKey: key, command, timeout: SSH_TIMEOUT });
    return res.json(result);
  } catch (e) {
    if (e instanceof SshError) {
      return res.status(e.httpStatus).json({ code: e.code, message: e.message });
    }
    return res.status(500).json({ message: e.message });
  }
});

module.exports = router;
