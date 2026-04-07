const db = require('./db');

class DossierMedical {
  static async findByPatientAndMedecin(patientId, medecinId) {
    const [rows] = await db.query(
      'SELECT * FROM dossiers_medicaux WHERE patient_id = ? AND medecin_id = ?',
      [patientId, medecinId]
    );
    return rows[0];
  }

  static async create(patientId, medecinId) {
    const [res] = await db.query(
      'INSERT INTO dossiers_medicaux (patient_id, medecin_id) VALUES (?, ?)',
      [patientId, medecinId]
    );
    return res.insertId;
  }

  static async getOrCreate(patientId, medecinId) {
    let dossier = await this.findByPatientAndMedecin(patientId, medecinId);
    if (!dossier) {
      const id = await this.create(patientId, medecinId);
      dossier = { id };
    }
    return dossier;
  }

  static async addPrescription(dossierMedicalId, data) {
    const { date_prescription, contenu, medicaments, posologie, duree, remarques } = data;
    const [res] = await db.query(
      `INSERT INTO prescriptions 
            (dossier_medical_id, date_prescription, contenu, medicaments, posologie, duree, remarques)
            VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [dossierMedicalId, date_prescription, contenu, medicaments || null, posologie || null, duree || null, remarques || null]
    );
    return res.insertId;
  }

  static async getPrescriptionsByDossier(dossierMedicalId) {
    const [rows] = await db.query(
      'SELECT * FROM prescriptions WHERE dossier_medical_id = ? ORDER BY date_prescription DESC',
      [dossierMedicalId]
    );
    return rows;
  }
}

module.exports = DossierMedical;