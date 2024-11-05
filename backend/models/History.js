const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

const History = {};

History.createHistory = (data, callback) => {
    const query = `
        INSERT INTO history (asset_id, borrower_id, request_id, approved_by, returned_by)
        VALUES (?, ?, ?, ?, ?)
    `;
    const params = [
        data.asset_id,
        data.borrower_id,
        data.request_id,
        data.approved_by || null,
        data.returned_by || null
    ];

    db.query(query, params, (err, results) => {
        if (err) {
            return callback(err);
        }
        callback(null, results.insertId); // ส่งกลับ ID ที่ถูกสร้างขึ้น
    });
};

module.exports = History;
