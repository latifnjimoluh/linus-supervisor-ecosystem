function validateCreate(data) {
  const required = ['first_name', 'last_name', 'email', 'password', 'role_id'];
  const missing = required.filter((f) => !data[f]);
  if (missing.length) {
    return { error: `Champs requis manquants: ${missing.join(', ')}` };
  }
  return { value: data };
}

function validateUpdate(data) {
  if (!Object.keys(data).length) {
    return { error: 'Aucune donnée fournie' };
  }
  return { value: data };
}

module.exports = { validateCreate, validateUpdate };
