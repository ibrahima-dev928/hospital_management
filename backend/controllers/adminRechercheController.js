const db = require('../models/db');

exports.recherche = async (req, res) => {
  const { q, type } = req.query;
  let results = { patients: [], medecins: [], chambres: [], admissions: [] };

  if (q && q.trim() !== '') {
    const searchTerm = `%${q}%`;
    if (type === 'all' || type === 'patient') {
      const [patients] = await db.query(`
                SELECT p.*, 
                    (SELECT a.chambre_id FROM admissions a WHERE a.patient_id = p.id AND a.statut = 'en_cours' LIMIT 1) as chambre_id,
                    (SELECT c.numero FROM chambres c WHERE c.id = chambre_id) as chambre_numero
                FROM patients p
                WHERE p.nom LIKE ? OR p.prenom LIKE ? OR p.telephone LIKE ? OR p.email LIKE ?
            `, [searchTerm, searchTerm, searchTerm, searchTerm]);
      results.patients = patients;
    }
    if (type === 'all' || type === 'medecin') {
      const [medecins] = await db.query(`
                SELECT m.*, 
                    (SELECT COUNT(*) FROM rendezvous r WHERE r.medecin_id = m.id AND r.date_rdv > NOW() AND r.statut = 'confirmé') as rdv_a_venir
                FROM medecins m
                WHERE m.nom LIKE ? OR m.prenom LIKE ? OR m.specialite LIKE ? OR m.telephone LIKE ?
            `, [searchTerm, searchTerm, searchTerm, searchTerm]);
      results.medecins = medecins;
    }
    if (type === 'all' || type === 'chambre') {
      const [chambres] = await db.query(`
                SELECT c.*, b.nom as batiment_nom
                FROM chambres c
                JOIN batiments b ON c.batiment_id = b.id
                WHERE c.disponible = 1 AND c.actif = 1
                  AND (c.numero LIKE ? OR b.nom LIKE ? OR c.type LIKE ?)
                LIMIT 20
            `, [searchTerm, searchTerm, searchTerm]);
      results.chambres = chambres;
    }
    if (type === 'all' || type === 'admission') {
      const [admissions] = await db.query(`
                SELECT a.*, p.nom as patient_nom, p.prenom as patient_prenom, c.numero, b.nom as batiment_nom
                FROM admissions a
                JOIN patients p ON a.patient_id = p.id
                JOIN chambres c ON a.chambre_id = c.id
                JOIN batiments b ON c.batiment_id = b.id
                WHERE a.statut = 'en_cours' AND (p.nom LIKE ? OR p.prenom LIKE ? OR c.numero LIKE ?)
            `, [searchTerm, searchTerm, searchTerm]);
      results.admissions = admissions;
    }
  }

  res.render('admin/recherche', { results, q, type, title: 'Résultats de recherche' });
};