const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

async function fixPasswords() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', // ← mettez votre mot de passe MySQL s'il y en a un
    database: 'hopital_v6'
  });

  // Générer un hash frais pour "admin123"
  const hash = await bcrypt.hash('admin123', 10);
  console.log('Nouveau hash généré:', hash);

  // Mettre à jour tous les utilisateurs
  await connection.execute('UPDATE users SET password = ?', [hash]);

  console.log('✅ Mots de passe mis à jour pour tous les utilisateurs');

  // Vérification
  const [rows] = await connection.execute('SELECT id, username, password FROM users');
  for (const user of rows) {
    const isValid = await bcrypt.compare('admin123', user.password);
    console.log(`Utilisateur ${user.username} : mot de passe valide ? ${isValid}`);
  }

  await connection.end();
}

fixPasswords().catch(console.error);