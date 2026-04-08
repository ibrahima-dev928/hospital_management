const db = require('./db');

class Medecin {
  static async findAll() {
    const [rows] = await db.query('SELECT * FROM medecins ORDER BY id');
    return rows;
  }

  static async findById(id) {
    const [rows] = await db.query('SELECT * FROM medecins WHERE id = ?', [id]);
    return rows[0];
  }

  static async create(data) {
    const {
      nom, prenom, specialite, telephone, email, disponibilite, photo, user_id,
      diplomes, annees_experience, numero_ordre, cabinet_adresse, cabinet_telephone
    } = data;
    const [res] = await db.query(
      `INSERT INTO medecins 
        (nom, prenom, specialite, telephone, email, disponibilite, photo, user_id,
         diplomes, annees_experience, numero_ordre, cabinet_adresse, cabinet_telephone)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [nom, prenom, specialite, telephone, email, disponibilite, photo, user_id,
        diplomes, annees_experience, numero_ordre, cabinet_adresse, cabinet_telephone]
    );
    return res.insertId;
  }

  static async update(id, data) {
    const {
      nom, prenom, specialite, telephone, email, disponibilite, photo,
      diplomes, annees_experience, numero_ordre, cabinet_adresse, cabinet_telephone
    } = data;
    const [res] = await db.query(
      `UPDATE medecins SET 
            nom=?, prenom=?, specialite=?, telephone=?, email=?, disponibilite=?, photo=?,
            diplomes=?, annees_experience=?, numero_ordre=?, cabinet_adresse=?, cabinet_telephone=?
         WHERE id=?`,
      [nom, prenom, specialite, telephone, email, disponibilite, photo,
        diplomes, annees_experience, numero_ordre, cabinet_adresse, cabinet_telephone, id]
    );
    return res.affectedRows;
  }

  static async delete(id) {
    const [res] = await db.query('DELETE FROM medecins WHERE id = ?', [id]);
    return res.affectedRows;
  }

  static async search(term) {
    const like = `%${term}%`;
    const [rows] = await db.query(
      `SELECT * FROM medecins WHERE nom LIKE ? OR prenom LIKE ? OR specialite LIKE ? OR telephone LIKE ?`,
      [like, like, like, like]
    );
    return rows;
  }

  static async updatePhoto(id, photoPath) {
    const [res] = await db.query('UPDATE medecins SET photo = ? WHERE id = ?', [photoPath, id]);
    return res.affectedRows;
  }

  static async findByUserId(userId) {
    const [rows] = await db.query('SELECT * FROM medecins WHERE user_id = ?', [userId]);
    return rows[0];
  }
}

module.exports = Medecin;