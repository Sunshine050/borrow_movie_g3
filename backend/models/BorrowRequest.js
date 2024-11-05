const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

const History = {};

// ฟังก์ชันสำหรับเพิ่มข้อมูลลงใน history
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
        callback(null, results);
    });
};

const BorrowRequest = {};

// ฟังก์ชันสำหรับดึงคำขอยืมทั้งหมด
BorrowRequest.getAll = (callback) => {
    db.query('SELECT * FROM request', (err, results) => {
        if (err) {
            return callback(err);
        }
        callback(null, results);
    });
};

module.exports = History;
