const mysql = require('mysql2/promise');

(async () => {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', // votre mot de passe si besoin
    database: 'hopital_v6'
  });

  const [users] = await connection.execute('SELECT id, nom, prenom, email FROM users WHERE role = "patient"');
  for (const user of users) {
    const [existing] = await connection.execute('SELECT id FROM patients WHERE user_id = ?', [user.id]);
    if (existing.length === 0) {
      await connection.execute(
        'INSERT INTO patients (nom, prenom, email, user_id) VALUES (?, ?, ?, ?)',
        [user.nom, user.prenom, user.email, user.id]
      );
      console.log(`✅ Fiche créée pour ${user.prenom} ${user.nom}`);
    } else {
      console.log(`ℹ️ Fiche existante pour ${user.prenom} ${user.nom}`);
    }
  }
  await connection.end();
  console.log('Terminé.');
})();