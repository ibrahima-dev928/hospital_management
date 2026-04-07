const db = require('./db');

class Rendezvous {
  static async findAll() {
    const [rows] = await db.query('SELECT * FROM rendezvous ORDER BY date_rdv DESC');
    return rows;
  }

  static async findById(id) {
    const [rows] = await db.query('SELECT * FROM rendezvous WHERE id = ?', [id]);
    return rows[0];
  }

  static async findByPatient(patientId) {
    const [rows] = await db.query(
      `SELECT r.*, 
                CONCAT(m.prenom, ' ', m.nom) AS medecin_nom,
                m.specialite
         FROM rendezvous r
         JOIN medecins m ON r.medecin_id = m.id
         WHERE r.patient_id = ?
         ORDER BY r.date_rdv DESC`,
      [patientId]
    );
    return rows;
  }

  static async findByMedecin(medecinId) {
    const [rows] = await db.query('SELECT * FROM rendezvous WHERE medecin_id = ? ORDER BY date_rdv DESC', [medecinId]);
    return rows;
  }

  static async create(data) {
    const { patient_id, medecin_id, date_rdv, heure_rdv, statut, duree, notes } = data;
    const datetime = `${date_rdv} ${heure_rdv}`;
    const [res] = await db.query(
      `INSERT INTO rendezvous (patient_id, medecin_id, date_rdv, heure_rdv, statut, duree, notes)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [patient_id, medecin_id, datetime, heure_rdv, statut || 'En attente', duree || '30 minutes', notes || null]
    );
    return res.insertId;
  }

  static async update(id, data) {
    const { patient_id, medecin_id, date_rdv, heure_rdv, statut, duree, notes } = data;
    const datetime = `${date_rdv} ${heure_rdv}`;
    const [res] = await db.query(
      `UPDATE rendezvous SET patient_id=?, medecin_id=?, date_rdv=?, heure_rdv=?, statut=?, duree=?, notes=?
             WHERE id=?`,
      [patient_id, medecin_id, datetime, heure_rdv, statut, duree, notes, id]
    );
    return res.affectedRows;
  }

  static async delete(id) {
    const [res] = await db.query('DELETE FROM rendezvous WHERE id = ?', [id]);
    return res.affectedRows;
  }

  static async search(term) {
    const like = `%${term}%`;
    const [rows] = await db.query(
      `SELECT r.*, 
                CONCAT(p.prenom, ' ', p.nom) as patient_nom,
                CONCAT(m.prenom, ' ', m.nom) as medecin_nom
         FROM rendezvous r
         LEFT JOIN patients p ON r.patient_id = p.id
         LEFT JOIN medecins m ON r.medecin_id = m.id
         WHERE r.notes LIKE ? OR r.statut LIKE ? 
            OR p.nom LIKE ? OR p.prenom LIKE ?
            OR m.nom LIKE ? OR m.prenom LIKE ?`,
      [like, like, like, like, like, like]
    );
    return rows;
  }

  static async getStats() {
    const [rows] = await db.query(`
            SELECT 
                COUNT(*) as total,
                SUM(statut = 'Confirmé') as confirmes,
                SUM(statut = 'En attente') as en_attente,
                SUM(statut = 'Annulé') as annules
            FROM rendezvous
        `);
    return rows[0];
  }

  // Ajoutez ces méthodes à la classe Rendezvous
  static async findByMedecin(medecinId, statut = null) {
    let sql = `SELECT r.*, 
                      CONCAT(p.prenom, ' ', p.nom) as patient_nom,
                      p.telephone as patient_tel,
                      CONCAT(m.prenom, ' ', m.nom) as medecin_nom
               FROM rendezvous r
               JOIN patients p ON r.patient_id = p.id
               JOIN medecins m ON r.medecin_id = m.id
               WHERE r.medecin_id = ?`;
    const params = [medecinId];
    if (statut) {
      sql += ' AND r.statut = ?';
      params.push(statut);
    }
    sql += ' ORDER BY r.date_rdv DESC';
    const [rows] = await db.query(sql, params);
    return rows;
  }

  //static async findByPatient(patientId) { /* déjà existant, à conserver */ }

  static async createWithUser(data) {
    const { patient_id, medecin_id, date_rdv, heure_rdv, motif } = data;
    const datetime = `${date_rdv} ${heure_rdv}`;
    const [res] = await db.query(
      `INSERT INTO rendezvous (patient_id, medecin_id, date_rdv, heure_rdv, statut, motif)
         VALUES (?, ?, ?, ?, 'en_attente', ?)`,
      [patient_id, medecin_id, datetime, heure_rdv, motif]
    );
    // Créer une notification pour le médecin
    const Notification = require('./Notification');
    const Patient = require('./Patient');
    const patient = await Patient.findById(patient_id);
    await Notification.create(
      medecin_id,
      `Nouvelle demande de rendez-vous de ${patient.prenom} ${patient.nom} pour le ${new Date(datetime).toLocaleString('fr-FR')}. Motif : ${motif || 'non précisé'}`,
      `/rendezvous/view/${res.insertId}`
    );
    return res.insertId;
  }

  static async updateStatus(id, statut, medecinId = null) {
    const [res] = await db.query('UPDATE rendezvous SET statut = ? WHERE id = ?', [statut, id]);
    if (res.affectedRows > 0 && medecinId) {
      // Notifier le patient (à implémenter si patient a un compte user)
      // Pour l'instant on peut notifier par email plus tard
    }
    return res.affectedRows;
  }
}

module.exports = Rendezvous;