const fs = require("fs");
const path = require("path");
const { ConfigTemplate } = require("../../models");
const { Op } = require("sequelize");

exports.createTemplate = async (req, res) => {
  const { name, service_type, category = "autres", description, template_content } = req.body;

  // ✅ Vérification des champs requis
  if (!name || !service_type || !template_content) {
    return res.status(400).json({
      message: "Champs obligatoires manquants : name, service_type, template_content"
    });
  }

  try {
    // 📁 Chemin dynamique vers le dossier de la catégorie
    const baseDir = path.resolve(__dirname, "../../generated-templates");
    const categoryDir = path.join(baseDir, category.toLowerCase().replace(/\s+/g, "_"));

    if (!fs.existsSync(categoryDir)) {
      fs.mkdirSync(categoryDir, { recursive: true });
      console.log("📁 Nouveau dossier créé :", categoryDir);
    }

    // 📄 Générer le chemin du fichier
    const filename = `${name.replace(/\s+/g, "_").toLowerCase()}.tmpl.sh`;
    const fullPath = path.join(categoryDir, filename);

    // ✍️ Écriture du fichier
    fs.writeFileSync(fullPath, template_content);

    // 💾 Enregistrement dans la base
    const newTemplate = await ConfigTemplate.create({
      name,
      service_type,
      category,
      description,
      template_path: fullPath
    });

    return res.status(201).json({
      message: "✅ Template créé avec succès",
      template: newTemplate
    });

  } catch (error) {
    console.error("❌ Erreur création template :", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

exports.listTemplates = async (req, res) => {
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
    const { count, rows } = await ConfigTemplate.findAndCountAll({
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
    console.error("❌ Erreur list templates:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.updateTemplate = async (req, res) => {
  try {
    const { id } = req.params;
    const tpl = await ConfigTemplate.findByPk(id);
    if (!tpl) return res.status(404).json({ message: "Template introuvable" });
    const { name, description } = req.body;
    if (name) tpl.name = name;
    if (description) tpl.description = description;
    await tpl.save();
    res.json({ message: "Template mis à jour", template: tpl });
  } catch (err) {
    console.error("❌ Erreur update template:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.deleteTemplate = async (req, res) => {
  try {
    const { id } = req.params;
    const tpl = await ConfigTemplate.findByPk(id);
    if (!tpl) return res.status(404).json({ message: "Template introuvable" });
    await tpl.destroy();
    res.json({ message: "Template supprimé" });
  } catch (err) {
    console.error("❌ Erreur delete template:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};
