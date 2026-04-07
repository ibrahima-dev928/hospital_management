const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

async function updatePasswords() {
  // Adaptez les identifiants MySQL selon votre configuration
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',   // Laissez vide si pas de mot de passe, sinon mettez le vôtre
    database: 'hopital_v6'
  });

  // Hash du mot de passe "admin123"
  const hash = await bcrypt.hash('admin123', 10);
  console.log('Hash généré:', hash);

  // Mettre à jour tous les utilisateurs
  await connection.execute('UPDATE users SET password = ?', [hash]);
  console.log('✅ Mots de passe mis à jour pour tous les utilisateurs');

  await connection.end();
}

updatePasswords().catch(console.error);