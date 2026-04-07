const db = require('./db');

class Preference {
  static async getGlobal() {
    const [rows] = await db.query('SELECT * FROM preferences WHERE user_id IS NULL LIMIT 1');
    return rows[0];
  }

  static async updateGlobal(data) {
    const { theme, notifications, language, results_per_page, auto_save, hospital_name, hospital_address, hospital_phone } = data;
    const [res] = await db.query(
      `UPDATE preferences SET
                theme = COALESCE(?, theme),
                notifications = COALESCE(?, notifications),
                language = COALESCE(?, language),
                results_per_page = COALESCE(?, results_per_page),
                auto_save = COALESCE(?, auto_save),
                hospital_name = COALESCE(?, hospital_name),
                hospital_address = COALESCE(?, hospital_address),
                hospital_phone = COALESCE(?, hospital_phone)
             WHERE user_id IS NULL`,
      [theme, notifications, language, results_per_page, auto_save, hospital_name, hospital_address, hospital_phone]
    );
    return res.affectedRows;
  }
}

module.exports = Preference;