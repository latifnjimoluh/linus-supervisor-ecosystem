const { Deployment } = require("../../models");
const { addClient, removeClient, publish } = require("../../utils/sseHub");

const isUUID = (v) => /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(v);

exports.stream = async (req, res) => {
  const { id } = req.params;

  const where = isUUID(id) ? { instance_id: id } : { id: Number(id) };
  const dep = await Deployment.findOne({ where });
  if (!dep) return res.status(404).end();

  // Headers SSE
  res.writeHead(200, {
    "Content-Type": "text/event-stream",
    "Cache-Control": "no-cache, no-transform",
    "Connection": "keep-alive",
    "X-Accel-Buffering": "no", // utile derrière nginx
  });
  res.write("\n");

  // Abonnement
  addClient(dep.instance_id, res);

  // Envoyer l’état courant immédiatement
  publish(dep.instance_id, "status", { status: dep.status });

  // Cleanup à la fermeture
  req.on("close", () => removeClient(dep.instance_id, res));
};
