const fs = require("fs");
const path = require("path");
const { InitializationScript } = require("../../models");
const { Op } = require("sequelize");
const { getNextSequence } = require("../../utils/sequence");

exports.generateInitializationScript = async (req, res) => {
  try {
    const { name, description, content } = req.body;

    if (!name || !content) {
      return res.status(400).json({
        message: "Champs requis : name, content"
      });
    }

    // Générer un nom unique pour le fichier
    const outputDir = path.join(__dirname, "../../generated-scripts");
    const seq = getNextSequence(outputDir, "init-", ".sh");
    const filename = `init-${seq}.sh`;
    const outputPath = path.join(outputDir, filename);

    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    fs.writeFileSync(outputPath, content, { mode: 0o755 });

    // Enregistrer dans la base
    const savedScript = await InitializationScript.create({
      name,
      description: description || "",
      script_path: outputPath,
      service_type: "general"
    });

    return res.status(201).json({
      message: "✅ Script init généré et sauvegardé",
      script_id: savedScript.id,
      script_path: savedScript.script_path
    });

  } catch (error) {
    console.error("❌ Erreur génération init script :", error);
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

exports.listInitializationScripts = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || "created_at";
    const direction = req.query.order === "asc" ? "ASC" : "DESC";
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { service_type: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await InitializationScript.findAndCountAll({
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
    console.error("❌ Erreur list init scripts:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.updateInitializationScript = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await InitializationScript.findByPk(id);
    if (!record) return res.status(404).json({ message: "Script introuvable" });
    const { name, description } = req.body;
    if (name) record.name = name;
    if (description) record.description = description;
    await record.save();
    res.json({ message: "Script mis à jour", record });
  } catch (err) {
    console.error("❌ Erreur update init script:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.deleteInitializationScript = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await InitializationScript.findByPk(id);
    if (!record) return res.status(404).json({ message: "Script introuvable" });
    await record.destroy();
    res.json({ message: "Script supprimé" });
  } catch (err) {
    console.error("❌ Erreur delete init script:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};
