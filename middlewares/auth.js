
require("dotenv").config()
const jwt = require("jsonwebtoken")
const secret = process.env.JWT_SECRET

const createToken = (user, expiresIn = process.env.JWT_EXPIRES_IN || "1h") => {
  const payload = { id: user.id, email: user.email, role: user.role }
  return jwt.sign(payload, secret, { expiresIn })
}

const verifyToken = (req, res, next) => {
  const authHeader = req.headers["authorization"]
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Token manquant ou invalide." })
  }
  const token = authHeader.split(" ")[1]
  jwt.verify(token, secret, (err, decoded) => {
    if (err) return res.status(403).json({ message: "Token invalide." })
    req.user = decoded
    next()
  })
}

const checkRole = (roles) => (req, res, next) => {
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ message: "Accès refusé." })
  }
  next()
}

module.exports = { createToken, verifyToken, checkRole }