const fs = require('fs');
const { getRemoteFileContent, getRemoteJSON } = require('../../utils/sshClient');
const { Monitoring, UserSetting, Deployment } = require('../../models');

exports.collectMonitoringData = async (req, res) => {
  const user = req.user;
  const { vm_ip, username } = req.body;

  if (!vm_ip) {
    return res.status(400).json({ message: '❌ vm_ip requis' });
  }

  const settings = await UserSetting.findOne({ where: { user_id: user.id } });

  const sshUser = username || settings?.proxmox_ssh_user;
  const privateKeyPath = settings?.ssh_private_key_path;
  const statusPath = settings?.statuspath || '/tmp/status.json';
  const servicesPath = settings?.servicespath || '/tmp/services_status.json';
  const instanceInfoPath = settings?.instanceinfopath || '/etc/instance-info.conf';

  if (!sshUser || !privateKeyPath) {
    return res.status(400).json({ message: '❌ Informations SSH incomplètes' });
  }

  let privateKey;
  try {
    privateKey = fs.readFileSync(privateKeyPath);
  } catch (err) {
    return res.status(500).json({ message: '❌ Lecture de la clé privée impossible', error: err.message });
  }

  try {
    console.log("🔐 Connexion SSH avec :");
    console.log("- host :", vm_ip);
    console.log("- username :", sshUser);
    console.log("- privateKeyPath :", privateKeyPath);
    console.log("- instanceInfoPath :", instanceInfoPath);

    const instanceInfoRaw = await getRemoteFileContent({
      host: vm_ip,
      username: sshUser,
      privateKey,
      filePath: instanceInfoPath,
    });
    const instanceId =
      instanceInfoRaw
        .split('\n')
        .find((l) => l.includes('INSTANCE_ID'))
        ?.split('=')[1]
        ?.trim() || instanceInfoRaw.trim();

    const servicesStatus = await getRemoteJSON({
      host: vm_ip,
      username: sshUser,
      privateKey,
      filePath: servicesPath,
    });

    const systemStatus = await getRemoteJSON({
      host: vm_ip,
      username: sshUser,
      privateKey,
      filePath: statusPath,
    });

    const record = await Monitoring.create({
      vm_ip,
      ip_address: systemStatus.ip_address,
      instance_id: instanceId,
      services_status: servicesStatus,
      system_status: systemStatus,
      retrieved_at: new Date(),
    });

    // 🔄 Synchroniser l'adresse IP dans la table deployments si elle a changé
    const deployment = await Deployment.findOne({ where: { instance_id: instanceId } });
    if (deployment && deployment.vm_ip !== systemStatus.ip_address) {
      await deployment.update({ vm_ip: systemStatus.ip_address });
    }

    return res.status(200).json({
      message: '✅ Données de monitoring récupérées',
      record,
    });
  } catch (err) {
    console.error('❌ collectMonitoringData error:', err.message);
    return res.status(500).json({
      message: '❌ Échec de la collecte des données de monitoring',
      error: err.message,
    });
  }
};

// 📋 Lister tous les enregistrements de monitoring
exports.getMonitoringRecords = async (req, res) => {
  try {
    const records = await Monitoring.findAll({ order: [['retrieved_at', 'DESC']] });
    res.json(records);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération des données', error: err.message });
  }
};

// 📄 Récupérer un enregistrement précis
exports.getMonitoringRecordById = async (req, res) => {
  try {
    const record = await Monitoring.findByPk(req.params.id);
    if (!record) return res.status(404).json({ message: 'Enregistrement introuvable' });
    res.json(record);
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la récupération', error: err.message });
  }
};

// 🔁 Mettre à jour l'IP d'une VM dans la table deployments
exports.syncDeploymentIP = async (req, res) => {
  const { instance_id, vm_ip } = req.body;
  if (!instance_id || !vm_ip) {
    return res.status(400).json({ message: 'instance_id et vm_ip requis' });
  }
  try {
    const deployment = await Deployment.findOne({ where: { instance_id } });
    if (!deployment) {
      return res.status(404).json({ message: 'Déploiement introuvable' });
    }
    const updated = deployment.vm_ip !== vm_ip;
    if (updated) await deployment.update({ vm_ip });
    res.json({ message: 'Synchronisation effectuée', updated });
  } catch (err) {
    res.status(500).json({ message: 'Erreur lors de la synchronisation', error: err.message });
  }
};
