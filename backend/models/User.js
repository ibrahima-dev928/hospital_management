// backend/models/User.js
const db = require('./db');
const bcrypt = require('bcryptjs');

class User {
  static async findById(id) {
    const [rows] = await db.query('SELECT id, username, email, role, nom, prenom FROM users WHERE id = ?', [id]);
    return rows[0];
  }

  static async findByUsername(username) {
    const [rows] = await db.query('SELECT * FROM users WHERE username = ?', [username]);
    return rows[0];
  }

  static async create(data) {
    const { username, password, email, role, nom, prenom } = data;
    const hashed = await bcrypt.hash(password, 10);
    const [res] = await db.query(
      'INSERT INTO users (username, password, email, role, nom, prenom) VALUES (?, ?, ?, ?, ?, ?)',
      [username, hashed, email, role || 'patient', nom, prenom]
    );
    return res.insertId;
  }

  static async verifyPassword(plain, hashed) {
    return bcrypt.compare(plain, hashed);
  }

  static async update(id, data) {
    const { email, role, nom, prenom } = data;
    await db.query('UPDATE users SET email=?, role=?, nom=?, prenom=? WHERE id=?', [email, role, nom, prenom, id]);
  }

  static async delete(id) {
    await db.query('DELETE FROM users WHERE id = ?', [id]);
  }

  static async findAll() {
    const [rows] = await db.query('SELECT id, username, email, role, nom, prenom FROM users');
    return rows;
  }

  // Récupérer tous les médecins (rôle 'medecin')
  static async findAllMedecins() {
    const [rows] = await db.query('SELECT id, username, email, nom, prenom FROM users WHERE role = "medecin"');
    return rows;
  }

  // Récupérer tous les patients (rôle 'patient')
  static async findAllPatients() {
    const [rows] = await db.query('SELECT id, username, email, nom, prenom FROM users WHERE role = "patient"');
    return rows;
  }

  static async update(id, data) {
    const { email, role, nom, prenom } = data;
    await db.query('UPDATE users SET email=?, role=?, nom=?, prenom=? WHERE id=?', [email, role, nom, prenom, id]);
  }
  static async delete(id) {
    await db.query('DELETE FROM users WHERE id = ?', [id]);
  }
}

module.exports = User;