let WebSocketServer;
try {
  ({ WebSocketServer } = require('ws'));
} catch {
  WebSocketServer = null;
}
const url = require('url');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');
const { Client } = require('ssh2');
const { UserSetting, Deployment } = require('../models');

function init(server) {
  if (!WebSocketServer) return; // ws not available
  const wss = new WebSocketServer({ noServer: true });

  server.on('upgrade', (request, socket, head) => {
    const { pathname } = url.parse(request.url);
    if (pathname !== '/terminal/ws') return;

    wss.handleUpgrade(request, socket, head, (ws) => {
      wss.emit('connection', ws, request);
    });
  });

  wss.on('connection', async (ws, request) => {
    const { query } = url.parse(request.url, true);
    const { token, vm_id, ssh_user } = query;
    if (!token || !vm_id || !ssh_user) {
      ws.close();
      return;
    }

    try {
      const payload = jwt.verify(token, process.env.JWT_SECRET);
      const userId = payload.id;

      const deployment = await Deployment.findOne({
        where: { vm_id: String(vm_id), user_id: userId },
        order: [['id', 'DESC']],
      });
      if (!deployment?.vm_ip) {
        ws.close();
        return;
      }

      const settings = await UserSetting.findOne({ where: { user_id: userId } });
      if (!settings?.ssh_private_key_path) {
        ws.close();
        return;
      }
      const key = fs.readFileSync(path.resolve(settings.ssh_private_key_path), 'utf-8');

      const conn = new Client();
      conn
        .on('ready', () => {
          conn.shell((err, stream) => {
            if (err) {
              ws.close();
              conn.end();
              return;
            }
            ws.on('message', (data) => stream.write(data));
            stream.on('data', (data) => ws.send(data.toString('utf-8')));
            stream.stderr.on('data', (data) => ws.send(data.toString('utf-8')));
            stream.on('close', () => {
              ws.close();
              conn.end();
            });
          });
        })
        .on('error', () => ws.close())
        .connect({ host: deployment.vm_ip, username: ssh_user, privateKey: key });

      ws.on('close', () => conn.end());
    } catch (e) {
      ws.close();
    }
  });
}

module.exports = { init };
