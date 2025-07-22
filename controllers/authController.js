const bcrypt = require("bcrypt")
const User = require("../models/user")
const { createToken } = require("../middlewares/auth")

exports.register = async (req, res) => {
  try {
    const { first_name, last_name, email, phone, password, role, status } = req.body

    const existing = await User.findOne({ where: { email } })
    if (existing) return res.status(400).json({ message: "Email déjà utilisé." })

    const hashedPassword = await bcrypt.hash(password, 10)

    const user = await User.create({
      first_name,
      last_name,
      email,
      phone,
      password: hashedPassword,
      role: role || "technicien",
      status: status || "active",
    })

    res.status(201).json({ message: "Utilisateur créé avec succès.", user })
  } catch (err) {
    console.error(err)
    res.status(500).json({ message: "Erreur serveur." })
  }
}

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body
    const user = await User.findOne({ where: { email } })

    if (!user) return res.status(401).json({ message: "Email ou mot de passe incorrect." })

    const match = await bcrypt.compare(password, user.password)
    if (!match) return res.status(401).json({ message: "Email ou mot de passe incorrect." })

    if (user.status !== "active") {
      return res.status(403).json({ message: `Compte ${user.status}.` })
    }

    const token = createToken(user)

    res.json({
      message: "Connexion réussie",
      token,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role,
      },
    })
  } catch (err) {
    console.error(err)
    res.status(500).json({ message: "Erreur lors de la connexion." })
  }
}