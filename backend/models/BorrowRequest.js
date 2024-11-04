const db = require('../config/db');

const BorrowRequest = {
    create: (data, callback) => {
        db.query('INSERT INTO request SET ?', data, callback);
    },
    getAll: (callback) => {
        db.query('SELECT * FROM request', callback);
    },
    updateStatus: (id, status, callback) => {
        db.query('UPDATE request SET approve_status = ? WHERE id = ?', [status, id], callback);
    },
    getHistory: (userId, callback) => {
        // ดึงประวัติการยืมตาม borrower_id
        db.query('SELECT * FROM request WHERE borrower_id = ?', [userId], callback);
    }
};

module.exports = BorrowRequest;
