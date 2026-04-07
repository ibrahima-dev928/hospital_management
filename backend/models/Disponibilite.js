const db = require('./db');

class Disponibilite {
  static async findByMedecin(medecinId) {
    const [rows] = await db.query('SELECT * FROM disponibilites WHERE medecin_id = ? AND actif = 1 ORDER BY jour_semaine, heure_debut', [medecinId]);
    return rows;
  }

  static async create(data) {
    const { medecin_id, jour_semaine, heure_debut, heure_fin, duree_rdv } = data;
    const [res] = await db.query(
      'INSERT INTO disponibilites (medecin_id, jour_semaine, heure_debut, heure_fin, duree_rdv) VALUES (?, ?, ?, ?, ?)',
      [medecin_id, jour_semaine, heure_debut, heure_fin, duree_rdv || 30]
    );
    return res.insertId;
  }

  static async delete(id) {
    await db.query('DELETE FROM disponibilites WHERE id = ?', [id]);
  }
}

module.exports = Disponibilite;