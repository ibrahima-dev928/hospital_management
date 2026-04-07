const db = require('./db');

class Chambre {
  static async findAvailable(batimentId = null) {
    let sql = `SELECT c.*, b.nom as batiment_nom FROM chambres c 
                   JOIN batiments b ON c.batiment_id = b.id 
                   WHERE c.disponible = 1 AND c.actif = 1`;
    const params = [];
    if (batimentId) {
      sql += ' AND c.batiment_id = ?';
      params.push(batimentId);
    }
    sql += ' ORDER BY b.nom, c.numero';
    const [rows] = await db.query(sql, params);
    return rows;
  }

  static async findAll() {
    const [rows] = await db.query(`
            SELECT c.*, b.nom as batiment_nom 
            FROM chambres c 
            JOIN batiments b ON c.batiment_id = b.id 
            ORDER BY b.nom, c.numero
        `);
    return rows;
  }

  static async findById(id) {
    const [rows] = await db.query(`
            SELECT c.*, b.nom as batiment_nom 
            FROM chambres c 
            JOIN batiments b ON c.batiment_id = b.id 
            WHERE c.id = ?
        `, [id]);
    return rows[0];
  }

  static async create(data) {
    const { batiment_id, numero, type, capacite } = data;
    const [res] = await db.query(
      'INSERT INTO chambres (batiment_id, numero, type, capacite) VALUES (?, ?, ?, ?)',
      [batiment_id, numero, type, capacite || 1]
    );
    return res.insertId;
  }

  static async update(id, data) {
    const { batiment_id, numero, type, capacite, actif } = data;
    await db.query(
      'UPDATE chambres SET batiment_id=?, numero=?, type=?, capacite=?, actif=? WHERE id=?',
      [batiment_id, numero, type, capacite, actif, id]
    );
  }

  static async delete(id) {
    await db.query('DELETE FROM chambres WHERE id = ?', [id]);
  }

  static async updateDisponibilite(id, disponible) {
    await db.query('UPDATE chambres SET disponible = ? WHERE id = ?', [disponible, id]);
  }
}
module.exports = Chambre;