# Prompt for Codex: Frontend for Linusupervisor

Tu es un assistant de développement. Génère une application front-end **React** qui consomme toutes les routes du backend Node/Express disponible à `http://localhost:3000`. Les collections Postman `postman_collection.json` et `postman_ai_routes.json` fournissent les exemples de requêtes et réponses.

## Stack recommandée
- React avec React Router
- Axios pour les appels HTTP (token JWT stocké dans `localStorage`)
- TailwindCSS pour le style (optionnel)

## Interfaces et API à implémenter

### 1. Liste des templates
- **GET `/templates`**
- Affiche la liste paginée des templates.
- **Réponse**
```json
{
  "data": [{ "id": 1, "name": "nginx_web", "script_path": "/scripts/..." }],
  "pagination": { "total": 1, "page": 1, "pages": 1, "limit": 10 }
}
```
- Chaque élément affiche le script et un bouton **Expliquer**.
- **POST `/templates/explain`**
```json
Request: { "script": "#!/bin/bash\necho hello" }
Response: { "explanation": "Imprime hello." }
```

### 2. Détail, création et édition de template
- **GET `/templates/:id`**
- **POST `/templates`** pour créer
- **PUT `/templates/:id`** pour modifier
```json
Request: {
  "name": "web_server",
  "service_type": "nginx",
  "category": "web",
  "description": "Installe nginx",
  "template_content": "#!/bin/bash\napt install nginx -y",
  "fields_schema": { "fields": [{ "name": "PORT", "type": "number", "required": true }] }
}
Response: { "id": 1, "name": "web_server", ... }
```
- Bouton **Analyser**
- **POST `/templates/analyze`**
```json
Request: { "script": "#!/bin/bash\napt update" }
Response: { "analysis": "Explique le script et propose des améliorations." }
```

### 3. Remplissage des variables
- Lors du remplissage d'un template, bouton **Expliquer les variables**.
- **POST `/templates/variables/explain`**
```json
Request: { "template": "#!/bin/bash\nexport PORT={{PORT}}" }
Response: { "explanation": "PORT: port d'écoute du service." }
```

### 4. Journal de déploiement
- Interface affichant les logs après exécution.
- Bouton **Résumer les logs**
- **POST `/templates/logs/summarize`**
```json
Request: { "logs": "ligne1\nligne2" }
Response: { "summary": "Démarre nginx et ouvre le port 80." }
```

### 5. Bundles intelligents
- Interface où l'utilisateur décrit ses besoins.
- **POST `/templates/bundle`**
```json
Request: { "needs": "Hébergement web" }
Response: { "suggestion": "Stack Web : Nginx + PHP + MariaDB" }
```

### 6. Simulation d'exécution de script
- Bouton **Simuler** sur une page de script.
- **POST `/templates/simulate`**
```json
Request: { "script": "#!/bin/bash\nsystemctl restart nginx" }
Response: { "simulation": "Redémarrera nginx sans reboot système." }
```

### 7. Génération de script
- **POST `/templates/generate`**
```json
Request: { "template_id": 1, "config_data": { "PORT": 8080 } }
Response: { "script_path": "/scripts/generated/web/web_server_script001.sh", ... }
```

### 8. Suppression de template
- **DELETE `/templates/:id`**
- **Réponse**
```json
{ "message": "Template désactivé" }
```

## Exigences générales
- Inclure l'en-tête `Authorization: Bearer <token>` dans chaque requête.
- Gérer les états de chargement et les erreurs.
- Structurer le projet en composants réutilisables.
- Fournir un fichier README expliquant le démarrage du front-end et la configuration des variables d'environnement.

Génère tout le code nécessaire : composants React, services Axios, routing, gestion d'état et exemples de styles.
