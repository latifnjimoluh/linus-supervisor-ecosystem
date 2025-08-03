-- Seed or update permissions and ensure superadmin has all rights
-- Inserts missing permissions and updates descriptions for existing ones.

INSERT INTO permissions (name, description, status, created_at, updated_at)
VALUES
  ('auth.login', 'Se connecter à la plateforme', 'actif', NOW(), NOW()),
  ('auth.register', 'Créer un nouveau compte utilisateur', 'actif', NOW(), NOW()),
  ('auth.reset.history', 'Lister les utilisateurs ayant réinitialisé leur mot de passe', 'actif', NOW(), NOW()),
  ('auth.reset.password', 'Réinitialiser le mot de passe', 'actif', NOW(), NOW()),
  ('auth.reset.request', 'Faire une demande de réinitialisation de mot de passe', 'actif', NOW(), NOW()),
  ('configTemplate.create', 'Créer un template de configuration système', 'actif', NOW(), NOW()),
  ('configTemplate.list', 'Lister les templates de configuration système', 'actif', NOW(), NOW()),
  ('configTemplate.update', 'Mettre à jour un template de configuration système', 'actif', NOW(), NOW()),
  ('configTemplate.delete', 'Supprimer un template de configuration système', 'actif', NOW(), NOW()),
  ('convert.history.view', 'Voir l\u2019historique des conversions en template', 'actif', NOW(), NOW()),
  ('initScript.generate', 'Générer un script d\u2019initialisation', 'actif', NOW(), NOW()),
  ('initScript.list', 'Lister les scripts d\u2019initialisation', 'actif', NOW(), NOW()),
  ('initScript.update', 'Mettre à jour un script d\u2019initialisation', 'actif', NOW(), NOW()),
  ('initScript.delete', 'Supprimer un script d\u2019initialisation', 'actif', NOW(), NOW()),
  ('monitoringScript.generate', 'Générer un script de supervision', 'actif', NOW(), NOW()),
  ('monitoringScript.list', 'Lister les scripts de supervision', 'actif', NOW(), NOW()),
  ('monitoringScript.update', 'Mettre à jour un script de supervision', 'actif', NOW(), NOW()),
  ('monitoringScript.delete', 'Supprimer un script de supervision', 'actif', NOW(), NOW()),
  ('monitoringService.generate', 'Générer un script de monitoring pour un service', 'actif', NOW(), NOW()),
  ('monitoringService.list', 'Lister les scripts de monitoring de services', 'actif', NOW(), NOW()),
  ('monitoringService.update', 'Mettre à jour un script de monitoring de service', 'actif', NOW(), NOW()),
  ('monitoringService.delete', 'Supprimer un script de monitoring de service', 'actif', NOW(), NOW()),
  ('roles.create', 'Créer un rôle utilisateur', 'actif', NOW(), NOW()),
  ('roles.delete', 'Supprimer un rôle utilisateur', 'actif', NOW(), NOW()),
  ('roles.read', 'Afficher les rôles disponibles', 'actif', NOW(), NOW()),
  ('roles.update', 'Modifier un rôle utilisateur', 'actif', NOW(), NOW()),
  ('serviceConfig.configure', 'Configurer automatiquement un service avec un template', 'actif', NOW(), NOW()),
  ('serviceConfig.read', 'Consulter les configurations de service', 'actif', NOW(), NOW()),
  ('serviceConfig.update', 'Mettre à jour une configuration de service', 'actif', NOW(), NOW()),
  ('serviceConfig.delete', 'Supprimer une configuration de service', 'actif', NOW(), NOW()),
  ('supervision.fetch', 'Envoyer les données de supervision système', 'actif', NOW(), NOW()),
  ('supervision.save', 'Sauvegarder la supervision de statut', 'actif', NOW(), NOW()),
  ('template.convert', 'Convertir une VM en template réutilisable', 'actif', NOW(), NOW()),
  ('template.create', 'Créer un template de configuration standardisé', 'actif', NOW(), NOW()),
  ('template.delete', 'Supprimer un template de configuration', 'actif', NOW(), NOW()),
  ('template.update', 'Modifier un template de configuration', 'actif', NOW(), NOW()),
  ('template.view', 'Consulter les templates de configuration existants', 'actif', NOW(), NOW()),
  ('userLogs.view', 'Voir l\u2019historique d\u2019un utilisateur', 'actif', NOW(), NOW()),
  ('userSettings.create', 'Créer ses propres paramètres utilisateur', 'actif', NOW(), NOW()),
  ('userSettings.read', 'Lire ses propres paramètres utilisateur', 'actif', NOW(), NOW()),
  ('userSettings.update', 'Modifier ses propres paramètres utilisateur', 'actif', NOW(), NOW()),
  ('userSettings.list', 'Lister les paramètres utilisateurs', 'actif', NOW(), NOW()),
  ('users.create', 'Créer un utilisateur', 'actif', NOW(), NOW()),
  ('users.delete', 'Supprimer ou désactiver un utilisateur', 'actif', NOW(), NOW()),
  ('users.read', 'Consulter la liste des utilisateurs', 'actif', NOW(), NOW()),
  ('users.update', 'Modifier un utilisateur', 'actif', NOW(), NOW()),
  ('vm.delete', 'Supprimer une machine virtuelle existante', 'actif', NOW(), NOW()),
  ('vm.deploy', 'Déployer une nouvelle machine virtuelle', 'actif', NOW(), NOW()),
  ('vm.list', 'Lister les machines virtuelles', 'actif', NOW(), NOW()),
  ('vm.start', 'Démarrer une machine virtuelle arrêtée', 'actif', NOW(), NOW()),
  ('vm.status', 'Vérifier l\u2019état d\u2019une machine virtuelle', 'actif', NOW(), NOW()),
  ('vm.stop', 'Arrêter une machine virtuelle', 'actif', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET
  description = EXCLUDED.description,
  status = EXCLUDED.status,
  updated_at = NOW();

-- Ensure the superadmin role (ID 1) has all permissions
INSERT INTO role_permissions (role_id, permission_id, created_at, updated_at)
SELECT 1, p.id, NOW(), NOW()
FROM permissions p
WHERE p.name IN (
  'auth.login','auth.register','auth.reset.history','auth.reset.password','auth.reset.request',
  'configTemplate.create','configTemplate.list','configTemplate.update','configTemplate.delete',
  'convert.history.view','initScript.generate','initScript.list','initScript.update','initScript.delete',
  'monitoringScript.generate','monitoringScript.list','monitoringScript.update','monitoringScript.delete',
  'monitoringService.generate','monitoringService.list','monitoringService.update','monitoringService.delete',
  'roles.create','roles.delete','roles.read','roles.update',
  'serviceConfig.configure','serviceConfig.read','serviceConfig.update','serviceConfig.delete',
  'supervision.fetch','supervision.save','template.convert','template.create','template.delete',
  'template.update','template.view','userLogs.view','userSettings.create','userSettings.read',
  'userSettings.update','userSettings.list','users.create','users.delete','users.read','users.update',
  'vm.delete','vm.deploy','vm.list','vm.start','vm.status','vm.stop'
)
ON CONFLICT (role_id, permission_id) DO NOTHING;
