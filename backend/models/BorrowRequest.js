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
        data.borrowDate,
        data.returnDate,
        'pending'
    ];

    db.query(query, params, (err, results) => {
        if (err) {
            console.error('Error inserting borrow request:', err); // log ข้อผิดพลาด
            return callback(err);
        }

        // ตรวจสอบว่า results มีค่า insertId หรือไม่
        if (results && results.insertId) {
            console.log('Borrow request created successfully, ID:', results.insertId); 
            callback(null, { insertId: results.insertId }); // ส่งกลับ ID ที่สร้างใหม่
        } else {
            console.warn('No insertId found in results:', results);
            callback(null, { insertId: null }); // หรืออาจจะส่งค่าที่เหมาะสมอื่นๆ
        }
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
