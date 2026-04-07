const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

(async () => {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', // ← votre mot de passe MySQL (laissez vide si pas de mot de passe)
    database: 'hopital_v6'
  });

  const hash = await bcrypt.hash('admin123', 10);
  await connection.execute('UPDATE users SET password = ?', [hash]);
  console.log('✅ Tous les mots de passe ont été réinitialisés à "admin123"');

  const [rows] = await connection.execute('SELECT username FROM users');
  console.log('Utilisateurs concernés :', rows.map(r => r.username).join(', '));

  await connection.end();
})();