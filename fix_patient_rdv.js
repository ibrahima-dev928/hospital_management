const mysql = require('mysql2/promise');

(async () => {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', // votre mot de passe
    database: 'hopital_v6'
  });

  // 1. Créer les fiches patient manquantes
  await connection.execute(`
        INSERT INTO patients (nom, prenom, email, user_id)
        SELECT u.nom, u.prenom, u.email, u.id
        FROM users u
        WHERE u.role = 'patient' 
          AND u.id NOT IN (SELECT user_id FROM patients WHERE user_id IS NOT NULL)
    `);
  console.log('✅ Fiches patient créées');

  // 2. Mettre à jour les rendez-vous sans patient_id valide
  await connection.execute(`
        UPDATE rendezvous r
        SET patient_id = (
            SELECT p.id FROM patients p
            WHERE p.user_id = (SELECT u.id FROM users u WHERE u.username = 'patient 1')
        )
        WHERE r.patient_id IS NULL OR r.patient_id NOT IN (SELECT id FROM patients)
    `);
  console.log('✅ Rendez-vous corrigés');

  await connection.end();
  console.log('Terminé.');
})();