const db = require('./db');

class Facture {
  static async generateNumero() {
    const [rows] = await db.query("SELECT COUNT(*) as count FROM factures");
    const count = rows[0].count + 1;
    const year = new Date().getFullYear();
    return `F-${year}-${count.toString().padStart(4, '0')}`;
  }

  static async create(data, lignes) {
    const { patient_id, medecin_id, date_emission, date_echeance, motif } = data;
    const numero = await this.generateNumero();
    let total_ht = 0;
    for (const l of lignes) total_ht += l.quantite * l.prix_unitaire;
    const tva = total_ht * 0.2; // TVA 20%
    const total_ttc = total_ht + tva;
    const [res] = await db.query(
      `INSERT INTO factures 
            (patient_id, medecin_id, numero_facture, date_emission, date_echeance, total_ht, tva, total_ttc, motif, statut)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'impayee')`,
      [patient_id, medecin_id, numero, date_emission, date_echeance, total_ht, tva, total_ttc, motif]
    );
    const factureId = res.insertId;
    for (const l of lignes) {
      const total_ligne = l.quantite * l.prix_unitaire;
      await db.query(
        `INSERT INTO lignes_facture (facture_id, description, quantite, prix_unitaire, total_ligne)
                VALUES (?, ?, ?, ?, ?)`,
        [factureId, l.description, l.quantite, l.prix_unitaire, total_ligne]
      );
    }
    return factureId;
  }

  static async findByPatient(patientId) {
    const [rows] = await db.query(
      `SELECT f.*, m.nom as medecin_nom, m.prenom as medecin_prenom
             FROM factures f
             LEFT JOIN medecins m ON f.medecin_id = m.id
             WHERE f.patient_id = ?
             ORDER BY f.date_emission DESC`,
      [patientId]
    );
    return rows;
  }

  static async findById(id) {
    const [rows] = await db.query('SELECT * FROM factures WHERE id = ?', [id]);
    return rows[0];
  }

  static async getLignes(factureId) {
    const [rows] = await db.query('SELECT * FROM lignes_facture WHERE facture_id = ?', [factureId]);
    return rows;
  }

  static async payer(id) {
    await db.query('UPDATE factures SET statut = "payee" WHERE id = ?', [id]);
  }

  static async annuler(id) {
    await db.query('UPDATE factures SET statut = "annulee" WHERE id = ?', [id]);
  }
}
module.exports = Facture;