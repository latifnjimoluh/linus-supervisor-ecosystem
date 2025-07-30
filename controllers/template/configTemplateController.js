const fs = require("fs");
const path = require("path");
const { ConfigTemplate } = require("../../models");

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
