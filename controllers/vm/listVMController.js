const { Op } = require("sequelize");
const { Deployment } = require("../../models");

function buildLister(status) {
  return async (req, res) => {
    try {
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 10;
      const offset = (page - 1) * limit;
      const sort = req.query.sort || "created_at";
      const direction = req.query.order === "asc" ? "ASC" : "DESC";
      const where = { status };
      if (req.query.q) {
        const q = req.query.q;
        where[Op.or] = [
          { vm_name: { [Op.iLike]: `%${q}%` } },
          { vm_ip: { [Op.iLike]: `%${q}%` } },
          { service_name: { [Op.iLike]: `%${q}%` } },
          { user_email: { [Op.iLike]: `%${q}%` } },
        ];
      }
      const { count, rows } = await Deployment.findAndCountAll({
        where,
        order: [[sort, direction]],
        limit,
        offset,
      });
      res.json({
        data: rows,
        pagination: {
          total: count,
          page,
          pages: Math.ceil(count / limit),
          limit,
        },
      });
    } catch (err) {
      console.error("Erreur listVMs:", err);
      res.status(500).json({ message: "Erreur serveur." });
    }
  };
}

exports.listDeployed = buildLister("deployed");
exports.listDestroyed = buildLister("destroyed");
