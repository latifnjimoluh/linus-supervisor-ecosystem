const { UserSetting } = require("../../models");

exports.getUserSettings = async (req, res) => {
  const userId = req.user?.id;

  try {
    const settings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!settings) {
      return res.status(404).json({ message: "Aucun paramètre défini pour cet utilisateur." });
    }

    return res.status(200).json(settings);
  } catch (err) {
    console.error("❌ Erreur lors de la récupération des paramètres :", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

exports.updateUserSettings = async (req, res) => {
  const userId = req.user?.id;
  const updates = req.body;

  try {
    let settings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!settings) {
      return res.status(404).json({ message: "Paramètres non trouvés. Veuillez d'abord les créer." });
    }

    await settings.update(updates);

    return res.status(200).json({ message: "Paramètres mis à jour avec succès", settings });
  } catch (err) {
    console.error("❌ Erreur lors de la mise à jour des paramètres :", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

exports.createUserSettings = async (req, res) => {
  const userId = req.user?.id;
  const data = req.body;

  try {
    const existing = await UserSetting.findOne({ where: { user_id: userId } });
    if (existing) {
      return res.status(400).json({ message: "Les paramètres existent déjà pour cet utilisateur." });
    }

    const settings = await UserSetting.create({ user_id: userId, ...data });

    return res.status(201).json({ message: "Paramètres créés avec succès", settings });
  } catch (err) {
    console.error("❌ Erreur lors de la création des paramètres :", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};
