"use client"

import * as React from "react"
import { Search, Plus, Code, Sparkles, Filter, Copy, Check, Edit } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs"
import Link from "next/link"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"

interface ScriptTemplate {
  id: number;
  name: string;
  description: string;
  category: 'init' | 'monitoring' | 'service' | 'security' | 'web' | 'file_sharing'; // Added file_sharing
  service_type: string;
  type: 'script' | 'template';
  template_content: string;
  script_path: string;
  fields_schema?: {
    fields: Array<{
      name: string;
      label: string;
      type: 'text' | 'number' | 'password';
      required: boolean;
      default?: string | number;
    }>;
  };
}

const mockTemplates: ScriptTemplate[] = [
  { 
    id: 1, 
    name: 'Installation Nginx', 
    description: 'Installe et configure un serveur web Nginx.', 
    category: 'web', 
    service_type: 'web_server',
    type: 'script', 
    template_content: 'apt update && apt install -y nginx',
    script_path: '/scripts/install_nginx.sh',
  },
  { 
    id: 2, 
    name: 'Setup Monitoring Agent', 
    description: 'Déploie l\'agent de supervision pour la collecte de métriques.', 
    category: 'monitoring', 
    service_type: 'monitoring_agent',
    type: 'script', 
    template_content: 'curl -sSL https://my-agent.com/install.sh | bash',
    script_path: '/scripts/install_monitor_agent.sh',
  },
  { 
    id: 3, 
    name: 'Template Base de Données PostgreSQL', 
    description: 'Configure une base de données PostgreSQL avec un utilisateur dédié.', 
    category: 'service', 
    service_type: 'database_postgresql',
    type: 'template', 
    template_content: 'CREATE USER ${DB_USER} WITH PASSWORD \'${DB_PASS}\';', 
    script_path: '/scripts/setup_postgresql.sh',
    fields_schema: { 
      fields: [
        { name: 'DB_USER', label: 'Utilisateur DB', type: 'text', required: true }, 
        { name: 'DB_PASS', label: 'Mot de passe', type: 'password', required: true }
      ] 
    }
  },
  { 
    id: 4, 
    name: 'Configuration Firewall UFW', 
    description: 'Met en place des règles de pare-feu basiques.', 
    category: 'security', 
    service_type: 'security_firewall',
    type: 'script', 
    template_content: 'ufw allow ssh\nufw allow http\nufw allow https\nufw enable',
    script_path: '/scripts/configure_ufw.sh',
  },
  {
    id: 14,
    name: "Activation des cronjobs de supervision",
    service_type: "monitoring_cron",
    category: "monitoring",
    description: "Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.",
    type: "template",
    template_content: `#!/bin/bash

# 📍 Ce script centralise l’installation des cronjobs de monitoring

# 🔐 Vérifie que les scripts à exécuter existent
STATUS_SCRIPT="\${STATUS_SCRIPT}"
SERVICES_SCRIPT="\${SERVICES_SCRIPT}"

# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà
if [ -f "$STATUS_SCRIPT" ]; then
  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/\${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour status.sh"
else
  echo "❌ Script $STATUS_SCRIPT introuvable"
fi

if [ -f "$SERVICES_SCRIPT" ]; then
  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/\${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour services_status.sh"
else
  echo "❌ Script $SERVICES_SCRIPT introuvable"
fi`,
    script_path: "/scripts/register_cronjobs.sh",
    fields_schema: {
      fields: [
        {
          name: "STATUS_SCRIPT",
          label: "Chemin script status",
          type: "text",
          required: true,
          default: "/opt/monitoring/status.sh"
        },
        {
          name: "SERVICES_SCRIPT",
          label: "Chemin script services",
          type: "text",
          required: true,
          default: "/opt/monitoring/services_status.sh"
        },
        {
          name: "STATUS_CRON_INTERVAL",
          label: "Fréquence status (min)",
          type: "number",
          required: true,
          default: 5
        },
        {
          name: "SERVICES_CRON_INTERVAL",
          label: "Fréquence services (min)",
          type: "number",
          required: true,
          default: 5
        }
      ]
    }
  },
  {
    id: 13,
    name: "Configuration du serveur NFS",
    service_type: "nfs_server",
    category: "file_sharing",
    description: "Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.",
    type: "template",
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

echo "✅ Serveur NFS configuré avec succès."`,
    script_path: "/scripts/nfs_server_setup.sh",
    fields_schema: {
      fields: [
        {
          name: "SHARE_DIR",
          label: "Dossier partagé",
          type: "text",
          required: true,
          default: "/srv/nfs_share"
        },
        {
          name: "CLIENT_SUBNET",
          label: "Sous-réseau autorisé",
          type: "text",
          required: true,
          default: "192.168.24.0/24"
        }
      ]
    }
  }
];

export default function TemplatesPage() {
  const [searchTerm, setSearchTerm] = React.useState("");
  const [selectedTemplate, setSelectedTemplate] = React.useState<ScriptTemplate | null>(null);
  const [copied, setCopied] = React.useState(false);
  const { toast } = useToast();

  const filteredTemplates = mockTemplates.filter(t =>
    t.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    t.description.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const filteredScripts = filteredTemplates.filter(t => t.type === 'script');
  const filteredTemplateList = filteredTemplates.filter(t => t.type === 'template');

  const copyContent = (content: string) => {
    navigator.clipboard.writeText(content);
    setCopied(true);
    toast({ title: "Copié !", description: "Le contenu du script a été copié.", variant: "success" });
    setTimeout(() => setCopied(false), 2000);
  };

  const renderGrid = (items: ScriptTemplate[]) => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <AnimatePresence>
        {items.map((template) => (
          <motion.div
            key={template.id}
            layout
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.9 }}
          >
            <Card className="h-full flex flex-col hover:shadow-lg transition-shadow rounded-2xl">
              <CardHeader>
                <CardTitle className="text-lg">{template.name}</CardTitle>
                <div className="flex gap-2 pt-2">
                  <Badge variant="secondary">{template.category}</Badge>
                  <Badge variant={template.type === 'template' ? 'default' : 'outline'}>
                    {template.type === 'template' ? 'Paramétrable' : 'Script simple'}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent className="flex-1">
                <p className="text-sm text-muted-foreground">{template.description}</p>
              </CardContent>
              <div className="p-4 border-t flex flex-wrap gap-2">
                <Dialog>
                  <DialogTrigger asChild>
                    <Button variant="secondary" size="sm" onClick={() => setSelectedTemplate(template)}>
                      <Code className="mr-2 h-4 w-4" /> Voir le code
                    </Button>
                  </DialogTrigger>
                  {selectedTemplate && (
                    <DialogContent className="max-w-3xl">
                      <DialogHeader>
                        <DialogTitle>{selectedTemplate.name}</DialogTitle>
                      </DialogHeader>
                      <div className="relative bg-muted rounded-lg p-4 mt-4">
                        <Button size="sm" variant="ghost" className="absolute top-2 right-2 h-7 w-7 p-0" onClick={() => copyContent(selectedTemplate.template_content)}>
                          {copied ? <Check className="h-4 w-4 text-green-500" /> : <Copy className="h-4 w-4" />}
                        </Button>
                        <pre className="text-sm whitespace-pre-wrap overflow-auto max-h-[60vh]">
                          <code className="font-mono">{selectedTemplate.template_content}</code>
                        </pre>
                      </div>
                      {selectedTemplate.fields_schema && (
                        <div className="mt-4">
                          <h3 className="font-semibold mb-2">Champs de configuration:</h3>
                          <ul className="list-disc pl-5 text-sm text-muted-foreground">
                            {selectedTemplate.fields_schema.fields.map((field, index) => (
                              <li key={index}>
                                <strong>{field.label}</strong> ({field.name}): {field.type} {field.required ? '(Requis)' : '(Optionnel)'} {field.default !== undefined && `(Défaut: ${field.default})`}
                              </li>
                            ))}
                          </ul>
                        </div>
                      )}
                    </DialogContent>
                  )}
                </Dialog>
                <Button asChild variant="outline" size="sm">
                  <Link href={`/editor?id=${template.id}`}>
                    <Edit className="mr-2 h-4 w-4" /> Éditer
                  </Link>
                </Button>
                <Button variant="outline" size="sm">
                  <Sparkles className="mr-2 h-4 w-4" /> Analyser (IA)
                </Button>
              </div>
            </Card>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );

  const renderSection = (items: ScriptTemplate[]) => (
    <Card>
      <CardHeader>
        <div className="flex flex-col md:flex-row gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Rechercher un script..."
              className="pl-10"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <Button variant="outline">
            <Filter className="mr-2 h-4 w-4" /> Filtrer par catégorie
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        {renderGrid(items)}
        {items.length === 0 && (
          <div className="text-center py-12 text-muted-foreground">
            <p>Aucun script ou template ne correspond à votre recherche.</p>
          </div>
        )}
      </CardContent>
    </Card>
  );

  return (
    <div className="space-y-6">
      <header className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-3xl md:text-4xl font-bold tracking-tight">Scripts & Templates</h1>
          <p className="text-muted-foreground mt-2">
            Parcourez, analysez et utilisez des scripts pour automatiser vos déploiements.
          </p>
        </div>
        <Button className="w-full md:w-auto">
          <Plus className="mr-2 h-4 w-4" /> Créer un nouveau template
        </Button>
      </header>

      <Tabs defaultValue="scripts" className="space-y-6">
        <TabsList className="w-full md:w-auto">
          <TabsTrigger value="scripts">Scripts</TabsTrigger>
          <TabsTrigger value="templates">Templates</TabsTrigger>
        </TabsList>
        <TabsContent value="scripts">
          {renderSection(filteredScripts)}
        </TabsContent>
        <TabsContent value="templates">
          {renderSection(filteredTemplateList)}
        </TabsContent>
      </Tabs>
    </div>
  );
}
