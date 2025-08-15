const faq = [
  {
    pattern: /vm|machine/i,
    reply: "Pour gérer vos machines virtuelles, utilisez la section VMs de Linusupervisor."
  },
  {
    pattern: /mot de passe|password|reset/i,
    reply: "Pour réinitialiser votre mot de passe, utilisez le lien 'Mot de passe oublié' sur la page de connexion."
  },
  {
    pattern: /monitoring|logs?/i,
    reply: "Le monitoring collecte les événements système importants. Consultez l'onglet Monitoring pour plus de détails."
  }
];

function generateReply(message) {
  const lower = message.toLowerCase();
  for (const entry of faq) {
    if (entry.pattern.test(lower)) {
      return entry.reply;
    }
  }
  return "Je suis l'assistant Linusupervisor. Je peux répondre aux questions concernant la plateforme.";
}

const chat = async (req, res) => {
  const { message } = req.body || {};
  const userMessage = typeof message === 'string' ? message.trim() : '';
  const reply = userMessage
    ? generateReply(userMessage)
    : "Bonjour, je suis l'assistant Linusupervisor. Posez votre question.";
  res.json({ reply });
};

module.exports = { chat };
