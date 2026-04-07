const db = require('./db');

class Notification {
  static async create(userId, message, lien = null) {
    const [res] = await db.query(
      'INSERT INTO notifications (user_id, message, lien) VALUES (?, ?, ?)',
      [userId, message, lien]
    );
    return res.insertId;
  }

  static async getNonLues(userId) {
    const [rows] = await db.query('SELECT * FROM notifications WHERE user_id = ? AND lue = 0 ORDER BY created_at DESC', [userId]);
    return rows;
  }

  static async getAll(userId, limit = 50) {
    const [rows] = await db.query('SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?', [userId, limit]);
    return rows;
  }

  static async markAsRead(id) {
    await db.query('UPDATE notifications SET lue = 1 WHERE id = ?', [id]);
  }

  static async markAllAsRead(userId) {
    await db.query('UPDATE notifications SET lue = 1 WHERE user_id = ?', [userId]);
  }
  
}

module.exports = Notification;