const db = require('./db');

class Batiment {
  static async findAll() {
    const [rows] = await db.query('SELECT * FROM batiments WHERE actif = 1 ORDER BY nom');
    return rows;
  }
  static async findById(id) {
    const [rows] = await db.query('SELECT * FROM batiments WHERE id = ?', [id]);
    return rows[0];
  }
  static async create(nom, description) {
    const [res] = await db.query('INSERT INTO batiments (nom, description) VALUES (?, ?)', [nom, description]);
    return res.insertId;
  }
  static async update(id, nom, description, actif) {
    await db.query('UPDATE batiments SET nom=?, description=?, actif=? WHERE id=?', [nom, description, actif, id]);
  }
  static async delete(id) {
    await db.query('DELETE FROM batiments WHERE id = ?', [id]);
  }
}
module.exports = Batiment;