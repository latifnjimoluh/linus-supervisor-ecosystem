const fs = require("fs");
const path = require("path");
const { InitScript } = require("../../models");
const { v4: uuidv4 } = require("uuid");

exports.generateInitScript = async (req, res) => {
  try {
    const { name, description, content } = req.body;

    if (!name || !content) {
      return res.status(400).json({
        message: "Champs requis : name, content"
      });
    }

    // Générer un nom unique pour le fichier
    const filename = `init-${name.replace(/\s+/g, "_")}-${uuidv4()}.sh`;
    const outputDir = path.join(__dirname, "../../generated-scripts");
    const outputPath = path.join(outputDir, filename);

    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    fs.writeFileSync(outputPath, content, { mode: 0o755 });

    // Enregistrer dans la base
    const savedScript = await InitScript.create({
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
