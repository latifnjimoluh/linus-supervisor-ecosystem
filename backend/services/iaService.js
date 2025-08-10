let GoogleGenerativeAI;
try {
  ({ GoogleGenerativeAI } = require('@google/generative-ai'));
} catch (err) {
  GoogleGenerativeAI = null;
}
const crypto = require('crypto');
const { AiCache } = require('../models');

const apiKey = process.env.GEMINI_API_KEY;
const genAI = GoogleGenerativeAI ? new GoogleGenerativeAI(apiKey) : null;
const model = genAI ? genAI.getGenerativeModel({ model: 'gemini-2.5-pro' }) : null;

async function callGemini(prompt) {
  if (!model) {
    throw new Error('Google Generative AI SDK not configured');
  }
  const result = await model.generateContent(prompt);
  const response = await result.response;
  return response.text();
}

async function cachedResponse(type, input, buildPrompt, ref = {}) {
  const hash = crypto.createHash('sha256').update(`${type}:${input}`).digest('hex');
  const cached = await AiCache.findOne({ where: { hash } });
  if (cached) return cached.response_text;
  const prompt = buildPrompt(input);
  const response = await callGemini(prompt);
  await AiCache.create({
    type,
    hash,
    input_text: input,
    response_text: response,
    entity_type: ref.entityType,
    entity_id: ref.entityId,
  });
  return response;
}

async function explainScript(scriptCode, ref) {
  return cachedResponse(
    'explain_script',
    scriptCode,
    (script) => `
Voici un script système ou DevOps à déployer :

\`\`\`bash
${script}
\`\`\`

1. Explique brièvement ce que fait ce script.
2. Donne des conseils ou alternatives après le déploiement.
`,
    ref,
  );
}

async function analyzeAndImproveScript(scriptCode, ref) {
  return cachedResponse(
    'analyze_script',
    scriptCode,
    (script) => `
Voici un script de template :

\`\`\`bash
${script}
\`\`\`

1. Analyse ce script et indique les améliorations possibles.
2. Propose des alternatives ou pratiques modernes.
3. Fournis une version optimisée du script.
`,
    ref,
  );
}

async function explainTemplateVariables(templateCode, ref) {
  return cachedResponse(
    'explain_variables',
    templateCode,
    (template) => `
Voici un template avec des variables :

\`\`\`bash
${template}
\`\`\`

Explique de façon concise quelles variables doivent être renseignées et à quoi elles servent.
`,
    ref,
  );
}

async function summarizeDeploymentLogs(logs, ref) {
  return cachedResponse(
    'summarize_logs',
    logs,
    (content) => `
Voici des logs de déploiement :

\`\`\`
${content}
\`\`\`

Résume en quelques lignes ce que ces logs montrent.
`,
    ref,
  );
}

async function suggestSmartBundle(needs, ref) {
  return cachedResponse(
    'suggest_bundle',
    needs,
    (need) => `
L'utilisateur a les besoins suivants : ${need}

Propose un ou plusieurs packs d'installation adaptés. Choisis parmi :
- Stack Web : Nginx + PHP + MariaDB
- Stack Monitoring : Netdata + Prometheus + AlertManager
- Stack DevSecOps : Git + Jenkins + SonarQube + UFW + Fail2Ban

Explique brièvement pourquoi tu proposes chaque stack.
`,
    ref,
  );
}

async function simulateScriptExecution(scriptCode, ref) {
  return cachedResponse(
    'simulate_execution',
    scriptCode,
    (script) => `
Voici un script :

\`\`\`bash
${script}
\`\`\`

Décris ce qui se passera lors de son exécution :
- Quelles ressources seront créées ou modifiées ?
- Quels services seront redémarrés ?
- Un redémarrage du système est-il nécessaire ?
`,
    ref,
  );
}

async function generateScript(name, variables) {
  return { script: `# Script ${name}`, variables };
}

module.exports = {
  explainScript,
  analyzeAndImproveScript,
  explainTemplateVariables,
  summarizeDeploymentLogs,
  suggestSmartBundle,
  simulateScriptExecution,
  generateScript,
};