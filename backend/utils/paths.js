// utils/paths.js (ou dans ton fichier actuel en haut)
const path = require('path')

const SAFE_LOGS_BASE =
  process.env.LOGS_BASE_DIR
  || path.resolve(__dirname, '../../logs')

// Vérifie si target est "dans" base, sans traversée
function isPathInside(base, target) {
  const rel = path.relative(path.resolve(base), path.resolve(target))
  return !!rel && !rel.startsWith('..') && !path.isAbsolute(rel)
}

// Normalise et sécurise un chemin depuis la BD
function resolveSafePath(maybePath) {
  if (!maybePath || typeof maybePath !== 'string') return null

  // Si relatif -> on résout depuis la base
  if (!path.isAbsolute(maybePath)) {
    const resolved = path.resolve(SAFE_LOGS_BASE, maybePath)
    return isPathInside(SAFE_LOGS_BASE, resolved) ? resolved : null
  }

  // Si absolu -> on l'accepte uniquement s’il reste dans la base
  const resolvedAbs = path.resolve(maybePath)
  return isPathInside(SAFE_LOGS_BASE, resolvedAbs) ? resolvedAbs : null
}

module.exports = { SAFE_LOGS_BASE, resolveSafePath }
