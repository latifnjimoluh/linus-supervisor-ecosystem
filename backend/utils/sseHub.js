// backend/utils/sseHub.js
const clients = new Map(); // instance_id -> Set<res>

function addClient(instanceId, res) {
  if (!clients.has(instanceId)) clients.set(instanceId, new Set());
  clients.get(instanceId).add(res);
}

function removeClient(instanceId, res) {
  const set = clients.get(instanceId);
  if (!set) return;
  set.delete(res);
  if (set.size === 0) clients.delete(instanceId);
}

// Publie un event pour un instanceId donné
function publish(instanceId, event, data) {
  const set = clients.get(instanceId);
  if (!set) return;
  const payload = typeof data === "string" ? data : JSON.stringify(data);
  for (const res of set) {
    res.write(`event: ${event}\n`);
    res.write(`data: ${payload}\n\n`);
  }
}

// (Optionnel) Broadcast à tous les clients, tous instanceIds
function broadcast(event, data) {
  const payload = typeof data === "string" ? data : JSON.stringify(data);
  for (const [, set] of clients.entries()) {
    for (const res of set) {
      res.write(`event: ${event}\n`);
      res.write(`data: ${payload}\n\n`);
    }
  }
}

module.exports = { addClient, removeClient, publish, broadcast };
