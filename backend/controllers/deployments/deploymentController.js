const fs = require("fs");
const path = require("path");
const { Deployment } = require("../../models");

const isUUID = (v) =>
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(v);

exports.getById = async (req, res) => {
  try {
    const { id } = req.params;

    let dep = null;
    if (isUUID(id)) {
      dep = await Deployment.findOne({ where: { instance_id: id } });
    } else {
      const pk = Number(id);
      if (!Number.isFinite(pk)) {
        return res.status(400).json({ message: "Paramètre id invalide." });
      }
      dep = await Deployment.findByPk(pk);
    }

    if (!dep) {
      return res.status(404).json({ message: "Déploiement introuvable" });
    }

    let log = null;
    if (dep.log_path) {
      try {
        const absPath = path.isAbsolute(dep.log_path)
          ? dep.log_path
          : path.resolve(process.cwd(), dep.log_path);
        if (fs.existsSync(absPath)) {
          log = fs.readFileSync(absPath, "utf8");
        }
      } catch {
        log = null; // on n’échoue pas si le log est illisible
      }
    }

    return res.json({
      id: dep.id,
      vm_name: dep.vm_name,
      template: dep.service_name,
      status: dep.status || (dep.success ? "completed" : "failed"),
      started_at: dep.started_at,
      ended_at: dep.ended_at,
      log,
    });
  } catch (err) {
    console.error("getById error:", err); // aide debug serveur
    return res
      .status(500)
      .json({ message: "Erreur lors de la récupération du déploiement", error: err.message });
  }
};
