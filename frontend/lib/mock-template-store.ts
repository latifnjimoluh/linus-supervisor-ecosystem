import { type Template } from "@/lib/templates"

let _nextId = 100

function nextId() {
  _nextId += 1
  return _nextId
}

export const templates: Template[] = [
  {
    id: 1,
    name: "Activation des cronjobs de supervision",
    service_type: "monitoring_cron",
    category: "monitoring",
    description: "Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.",
    type: "template",
    script_path: "/scripts/register_cronjobs.sh",
    template_content: `#!/bin/bash

# 📍 Ce script centralise l’installation des cronjobs de monitoring

# 🔐 Vérifie que les scripts à exécuter existent
STATUS_SCRIPT="\${STATUS_SCRIPT}"
SERVICES_SCRIPT="\${SERVICES_SCRIPT}"

# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà
if [ -f "\$STATUS_SCRIPT" ]; then
  grep -q "\$STATUS_SCRIPT" /etc/crontab || echo "*/\${STATUS_CRON_INTERVAL} * * * * root \$STATUS_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour status.sh"
else
  echo "❌ Script \$STATUS_SCRIPT introuvable"
fi

if [ -f "\$SERVICES_SCRIPT" ]; then
  grep -q "\$SERVICES_SCRIPT" /etc/crontab || echo "*/\${SERVICES_CRON_INTERVAL} * * * * root \$SERVICES_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour services_status.sh"
else
  echo "❌ Script \$SERVICES_SCRIPT introuvable"
fi
`,
    fields_schema: {
      fields: [
        { name: "STATUS_SCRIPT", label: "Chemin script status", type: "text", required: true, default: "/opt/monitoring/status.sh" },
        { name: "SERVICES_SCRIPT", label: "Chemin script services", type: "text", required: true, default: "/opt/monitoring/services_status.sh" },
        { name: "STATUS_CRON_INTERVAL", label: "Fréquence status (min)", type: "number", required: true, default: 5 },
        { name: "SERVICES_CRON_INTERVAL", label: "Fréquence services (min)", type: "number", required: true, default: 5 },
      ],
    },
  },
  {
    id: 13,
    name: "Configuration du serveur NFS",
    service_type: "nfs_server",
    category: "file_sharing",
    description:
      "Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.",
    type: "template",
    script_path: "/scripts/nfs_server_setup.sh",
    template_content: `#!/bin/bash
# 🎯 Script de configuration du serveur NFS - nfs.camer.cm

echo "📦 Installation du serveur NFS..."
sudo apt update && sudo apt install -y nfs-kernel-server

echo "📁 Création du dossier partagé \${SHARE_DIR}..."
sudo mkdir -p \${SHARE_DIR}
sudo chown nobody:nogroup \${SHARE_DIR}
sudo chmod 777 \${SHARE_DIR}

echo "📝 Configuration du fichier /etc/exports..."
echo "\${SHARE_DIR} \${CLIENT_SUBNET}(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports

echo "🔄 Redémarrage du service NFS..."
sudo systemctl restart nfs-kernel-server

echo "🔍 Vérification de l’export actif..."
sudo exportfs -v

echo "✅ Serveur NFS configuré avec succès."
`,
    fields_schema: {
      fields: [
        { name: "SHARE_DIR", label: "Dossier partagé", type: "text", required: true, default: "/srv/nfs_share" },
        { name: "CLIENT_SUBNET", label: "Sous-réseau autorisé", type: "text", required: true, default: "192.168.24.0/24" },
      ],
    },
  },
  {
    id: 14,
    name: "Montage client NFS",
    service_type: "nfs_client",
    category: "file_sharing",
    description: "Monter un partage NFS distant sur un client.",
    type: "template",
    script_path: "/scripts/nfs_client_mount.sh",
    template_content: `#!/bin/bash
sudo apt update && sudo apt install -y nfs-common
sudo mkdir -p \${MOUNT_DIR}
echo "\${NFS_SERVER}:\${SHARE_DIR} \${MOUNT_DIR} nfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
echo "✅ Partage NFS monté sur \${MOUNT_DIR}"
`,
    fields_schema: {
      fields: [
        { name: "NFS_SERVER", label: "Adresse du serveur NFS", type: "text", required: true, default: "192.168.10.10" },
        { name: "SHARE_DIR", label: "Répertoire exporté", type: "text", required: true, default: "/srv/nfs_share" },
        { name: "MOUNT_DIR", label: "Point de montage local", type: "text", required: true, default: "/mnt/nfs_share" },
      ],
    },
  },
  // A couple of plain scripts for variety
  {
    id: 21,
    name: "Redémarrer Nginx",
    category: "ops",
    description: "Redémarre le service Nginx.",
    type: "script",
    template_content: `#!/bin/bash
sudo systemctl restart nginx && echo "Nginx redémarré"`,
  },
  {
    id: 22,
    name: "Vider cache APT",
    category: "ops",
    description: "Nettoie le cache APT pour libérer de l'espace.",
    type: "script",
    template_content: `#!/bin/bash
sudo apt clean && sudo apt autoremove -y && echo "Cache APT nettoyé"`,
  },
]

export function list() {
  return templates
}

export function find(id: number) {
  return templates.find((t) => t.id === id)
}

export function create(payload: Omit<Template, "id">): Template {
  const t: Template = { ...payload, id: nextId() }
  templates.push(t)
  return t
}

export function update(id: number, payload: Partial<Omit<Template, "id">>) {
  const idx = templates.findIndex((t) => t.id === id)
  if (idx === -1) return undefined
  templates[idx] = { ...templates[idx], ...payload, id }
  return templates[idx]
}

export function remove(id: number) {
  const idx = templates.findIndex((t) => t.id === id)
  if (idx === -1) return false
  templates.splice(idx, 1)
  return true
}

// Simple variable interpolation: replaces ${VAR} by provided or default values.
export function generateFromTemplate(template_id: number, config_data: Record<string, string | number> = {}) {
  const t = find(template_id)
  if (!t) return undefined

  const defaults: Record<string, string | number> = {}
  if (t.fields_schema?.fields?.length) {
    for (const f of t.fields_schema.fields) {
      if (typeof f.default !== "undefined") defaults[f.name] = f.default as any
    }
  }

  const vars = { ...defaults, ...config_data } as Record<string, string | number>
  let content = t.template_content

  for (const [k, v] of Object.entries(vars)) {
    const re = new RegExp(String.raw`\$\{${k}\}`, "g")
    content = content.replace(re, String(v))
  }

  return { script: content, template_id }
}
