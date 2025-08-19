const { Log, User, Deployment } = require('../../models');
const { Op } = require('sequelize');
const fs = require('fs')
const mime = require('mime'); // npm i mime
const path = require('path')
const { resolveSafePath } = require('../../utils/paths')


const safeName = (s) => (s || 'log').toString()
  .toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9._-]/g, '')



// Get logs with search/sort applied before pagination
exports.getAllLogs = async (req, res) => {
  try {
    const {
      search = '',
      sort = 'timestamp',
      order = 'desc',
      page = 1,
      limit = 10,
      from,
      to,
    } = req.query;

    const sortFields = {
      timestamp: 'created_at',
      host: 'host',
      level: 'level',
      source: 'source',
    };

    const orderField = sortFields[sort] || 'created_at';
    const orderDirection = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';
    const pageInt = parseInt(page, 10);
    const limitInt = parseInt(limit, 10);
    const offset = (pageInt - 1) * limitInt;

    const where = {};
    if (search) {
      where[Op.or] = [
        { action: { [Op.iLike]: `%${search}%` } },
        { details: { [Op.iLike]: `%${search}%` } },
        { '$user.email$': { [Op.iLike]: `%${search}%` } },
      ];
    }
    if (from || to) {
      where.created_at = {};
      if (from) where.created_at[Op.gte] = new Date(from);
      if (to) where.created_at[Op.lte] = new Date(to);
    }

    const { rows, count } = await Log.findAndCountAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [[orderField, orderDirection]],
      limit: limitInt,
      offset,
      distinct: true,
    });

    const deriveType = (action = '') => {
      if (/deploy/i.test(action)) return 'deployment';
      if (/delete|destroy/i.test(action)) return 'deletion';
      if (/restart|reboot/i.test(action)) return 'restart';
      if (/user/i.test(action)) return 'user_creation';
      if (/role/i.test(action)) return 'role_change';
      return 'vm_action';
    };

    const deriveStatus = (details = '') => (/error|fail/i.test(details) ? 'error' : 'success');

    const items = rows.map((log) => ({
      id: log.id,
      action: log.action,
      type: deriveType(log.action),
      timestamp: log.created_at,
      user: log.user ? log.user.email : null,
      entity: null,
      status: deriveStatus(log.details),
      description: log.details || '',
      details: log.details || '',
      host: log.host || null,
      level: log.level || null,
      source: log.source || null,
      ip_address: null,
      vm_id: null,
    }));

    return res.json({
      items,
      total_after_filter: count,
      page: pageInt,
      limit: limitInt,
    });
  } catch (err) {
    console.error('❌ Erreur getAllLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// List deployment logs with server-side pagination
exports.getDeploymentLogs = async (req, res) => {
  try {
    const {
      search = '',
      sort = 'date',
      order = 'desc',
      page = 1,
      limit = 25,
    } = req.query;

    const sortFields = {
      date: 'started_at',
      instance_id: 'instance_id',
      status: 'status',
    };

    const orderField = sortFields[sort] || 'started_at';
    const orderDirection = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';
    const pageInt = parseInt(page, 10);
    const limitInt = parseInt(limit, 10);
    const offset = (pageInt - 1) * limitInt;

    const where = {};
    if (search) {
      where[Op.or] = [
        { vm_name: { [Op.iLike]: `%${search}%` } },
        { instance_id: { [Op.iLike]: `%${search}%` } },
        { status: { [Op.iLike]: `%${search}%` } },
        { '$user.email$': { [Op.iLike]: `%${search}%` } },
      ];
    }

    const { rows, count } = await Deployment.findAndCountAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [[orderField, orderDirection]],
      limit: limitInt,
      offset,
      distinct: true,
    });

    const items = rows.map((dep) => ({
      id: dep.id,
      instance_id: dep.instance_id,
      vm_name: dep.vm_name,
      status: dep.status || (dep.success === null ? 'pending' : dep.success ? 'success' : 'failed'),
      started_at: dep.started_at,
      ended_at: dep.ended_at,
      user: dep.user ? dep.user.email : null,
    }));

    return res.json({
      items,
      total_after_filter: count,
      page: pageInt,
      limit: limitInt,
    });
  } catch (err) {
    console.error('❌ Erreur getDeploymentLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// Export filtered logs as NDJSON
exports.exportLogs = async (req, res) => {
  try {
    const {
      search = '',
      sort = 'timestamp',
      order = 'desc',
      from,
      to,
      type,
      status,
    } = req.query;

    const sortFields = {
      timestamp: 'created_at',
      host: 'host',
      level: 'level',
      source: 'source',
    };

    const orderField = sortFields[sort] || 'created_at';
    const orderDirection = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

    const where = {};
    if (search) {
      where[Op.or] = [
        { action: { [Op.iLike]: `%${search}%` } },
        { details: { [Op.iLike]: `%${search}%` } },
        { '$user.email$': { [Op.iLike]: `%${search}%` } },
      ];
    }
    if (from || to) {
      where.created_at = {};
      if (from) where.created_at[Op.gte] = new Date(from);
      if (to) where.created_at[Op.lte] = new Date(to);
    }
    const MAX_EXPORT = 10000;
    const limitInt = Math.min(parseInt(req.query.limit, 10) || MAX_EXPORT, MAX_EXPORT);

    const logs = await Log.findAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [[orderField, orderDirection]],
      limit: limitInt,
    });

    const deriveType = (action = '') => {
      if (/deploy/i.test(action)) return 'deployment';
      if (/delete|destroy/i.test(action)) return 'deletion';
      if (/restart|reboot/i.test(action)) return 'restart';
      if (/user/i.test(action)) return 'user_creation';
      if (/role/i.test(action)) return 'role_change';
      return 'vm_action';
    };

    const deriveStatus = (details = '') => (/error|fail/i.test(details) ? 'error' : 'success');

    let items = logs.map((log) => ({
      id: log.id,
      action: log.action,
      type: deriveType(log.action),
      timestamp: log.created_at,
      user: log.user ? log.user.email : null,
      entity: null,
      status: deriveStatus(log.details),
      description: log.details || '',
      details: log.details || '',
      host: log.host || null,
      level: log.level || null,
      source: log.source || null,
      ip_address: null,
      vm_id: null,
    }));

    if (type) items = items.filter((l) => l.type === type);
    if (status) items = items.filter((l) => l.status === status);

    const payload = items.map((l) => JSON.stringify(l)).join('\n');

    const buffer = Buffer.from(payload, 'utf8');

    res.setHeader('Content-Type', 'application/x-ndjson');
    res.setHeader('Content-Disposition', 'attachment; filename="logs.ndjson"');
    res.setHeader('Content-Length', buffer.length);

    if (req.method === 'HEAD') {
      return res.status(200).end();
    }
    return res.send(buffer);
  } catch (err) {
    console.error('❌ Erreur exportLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};


exports.downloadLogById = async (req, res) => {
  try {
    const { id } = req.params

    const log = await Log.findByPk(id, {
      include: [{ model: User, as: 'user', attributes: ['email'] }],
    })
    if (!log) return res.status(404).json({ message: 'Log introuvable.' })

    // Essaie de trouver un champ chemin exploitable (adapte si besoin)
    const raw = log.log_path || log.file_path || log.path || null
    const resolved = resolveSafePath(raw)

    if (resolved && fs.existsSync(resolved) && fs.statSync(resolved).isFile()) {
      const stat = fs.statSync(resolved)
      const ext = path.extname(resolved).slice(1)
      const type = mime.getType(ext) || 'text/plain; charset=utf-8'

      const fallback =
        `${safeName(log.action)}_${new Date(log.created_at || Date.now())
          .toISOString().replace(/[:.]/g, '-')}.log`

      res.setHeader('Content-Type', type)
      res.setHeader('Content-Length', stat.size)
      res.setHeader('Content-Disposition', `attachment; filename="${encodeURIComponent(path.basename(resolved) || fallback)}"`)
      res.setHeader('X-Filename', path.basename(resolved) || fallback)
      res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition, X-Filename')

      return fs.createReadStream(resolved).pipe(res)
    }

    // Fallback : générer un petit fichier texte contenant les infos du log
    const payload = [
      `ID: ${log.id}`,
      `Action: ${log.action || ''}`,
      `Date: ${log.created_at ? new Date(log.created_at).toISOString() : ''}`,
      `Utilisateur: ${log.user ? log.user.email : ''}`,
      `Détails:`,
      (log.details || '').toString()
    ].join('\n')

    const buffer = Buffer.from(payload, 'utf8')
    const filename = `log-${log.id}.txt`

    res.setHeader('Content-Type', 'text/plain; charset=utf-8')
    res.setHeader('Content-Disposition', `attachment; filename="${encodeURIComponent(filename)}"`)
    res.setHeader('Content-Length', buffer.length)
    res.setHeader('X-Filename', filename)
    res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition, X-Filename')

    return res.send(buffer)
  } catch (err) {
    console.error('❌ Erreur downloadLogById:', err)
    return res.status(500).json({ message: 'Erreur serveur.' })
  }
}


/**
 * GET /logs/deployments/:id/view
 * Retourne le contenu texte du fichier de log associé à deployments.log_path
 */
exports.viewDeploymentLogById = async (req, res) => {
  try {
    const { id } = req.params
    const dep = await Deployment.findByPk(id)
    if (!dep) return res.status(404).json({ message: 'Déploiement introuvable.' })

    const filePath = dep.log_path
    const resolved = resolveSafePath(filePath)
    if (!resolved) {
      return res.status(400).json({ message: 'Chemin de log invalide ou non autorisé.' })
    }

    if (!fs.existsSync(resolved) || !fs.statSync(resolved).isFile()) {
      return res.status(404).json({ message: 'Fichier de log non trouvé.' })
    }

    res.setHeader('Content-Type', 'text/plain; charset=utf-8')
    const stream = fs.createReadStream(resolved, { encoding: 'utf8' })
    return stream.pipe(res)
  } catch (err) {
    console.error('❌ Erreur viewDeploymentLogById:', err)
    return res.status(500).json({ message: 'Erreur serveur.' })
  }
}

/**
 * GET /logs/deployments/:id/download
 * Télécharge le fichier de log associé à deployments.log_path
 */
exports.downloadDeploymentLogById = async (req, res) => {
  try {
    const { id } = req.params
    const dep = await Deployment.findByPk(id)
    if (!dep) return res.status(404).json({ message: 'Déploiement introuvable.' })

    const resolved = resolveSafePath(dep.log_path)
    if (!resolved) return res.status(400).json({ message: 'Chemin de log invalide ou non autorisé.' })
    if (!fs.existsSync(resolved) || !fs.statSync(resolved).isFile()) {
      return res.status(404).json({ message: 'Fichier de log non trouvé.' })
    }

    const stat = fs.statSync(resolved)
    const ext = path.extname(resolved).slice(1)
    const type = mime.getType(ext) || 'text/plain; charset=utf-8'

    const fallback =
      `${safeName(dep.vm_name || 'deployment')}_${new Date(dep.started_at || Date.now())
        .toISOString().replace(/[:.]/g, '-')}.log`

    res.setHeader('Content-Type', type)
    res.setHeader('Content-Length', stat.size)
    res.setHeader('Content-Disposition', `attachment; filename="${encodeURIComponent(path.basename(resolved) || fallback)}"`)
    res.setHeader('X-Filename', path.basename(resolved) || fallback)
    res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition, X-Filename')

    return fs.createReadStream(resolved).pipe(res)
  } catch (err) {
    console.error('❌ Erreur downloadDeploymentLogById:', err)
    return res.status(500).json({ message: 'Erreur serveur.' })
  }
}
