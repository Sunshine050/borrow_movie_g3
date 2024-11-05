const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

const BorrowRequest = {};

// ฟังก์ชันสำหรับการสร้างคำขอยืม
BorrowRequest.create = (data, callback) => {
    const query = `
        INSERT INTO request (borrower_id, asset_id, borrow_date, return_date, approve_status)
        VALUES (?, ?, ?, ?, ?)
    `;
    const params = [
        data.borrowerId,
        data.assetId,
        data.borrowDate,   // วันที่ยืม
        data.returnDate,   // วันที่คืน
        'pending'          // สถานะการอนุมัติเริ่มต้น
    ];

    db.query(query, params, (err, results) => {
        if (err) {
            return callback(err);
        }
        callback(null, results);
    });
};

// ฟังก์ชันสำหรับดึงคำขอยืมทั้งหมด
BorrowRequest.getAll = (callback) => {
    db.query('SELECT * FROM request', (err, results) => {
        if (err) {
            return callback(err);
        }
        callback(null, results);
    });
};

// ฟังก์ชันสำหรับดึงคำขอยืมตาม ID
BorrowRequest.getById = (id, callback) => {
    const query = 'SELECT * FROM request WHERE request_id = ?';
    db.query(query, [id], (err, results) => {
        if (err) {
            return callback(err);
        }
        callback(null, results[0]); // ส่งผลลัพธ์ที่เป็นรายการเดียว
    });
};

// ส่งออกโมดูล BorrowRequest
module.exports = BorrowRequest;
