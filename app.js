
require("dotenv").config()
const express = require("express")
const cors = require("cors")
const morgan = require("morgan")
const helmet = require("helmet")
const compression = require("compression")
const cookieParser = require("cookie-parser")
const db = require("./config/db")
const routes = require("./routes")
const logAllActions = require("./middlewares/logAllActions")

const app = express()

// Middleware sécurité & logs
app.use(cors())
app.use(morgan("dev"))
app.use(helmet())
app.use(compression())
app.use(express.json())
app.use(cookieParser())
app.use(logAllActions)

// Routes API
app.use("/api", routes)

// Accueil
app.get("/", (req, res) => {
  res.send("✅ API Linusupervision opérationnelle")
})

// Gestion des erreurs
app.use((req, res) => {
  res.status(404).json({ message: "Route non trouvée." })
})

// Lancement du serveur
const PORT = process.env.PORT || 5000
app.listen(PORT, () => {
  console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`)
})
