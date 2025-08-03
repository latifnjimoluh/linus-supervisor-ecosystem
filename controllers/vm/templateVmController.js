const fs = require("fs");
const path = require("path");
const { execSSHCommand } = require("../../utils/sshClient");
const { UserSetting, ConvertedVm, User } = require("../../models");
const { Op } = require("sequelize");

exports.convertToTemplate = async (req, res) => {
  const user = req.user;
  const userId = user?.id;
  const { vm_id, host: bodyHost, username: bodyUsername, privateKeyPath: bodyKeyPath } = req.body;

  if (!vm_id) {
    return res.status(400).json({ message: "❌ vm_id requis" });
  }

  // 🧠 Récupération des paramètres depuis la BD si non fournis
  let host = bodyHost;
  let username = bodyUsername;
  let privateKeyPath = bodyKeyPath;

  try {
    const userSettings = await UserSetting.findOne({ where: { user_id: userId } });

    if (!userSettings) {
      return res.status(404).json({ message: "❌ Paramètres utilisateur introuvables" });
    }

    host = host || userSettings.proxmox_host;
    username = username || userSettings.proxmox_ssh_user;
    privateKeyPath = privateKeyPath || userSettings.ssh_private_key_path;

    if (!host || !username || !privateKeyPath) {
      return res.status(400).json({ message: "❌ host, username ou privateKeyPath manquant même après fallback" });
    }

    const privateKey = fs.readFileSync(path.resolve(privateKeyPath), "utf-8");
    const startTime = new Date();

    const logFileName = `convert-template-${startTime.toISOString().replace(/[:.]/g, "-")}-${userId}.log`;
    const logsDir = path.resolve(__dirname, "../logs"); // Dossier juste avant la racine
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.join(logsDir, logFileName);

    let outputLog = `=== CONVERSION TEMPLATE VM ${vm_id} ===\n📅 Date : ${startTime.toISOString()}\n`;

    const cmds = [
      `qm stop ${vm_id}`,
      `qm set ${vm_id} --ide2 local-lvm:cloudinit`,
      `qm set ${vm_id} --boot order=scsi0`,
      `qm set ${vm_id} --agent enabled=1`,
      `qm template ${vm_id}`
    ];

    for (const cmd of cmds) {
      outputLog += `\n$ ${cmd}\n`;
      const result = await execSSHCommand({ host, username, privateKey, command: cmd });
      outputLog += result + "\n";
    }

    fs.writeFileSync(logPath, outputLog);

    const vm_name = req.body.vm_name || `vm_${vm_id}`;
    await ConvertedVm.create({ vm_name, vm_id, user_id: userId });

    return res.status(200).json({
      message: `✅ VM ${vm_id} convertie en template Cloud-Init`,
      output: outputLog,
      log: logPath
    });

  } catch (error) {
    const failTime = new Date();
    const logFileName = `convert-template-${failTime.toISOString().replace(/[:.]/g, "-")}-${userId}.log`;
    const logsDir = path.resolve(__dirname, "../logs");
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);
    const logPath = path.join(logsDir, logFileName);

    const errorLog = `=== ÉCHEC CONVERSION TEMPLATE VM ${vm_id} ===\n📅 Date : ${failTime.toISOString()}\n\nErreur : ${error.message || error}\n`;
    fs.writeFileSync(logPath, errorLog);

    return res.status(500).json({
      message: "❌ Échec de la conversion en template",
      error: error.message || error,
      log: logPath
    });
  }
};

exports.getConversionHistory = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || "created_at";
    const direction = req.query.order === "asc" ? "ASC" : "DESC";
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { vm_name: { [Op.iLike]: `%${q}%` } },
        { "$user.email$": { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await ConvertedVm.findAndCountAll({
      where,
      include: [{ model: User, as: "user", attributes: ["id", "email"] }],
      order: [[sort, direction]],
      limit,
      offset,
    });
    res.json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    console.error("Erreur history:", err);
    res.status(500).json({ message: "Erreur serveur." });
  }
};
