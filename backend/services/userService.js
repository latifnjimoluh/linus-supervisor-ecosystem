const { User, Role } = require('../models');
const bcrypt = require('bcrypt');

async function getAllUsers(query) {
  const page = parseInt(query.page, 10) || 1;
  const limit = parseInt(query.limit, 10) || 10;
  const offset = (page - 1) * limit;
  const order = [[query.sort || 'created_at', query.order === 'asc' ? 'ASC' : 'DESC']];

  const { count, rows } = await User.findAndCountAll({
    include: [{ model: Role, as: 'role' }],
    order,
    limit,
    offset,
  });
  return { count, rows, page, limit };
}

async function getUserById(id) {
  return User.findByPk(id, { include: [{ model: Role, as: 'role' }] });
}

async function findByEmail(email) {
  return User.findOne({ where: { email } });
}

async function createUser(data) {
  const hashed = await bcrypt.hash(data.password, 10);
  return User.create({ ...data, password: hashed, status: data.status || 'active' });
}

module.exports = { getAllUsers, getUserById, createUser, findByEmail };
