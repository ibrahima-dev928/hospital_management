const db = require('./db');

class Admission {
  static async create(data) {
    const { patient_id, medecin_id, chambre_id, date_admission, motif } = data;
    const [res] = await db.query(
      `INSERT INTO admissions (patient_id, medecin_id, chambre_id, date_admission, motif, statut)
             VALUES (?, ?, ?, ?, ?, 'en_cours')`,
      [patient_id, medecin_id, chambre_id, date_admission, motif]
    );
    // Marquer la chambre comme indisponible
    await db.query('UPDATE chambres SET disponible = 0 WHERE id = ?', [chambre_id]);
    return res.insertId;
  }

  static async findActiveByPatient(patientId) {
    const [rows] = await db.query(
      `SELECT a.*, c.numero, b.nom as batiment_nom, m.nom as medecin_nom, m.prenom as medecin_prenom
             FROM admissions a
             JOIN chambres c ON a.chambre_id = c.id
             JOIN batiments b ON c.batiment_id = b.id
             JOIN medecins m ON a.medecin_id = m.id
             WHERE a.patient_id = ? AND a.statut = 'en_cours'
             ORDER BY a.date_admission DESC`,
      [patientId]
    );
    return rows;
  }

  static async findActiveByMedecin(medecinId) {
    const [rows] = await db.query(
      `SELECT a.*, p.nom as patient_nom, p.prenom as patient_prenom, c.numero, b.nom as batiment_nom
             FROM admissions a
             JOIN patients p ON a.patient_id = p.id
             JOIN chambres c ON a.chambre_id = c.id
             JOIN batiments b ON c.batiment_id = b.id
             WHERE a.medecin_id = ? AND a.statut = 'en_cours'
             ORDER BY a.date_admission DESC`,
      [medecinId]
    );
    return rows;
  }

  static async liberer(id, date_sortie) {
    const admission = await db.query('SELECT chambre_id FROM admissions WHERE id = ?', [id]);
    if (admission[0].length) {
      const chambreId = admission[0][0].chambre_id;
      await db.query('UPDATE chambres SET disponible = 1 WHERE id = ?', [chambreId]);
    }
    await db.query('UPDATE admissions SET statut = "terminee", date_sortie = ? WHERE id = ?', [date_sortie, id]);
  }

  static async getHistoriqueByPatient(patientId) {
    const [rows] = await db.query(
      `SELECT a.*, c.numero, b.nom as batiment_nom, m.nom as medecin_nom, m.prenom as medecin_prenom
             FROM admissions a
             JOIN chambres c ON a.chambre_id = c.id
             JOIN batiments b ON c.batiment_id = b.id
             JOIN medecins m ON a.medecin_id = m.id
             WHERE a.patient_id = ? AND a.statut != 'en_cours'
             ORDER BY a.date_admission DESC`,
      [patientId]
    );
    return rows;
  }
}
module.exports = Admission;