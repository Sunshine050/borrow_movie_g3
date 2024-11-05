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


// ฟังก์ชันสำหรับดูประวัติการยืม
exports.getBorrowHistory = (req, res) => {
    const userRole = req.user.role; // สมมติว่า role ถูกแนบมากับ req.user
    const userId = req.user.user_id; // สมมติว่า user_id ถูกแนบมากับ req.user

    // ถ้าเป็น Student ให้ดึงประวัติของตัวเองเท่านั้น
    const query = userRole === 'Student'
        ? 'SELECT * FROM history WHERE borrower_id = ?'
        : 'SELECT * FROM history';

    const params = userRole === 'Student' ? [userId] : [];

    db.query(query, params, (err, results) => {
        if (err) {
            console.error('Error fetching borrow history:', err);
            return res.status(500).json({ error: 'Failed to fetch borrow history' });
        }
        res.json(results);
    });
};

// ฟังก์ชันสำหรับการคืนทรัพย์สิน
exports.returnAsset = (req, res) => {
    const { requestId } = req.body; // รับ requestId จากข้อมูลที่ส่งมา

    if (!requestId) {
        return res.status(400).json({ error: 'Request ID is required' });
    }

    // อัปเดตสถานะการคืนในฐานข้อมูล
    const returnSql = 'UPDATE request SET return_status = ?, return_date = ? WHERE request_id = ?';
    const returnDate = moment().toDate(); // วันที่คืน

    db.query(returnSql, ['returned', returnDate, requestId], (err, results) => {
        if (err) {
            console.error('Error updating return status:', err);
            return res.status(500).json({ error: 'Failed to return asset' });
        }
        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Borrow request not found' });
        }

        // อัปเดตข้อมูลในประวัติการยืม
        const updateHistorySql = 'UPDATE history SET returned_by = ?, return_date = ? WHERE request_id = ?';
        db.query(updateHistorySql, [req.user.user_id, returnDate, requestId], (err) => {
            if (err) {
                console.error('Error updating history:', err);
                return res.status(500).json({ error: 'Failed to update history' });
            }

            res.json({ message: 'Asset returned successfully', requestId });
        });
    });
};


module.exports = History;
