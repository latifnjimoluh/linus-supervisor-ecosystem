const { AiCache } = require('../../models');
const { logAction } = require('../../middlewares/log');

exports.list = async (req, res) => {
  try {
    const caches = await AiCache.findAll();
    res.json(caches);
  } catch (err) {
    console.error('Erreur list AiCache:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.getById = async (req, res) => {
  try {
    const cache = await AiCache.findByPk(req.params.id);
    if (!cache) return res.status(404).json({ message: 'Entrée non trouvée' });
    res.json(cache);
  } catch (err) {
    console.error('Erreur getById AiCache:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.create = async (req, res) => {
  try {
    const entry = await AiCache.create(req.body);
    await logAction(req, `ai_cache_create:${entry.id}`);
    res.status(201).json(entry);
  } catch (err) {
    console.error('Erreur create AiCache:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.update = async (req, res) => {
  try {
    const cache = await AiCache.findByPk(req.params.id);
    if (!cache) return res.status(404).json({ message: 'Entrée non trouvée' });
    await cache.update(req.body);
    await logAction(req, `ai_cache_update:${cache.id}`);
    res.json(cache);
  } catch (err) {
    console.error('Erreur update AiCache:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.remove = async (req, res) => {
  try {
    const cache = await AiCache.findByPk(req.params.id);
    if (!cache) return res.status(404).json({ message: 'Entrée non trouvée' });
    await cache.destroy();
    await logAction(req, `ai_cache_delete:${cache.id}`);
    res.json({ message: 'Entrée supprimée' });
  } catch (err) {
    console.error('Erreur delete AiCache:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};
