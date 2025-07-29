const fs = require("fs");
const path = require("path");
const { ServiceTemplate } = require("../../models");

exports.createTemplate = async (req, res) => {
  const { name, service_type, description, template_content } = req.body;

  if (!name || !service_type || !template_content) {
    return res.status(400).json({ message: "Champs obligatoires manquants." });
  }

  try {
    const dir = path.resolve(__dirname, "../../generated-templates");
    if (!fs.existsSync(dir)) fs.mkdirSync(dir);

    const filename = `${name.replace(/\s+/g, "_").toLowerCase()}.tmpl.sh`;
    const fullPath = path.join(dir, filename);

    // ✍️ Écriture du fichier .tmpl.sh
    fs.writeFileSync(fullPath, template_content);

    // 📦 Enregistrement en base
    const newTemplate = await ServiceTemplate.create({
      name,
      service_type,
      description,
      template_path: fullPath
    });

    return res.status(201).json({ message: "Template créé avec succès", template: newTemplate });
  } catch (error) {
    console.error("❌ Erreur création template :", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
