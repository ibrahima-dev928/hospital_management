const db = require('./db');

class Prescription {
  static async create(data) {
    const { dossier_id, medicament, posologie, duree, instructions } = data;
    const [res] = await db.query(
      'INSERT INTO prescriptions (dossier_id, medicament, posologie, duree, instructions) VALUES (?, ?, ?, ?, ?)',
      [dossier_id, medicament, posologie, duree, instructions]
    );
    return res.insertId;
  }

  static async findByDossier(dossierId) {
    const [rows] = await db.query('SELECT * FROM prescriptions WHERE dossier_id = ? ORDER BY created_at DESC', [dossierId]);
    return rows;
  }

  static async update(id, data) {
    const { medicament, posologie, duree, instructions } = data;
    const [res] = await db.query(
      'UPDATE prescriptions SET medicament = ?, posologie = ?, duree = ?, instructions = ? WHERE id = ?',
      [medicament, posologie, duree, instructions, id]
    );
    return res.affectedRows;
  }

  static async delete(id) {
    const [res] = await db.query('DELETE FROM prescriptions WHERE id = ?', [id]);
    return res.affectedRows;
  }
}

module.exports = Prescription;