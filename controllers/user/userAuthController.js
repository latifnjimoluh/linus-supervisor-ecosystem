const bcrypt = require("bcrypt");
const { User, Role } = require("../../models");
const { createToken } = require("../../middlewares/auth");

exports.register = async (req, res) => {
  try {
    console.log("📥 Requête reçue (register):", req.body);
    const creator = req.user;

    const {
      first_name,
      last_name,
      email,
      phone,
      password,
      role_id,
      status
    } = req.body;

    // 💥 Vérifier que role_id est fourni
    if (!role_id) {
      console.log("❌ Aucun role_id fourni");
      return res.status(400).json({ message: "Le champ 'role_id' est obligatoire." });
    }

    // 🔍 Vérification unicité email
    const existing = await User.findOne({ where: { email } });
    if (existing) {
      console.log("⚠️ Email déjà utilisé:", email);
      return res.status(400).json({ message: "Email déjà utilisé." });
    }

    // 🔐 Vérification du rôle
    const role = await Role.findOne({ where: { id: role_id, status: "actif" } });
    if (!role) {
      console.log("❌ Rôle introuvable ou inactif:", role_id);
      return res.status(400).json({ message: `Rôle introuvable ou inactif.` });
    }

    console.log("✅ Rôle récupéré:", role.name);
    const creatorRoleName = creator?.role || "inconnu";
    console.log("🔐 Rôle du créateur:", creatorRoleName);

    if (["admin", "superadmin"].includes(role.name) && creatorRoleName !== "superadmin") {
      console.log("⛔ Tentative non autorisée de créer un compte sensible");
      return res.status(403).json({ message: "⛔ Seul un superadmin peut créer ce type de compte." });
    }


    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      first_name,
      last_name,
      email,
      phone,
      password: hashedPassword,
      role_id,
      status: status || "active",
    });

    console.log("✅ Utilisateur créé avec succès:", user.email);
    res.status(201).json({ message: "✅ Utilisateur créé avec succès", user });
  } catch (err) {
    console.error("🔥 Erreur serveur dans register:", err);
    res.status(500).json({ message: "Erreur serveur lors de l'enregistrement." });
  }
};


exports.login = async (req, res) => {
  try {
    console.log("🔐 Tentative de connexion:", req.body.email);
    const { email, password } = req.body;

    const user = await User.findOne({
      where: { email },
      include: [{ model: Role, as: "role" }],
    });

    if (!user) {
      console.log("❌ Utilisateur introuvable");
      return res.status(401).json({ message: "Email ou mot de passe incorrect." });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      console.log("❌ Mot de passe invalide pour:", email);
      return res.status(401).json({ message: "Email ou mot de passe incorrect." });
    }

    if (user.status !== "active") {
      console.log("⛔ Compte non actif:", user.status);
      return res.status(403).json({ message: `Compte ${user.status}.` });
    }

    console.log("✅ Connexion réussie. Rôle chargé:", user.role?.name);

    // 🧩 Injection manuelle pour permettre logUserAction de fonctionner
    req.user = {
      id: user.id,
      email: user.email,
      role: user.role?.name,
      role_id: user.role_id
    };

    const token = createToken({
      id: user.id,
      email: user.email,
      role_id: user.role?.id,
    });

    res.json({
      message: "Connexion réussie",
      token,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role?.name,
      },
    });
  } catch (err) {
    console.error("🔥 Erreur dans login:", err);
    res.status(500).json({ message: "Erreur lors de la connexion." });
  }
};
