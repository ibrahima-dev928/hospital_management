const db = require('./db');

class Patient {
  static async findAll() {
    const [rows] = await db.query('SELECT * FROM patients ORDER BY id');
    return rows;
  }
  static async findById(id) {
    const [rows] = await db.query('SELECT * FROM patients WHERE id = ?', [id]);
    return rows[0];
  }
  static async create(data) {
    const {
      nom, prenom, date_naissance, genre, telephone, email, adresse, photo, user_id,
      groupe_sanguin, allergies, antecedents, traitements_en_cours, medecin_traitant_id,
      profession, situation_familiale, numero_securite_sociale
    } = data;
    const [res] = await db.query(
      `INSERT INTO patients 
        (nom, prenom, date_naissance, genre, telephone, email, adresse, photo, user_id,
         groupe_sanguin, allergies, antecedents, traitements_en_cours, medecin_traitant_id,
         profession, situation_familiale, numero_securite_sociale)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [nom, prenom, date_naissance, genre, telephone, email, adresse, photo, user_id,
        groupe_sanguin, allergies, antecedents, traitements_en_cours, medecin_traitant_id,
        profession, situation_familiale, numero_securite_sociale]
    );
    return res.insertId;
  }

  static async update(id, data) {
    const {
      nom, prenom, date_naissance, genre, telephone, email, adresse, photo,
      groupe_sanguin, allergies, antecedents, traitements_en_cours, medecin_traitant_id,
      profession, situation_familiale, numero_securite_sociale
    } = data;
    const [res] = await db.query(
      `UPDATE patients SET 
            nom=?, prenom=?, date_naissance=?, genre=?, telephone=?, email=?, adresse=?, photo=?,
            groupe_sanguin=?, allergies=?, antecedents=?, traitements_en_cours=?, medecin_traitant_id=?,
            profession=?, situation_familiale=?, numero_securite_sociale=?
         WHERE id=?`,
      [nom, prenom, date_naissance, genre, telephone, email, adresse, photo,
        groupe_sanguin, allergies, antecedents, traitements_en_cours, medecin_traitant_id,
        profession, situation_familiale, numero_securite_sociale, id]
    );
    return res.affectedRows;
  }
  static async delete(id) {
    const [res] = await db.query('DELETE FROM patients WHERE id = ?', [id]);
    return res.affectedRows;
  }
  static async search(term) {
    const like = `%${term}%`;
    const [rows] = await db.query(
      'SELECT * FROM patients WHERE nom LIKE ? OR prenom LIKE ? OR telephone LIKE ? OR email LIKE ?',
      [like, like, like, like]
    );
    return rows;
  }
  static async updatePhoto(id, photoPath) {
    const [res] = await db.query('UPDATE patients SET photo = ? WHERE id = ?', [photoPath, id]);
    return res.affectedRows;
  }
  static async findByUserId(userId) {
    const [rows] = await db.query('SELECT * FROM patients WHERE user_id = ?', [userId]);
    return rows[0];
  }
}
module.exports = Patient;