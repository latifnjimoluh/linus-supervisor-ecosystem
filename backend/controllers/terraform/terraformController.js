// controllers/terraform/terraformController.js
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const { ServiceTemplate, GeneratedScript, UserSetting, Deployment } = require('../../models');
const { checkIfVMNameExists } = require('../proxmox/proxmoxController');
const { runTerraformApplyStream } = require('../../utils/terraformRunner');
const { logAction } = require('../../middlewares/log');
const axios = require('axios');
const https = require('https');
const isUUID = (v) =>
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(v);

  
exports.deploy = async (req, res) => {
  const user = req.user;
  console.log('📨 [API] Requête de déploiement reçue par :', user?.email);

  const payload = { ...req.body };

  // Normalisation des noms (string CSV ou array)
  const allNames = Array.isArray(payload.vm_names)
    ? payload.vm_names
    : String(payload.vm_names || '')
        .split(',')
        .map(s => s.trim())
        .filter(Boolean);

  const vmName = allNames[0];

  // Validation des noms (sans espace; lettres/chiffres/.-)
  const invalid = allNames.find(n => !/^[A-Za-z0-9.-]+$/.test(n));
  if (invalid) {
    return res.status(400).json({
      message: `❌ Nom de VM invalide: "${invalid}". Utilisez uniquement lettres, chiffres, '-' ou '.', sans espace.`,
    });
  }

  const service_type = payload.service_type;
  let zone = payload.zone || 'LAN';

  if (!service_type) {
    return res.status(400).json({ message: "❌ Champ 'service_type' requis" });
  }
  if (!['LAN', 'DMZ', 'WAN', 'MGMT'].includes(zone)) {
    return res.status(400).json({ message: "❌ Champ 'zone' invalide (LAN, DMZ, WAN, MGMT)" });
  }
  if (!vmName) {
    return res.status(400).json({ message: "❌ Aucun nom de VM fourni (vm_names)" });
  }

  try {
    const startTime = new Date();
    const instanceId = uuidv4();
    const service_name = service_type;

    // Paramètres globaux utilisateur
    const userSettings = await UserSetting.findOne({ where: { user_id: user.id } });
    if (!userSettings) {
      return res.status(400).json({
        message: '⚠️ Paramètres globaux utilisateur manquants (via /api/settings).',
      });
    }

    // Hydrate payload à partir des user settings si non fournis
    Object.assign(payload, {
      cloudinit_user: payload.cloudinit_user || userSettings.cloudinit_user,
      cloudinit_password: payload.cloudinit_password || userSettings.cloudinit_password,
      proxmox_api_url: payload.proxmox_api_url || userSettings.proxmox_api_url,
      proxmox_api_token_id: payload.proxmox_api_token_id || userSettings.proxmox_api_token_id,
      proxmox_api_token_name: payload.proxmox_api_token_name || userSettings.proxmox_api_token_name,
      proxmox_api_token_secret: payload.proxmox_api_token_secret || userSettings.proxmox_api_token_secret,
      pm_user: payload.pm_user || userSettings.pm_user,
      pm_password: payload.pm_password || userSettings.pm_password,
      proxmox_node: payload.proxmox_node || userSettings.proxmox_node,
      vm_storage: payload.vm_storage || userSettings.vm_storage,
      vm_bridge: payload.vm_bridge || userSettings.vm_bridge,
      ssh_public_key_path: payload.ssh_public_key_path || userSettings.ssh_public_key_path,
      ssh_private_key_path: payload.ssh_private_key_path || userSettings.ssh_private_key_path,
    });

    // Validation du nom d'utilisateur cloud-init
    const userRegex = /^[a-z_][a-z0-9_-]{0,31}$/;
    if (payload.cloudinit_user && !userRegex.test(payload.cloudinit_user)) {
      return res.status(400).json({
        message: `❌ Nom d'utilisateur invalide: "${payload.cloudinit_user}". Utilisez uniquement des lettres minuscules, chiffres, '-' ou '_' et commencez par une lettre.`,
      });
    }

    // Vérif nom VM déjà existant (sur le premier nom demandé)
    const proxmoxCreds = {
      proxmox_api_url: payload.proxmox_api_url,
      proxmox_api_token_id: payload.proxmox_api_token_id,
      proxmox_api_token_name: payload.proxmox_api_token_name,
      proxmox_api_token_secret: payload.proxmox_api_token_secret,
      proxmox_node: payload.proxmox_node, // facultatif mais utile
    };
    const nameAlreadyExists = await checkIfVMNameExists(proxmoxCreds, vmName);


    // Vérification des capacités du nœud (disque, RAM, CPU)
    try {
      const headers = {
        Authorization: `PVEAPIToken=${payload.proxmox_api_token_id}!${payload.proxmox_api_token_name}=${payload.proxmox_api_token_secret}`,
      };
      const httpsAgent = new https.Agent({ rejectUnauthorized: false });

      const diskRequested = parseInt(String(payload.disk_size).replace(/\D/g, ''), 10);

      // Taille minimale du template
      const vmListUrl = `${payload.proxmox_api_url}/cluster/resources?type=vm`;
      const vmListResp = await axios.get(vmListUrl, { httpsAgent, headers });
      const tmplInfo = Array.isArray(vmListResp.data?.data)
        ? vmListResp.data.data.find(
            (v) => v.template === 1 && v.name === payload.template_name
          )
        : null;
      const tmplDisk = tmplInfo ? Math.floor((tmplInfo.maxdisk || 0) / (1024 ** 3)) : 0;
      if (tmplDisk && Number.isFinite(diskRequested) && diskRequested < tmplDisk) {
        return res.status(400).json({
          message: `Taille disque minimale : ${tmplDisk} Go pour le template ${payload.template_name}`,
          min_disk: tmplDisk,
        });
      }

      // Disque disponible
      const storageUrl = `${payload.proxmox_api_url}/nodes/${payload.proxmox_node}/storage/${payload.vm_storage}/status`;
      const storageResp = await axios.get(storageUrl, { httpsAgent, headers });
      const diskAvail = Math.floor((storageResp.data?.data?.avail || 0) / (1024 ** 3));
      if (Number.isFinite(diskRequested) && diskRequested > diskAvail) {
        return res.status(400).json({
          message: `Espace disponible : ${diskAvail} Go – Taille VM demandée : ${diskRequested} Go`,
          suggested_size: diskAvail,
        });
      }

      // RAM
      const statusUrl = `${payload.proxmox_api_url}/nodes/${payload.proxmox_node}/status`;
      const statusResp = await axios.get(statusUrl, { httpsAgent, headers });
      const memTotal = statusResp.data?.data?.memory?.total || 0;
      const memUsed = statusResp.data?.data?.memory?.used || 0;
      const memFreeMb = Math.floor((memTotal - memUsed) / (1024 ** 2));
      const memRequested = payload.memory_mb;
      if (Number.isFinite(memRequested) && memRequested > memFreeMb) {
        return res.status(400).json({
          message: `RAM disponible : ${memFreeMb} Mo – RAM demandée : ${memRequested} Mo`,
          suggested_ram: memFreeMb,
        });
      }

      // CPU
      const totalCores = statusResp.data?.data?.cpuinfo?.cores || 0;
      const vmsUrl = `${payload.proxmox_api_url}/nodes/${payload.proxmox_node}/qemu`;
      const vmsResp = await axios.get(vmsUrl, { httpsAgent, headers });
      const usedCores = Array.isArray(vmsResp.data?.data)
        ? vmsResp.data.data.reduce((sum, vm) => sum + (vm.cores || 0) * (vm.sockets || 1), 0)
        : 0;
      const coresFree = totalCores - usedCores;
      const coresRequested = (payload.vcpu_cores || 0) * (payload.vcpu_sockets || 1);
      if (Number.isFinite(coresRequested) && coresRequested > coresFree) {
        return res.status(400).json({
          message: `CPU disponible : ${coresFree} coeurs – CPU demandée : ${coresRequested} coeurs`,
          suggested_cores: coresFree,
        });
      }
    } catch (e) {
      console.warn('⚠️ Impossible de vérifier les capacités du nœud :', e.message);
    }

    // Résolution des scripts (accepte 'template' ou 'config' pour ServiceTemplate)
    const scriptModels = { config: ServiceTemplate, template: ServiceTemplate, script: GeneratedScript };
    const scriptRefs = Array.isArray(payload.script_refs) ? payload.script_refs : [];
    const scriptList = [];

    for (const ref of scriptRefs) {
      if (!ref) continue;
      const { type, id } = ref;
      const Model = scriptModels[type];
      if (!Model) continue;

      let record;
      if (id) {
        record = await Model.findByPk(id);
      } else {
        const where = (type === 'config' || type === 'template') ? { service_type } : {};
        record = await Model.findOne({ where, order: [['created_at', 'DESC']] });
      }

      if (!record) {
        return res.status(404).json({ message: `Script '${type}' introuvable` });
      }
      if (!record.abs_path) {
        return res.status(500).json({ message: `Le champ 'abs_path' est manquant pour le script ID ${id}` });
      }

      scriptList.push(record.abs_path.replace(/\\/g, '/'));
    }

    // Mapping VM -> scripts
    payload.instance_id = instanceId;
    payload.vm_names = allNames; // assure l’array
    payload.scripts = Object.fromEntries(allNames.map((name) => [name, scriptList]));

    // Informations pour la bannière/log dans le runner
    payload._meta = {
      user_email: user.email,
      vm_name: vmName,
      service_name,
      started_at: startTime.toISOString(),
    };

    // Préparer le log file + entrée DB "pending"
    const logsDir = path.resolve(__dirname, '../../logs');
    if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir, { recursive: true });
    const logPath = path.resolve(logsDir, `deploy-${instanceId}.log`);

    // Entête de log immédiat pour que l’UI voie quelque chose tout de suite
    try {
      fs.appendFileSync(
        logPath,
        `==== DÉPLOIEMENT ${service_name} ====\n📅 Début : ${startTime.toISOString()}\n👤 User: ${user.email}\n🔧 VM: ${vmName}\n\n`
      );
    } catch (e) {
      console.warn('⚠️ Impossible d’écrire le header du log :', e.message);
    }

    const dep = await Deployment.create({
      user_id: user.id,
      user_email: user.email,
      vm_name: vmName,
      service_name,
      zone,
      operation_type: 'apply',
      started_at: startTime,
      ended_at: null,
      duration: null,
      success: null,
      log_path: logPath,
      vm_id: null,
      vm_ip: null,
      vm_username: payload.cloudinit_user || null,
      instance_id: instanceId,
      injected_files: scriptList,
      vm_specs: {
        template_name: payload.template_name || 'ubuntu-template',
        memory_mb: payload.memory_mb || 2048,
        vcpu_cores: payload.vcpu_cores || 2,
        vcpu_sockets: payload.vcpu_sockets || 1,
        disk_size: payload.disk_size || '20G',
      },
      status: 'pending',
    });

    // 🔁 Répond IMMÉDIATEMENT pour débloquer l'UI
    res.status(202).json({ instance_id: instanceId });

    // 🚀 Lancer Terraform en arrière-plan (stream logs via SSE + tee vers logPath)
    (async () => {
      try {
        const { vmInfo, success } = await runTerraformApplyStream(instanceId, payload, logPath);

        const endTime = new Date();
        const durationSec = Math.round((endTime - startTime) / 1000);

        await dep.update({
          ended_at: endTime,
          duration: `${durationSec}s`,
          success,
          vm_id: vmInfo?.vm_ids?.[vmName] || null,
          vm_ip: vmInfo?.vm_ips?.[vmName] || null,
          status: success ? 'success' : 'failed',
        });

        await logAction(req, 'Déploiement Terraform', {
          vm_name: vmName,
          service_type,
          success,
          log_path: logPath,
        });

      } catch (error) {
        const endTime = new Date();
        const durationSec = Math.round((endTime - startTime) / 1000);

        // Friendly code/message si fournis par le runner
        const errCode = error?.code || 'TF_APPLY_FAILED';
        const errMsg  = error?.message || 'Le déploiement a échoué.';

        await dep.update({
          ended_at: endTime,
          duration: `${durationSec}s`,
          success: false,
          status: 'failed',
        });

        // Append au fichier log
        try {
          fs.appendFileSync(logPath, `\n❌ Échec: ${errCode} - ${errMsg}\n`);
        } catch (e) {
          console.warn('⚠️ Impossible d’appender l’erreur au log :', e.message);
        }

        // Audit interne
        await logAction(req, 'Échec Déploiement Terraform', { code: errCode, message: errMsg });

        console.error('❌ Job déploiement (async) :', error);
      }
    })();
  } catch (error) {
    console.error('❌ Erreur synchrone :', error);
    return res.status(500).json({
      message: '❌ Échec du lancement de déploiement',
      error: error.message,
    });
  }
};
