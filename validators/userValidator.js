const allowedStatuses = ['actif', 'inactif', 'blocked'];

function validateCreate(data) {
  const required = ['first_name', 'last_name', 'email', 'password', 'role_id'];
  const missing = required.filter((f) => !data[f]);
  if (missing.length) {
    return { error: `Champs requis manquants: ${missing.join(', ')}` };
  }
  if (data.status && !allowedStatuses.includes(data.status)) {
    return { error: `Statut invalide. Valeurs autorisées: ${allowedStatuses.join(', ')}` };
  }
  return { value: data };
}

function validateUpdate(data) {
  if (!Object.keys(data).length) {
    return { error: 'Aucune donnée fournie' };
  }
  if (data.status && !allowedStatuses.includes(data.status)) {
    return { error: `Statut invalide. Valeurs autorisées: ${allowedStatuses.join(', ')}` };
  }
  return { value: data };
}

module.exports = { validateCreate, validateUpdate };
