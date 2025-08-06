const { GoogleGenerativeAI } = require('@google/generative-ai');

const apiKey = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(apiKey);
const model = genAI.getGenerativeModel({ model: 'gemini-2.5-pro' });

async function callGemini(prompt) {
  const result = await model.generateContent(prompt);
  const response = await result.response;
  return response.text();
}

async function explainScript(scriptCode) {
  const prompt = `
Voici un script système ou DevOps à déployer :

\`\`\`bash
${scriptCode}
\`\`\`

1. Explique brièvement ce que fait ce script.
2. Donne des conseils ou alternatives après le déploiement.
`;
  return callGemini(prompt);
}

async function analyzeAndImproveScript(scriptCode) {
  const prompt = `
Voici un script de template :

\`\`\`bash
${scriptCode}
\`\`\`

1. Analyse ce script et indique les améliorations possibles.
2. Propose des alternatives ou pratiques modernes.
3. Fournis une version optimisée du script.
`;
  return callGemini(prompt);
}

async function explainTemplateVariables(templateCode) {
  const prompt = `
Voici un template avec des variables :

\`\`\`bash
${templateCode}
\`\`\`

Explique de façon concise quelles variables doivent être renseignées et à quoi elles servent.
`;
  return callGemini(prompt);
}

async function summarizeDeploymentLogs(logs) {
  const prompt = `
Voici des logs de déploiement :

\`\`\`
${logs}
\`\`\`

Résume en quelques lignes ce que ces logs montrent.
`;
  return callGemini(prompt);
}

async function suggestSmartBundle(needs) {
  const prompt = `
L'utilisateur a les besoins suivants : ${needs}

Propose un ou plusieurs packs d'installation adaptés. Choisis parmi :
- Stack Web : Nginx + PHP + MariaDB
- Stack Monitoring : Netdata + Prometheus + AlertManager
- Stack DevSecOps : Git + Jenkins + SonarQube + UFW + Fail2Ban

Explique brièvement pourquoi tu proposes chaque stack.
`;
  return callGemini(prompt);
}

async function simulateScriptExecution(scriptCode) {
  const prompt = `
Voici un script :

\`\`\`bash
${scriptCode}
\`\`\`

Décris ce qui se passera lors de son exécution :
- Quelles ressources seront créées ou modifiées ?
- Quels services seront redémarrés ?
- Un redémarrage du système est-il nécessaire ?
`;
  return callGemini(prompt);
}

module.exports = {
  explainScript,
  analyzeAndImproveScript,
  explainTemplateVariables,
  summarizeDeploymentLogs,
  suggestSmartBundle,
  simulateScriptExecution,
};

