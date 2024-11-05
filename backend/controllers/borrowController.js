const BorrowRequest = require('../models/BorrowRequest');
const moment = require('moment'); // ใช้ moment.js ในการจัดการวันที่
// const BorrowStatus = require('../models/History');
const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

// ฟังก์ชันสำหรับสร้างคำขอยืม
exports.requestBorrow = (req, res) => {
    const { borrowerId, assetId, requestDate, duration } = req.body;

    // ตรวจสอบค่าที่ได้รับ
    if (!borrowerId || !assetId || !requestDate || !duration) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    // คำนวณวันที่คืน
    const borrowDate = moment(requestDate).toDate(); // แปลง requestDate เป็น Date
    const returnDate = moment(borrowDate).add(duration, 'days').toDate(); // คำนวณ returnDate

    // กำหนดค่า approve_status เป็น 'pending' โดยตรง
    const requestData = {
        borrower_id: borrowerId,
        asset_id: assetId,
        borrow_date: borrowDate,
        return_date: returnDate,
        approve_status: 'pending' // กำหนดสถานะเป็น 'pending' โดยตรง
    };

    // ส่งข้อมูลไปยังฐานข้อมูลเพื่อสร้างคำขอ
    db.query('INSERT INTO Request SET ?', requestData, (err, result) => {
        if (err) {
            console.error('Error creating request:', err);
            return res.status(500).json({ error: 'Failed to create request' });
        }

        // สร้างข้อมูลที่จะเพิ่มใน history โดยใช้ข้อมูลจาก request
        const historyData = {
            asset_id: assetId,
            borrower_id: borrowerId,
            request_id: result.insertId, // ใช้ ID ของคำขอที่เพิ่มใหม่
            approved_by: null, // หากต้องการกำหนดค่าในอนาคต
            returned_by: null // หากต้องการกำหนดค่าในอนาคต
            // เพิ่มข้อมูลอื่นๆ ที่ต้องการเก็บใน history หากมี
        };
    });
};

// ฟังก์ชันสำหรับดึงคำขอยืมทั้งหมด
exports.getBorrowRequest = (req, res) => {
    BorrowRequest.getAll((err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to fetch borrow requests' });
        }
        res.json(results);
    });
};

// ฟังก์ชันสำหรับดึงคำขอยืมตาม ID
exports.getBorrowRequestById = (req, res) => {
    const id = req.params.id;
    BorrowRequest.getById(id, (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to fetch borrow request' });
        }
        if (!result) {
            return res.status(404).json({ error: 'Borrow request not found' });
        }
        res.json(result);
    });
};

// ฟังก์ชันสำหรับดูประวัติการยืม
exports.getBorrowHistory = async (req, res) => {
};

// ฟังก์ชันอนุมัติคำขอยืม
exports.approveRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.user_id; // ใช้ `approver_by` แทน `user_id`

    // อัปเดตสถานะของคำขอ
    const updateSql = 'UPDATE request SET approve_status = ?, return_status = ?, approved_by = ? WHERE request_id = ?';
    db.query(updateSql, ['approved', 'not_returned', approver_by, request_id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error approving request");
        }
        if (results.affectedRows === 0) {
            return res.status(404).send("Request not found");
        }

        // อัปเดตข้อมูลในประวัติ
        const updateHistorySql = 'UPDATE history SET approved_by = ? WHERE request_id = ?';
        db.query(updateHistorySql, [approver_by, request_id], (err) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error updating history");
            }

            // ดึงชื่อผู้อนุมัติจากตาราง user
            const selectUserSql = 'SELECT name FROM user WHERE user_id = ?';
            db.query(selectUserSql, [approver_by], (err, userResult) => {
                if (err) {
                    console.error(err);
                    return res.status(500).send("Error retrieving approver information");
                }
                const approverName = userResult[0]?.name || 'Unknown';

                // ส่งผลลัพธ์ที่ได้รับการอนุมัติพร้อมกับชื่อผู้อนุมัติ
                res.json({
                    message: "Request approved successfully",
                    approved_by: approverName,
                    approved_by_id: approver_by
                });
            });
        });
    });
};

// ฟังก์ชันสำหรับปฏิเสธคำขอยืม
exports.rejectRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.user_id; // ใช้ `approver_by` แทน `user_id`

    // อัปเดตสถานะการปฏิเสธ
    const sql = 'UPDATE request SET approve_status = ?, approved_by = ? WHERE request_id = ?';
    db.query(sql, ['rejected', approver_by, request_id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error rejecting request");
        }
        if (results.affectedRows === 0) {
            return res.status(404).send("Request not found");
        }

        // อัปเดตข้อมูลในประวัติ
        const updateHistorySql = 'UPDATE history SET approved_by = ? WHERE request_id = ?';
        db.query(updateHistorySql, [approver_by, request_id], (err) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error updating history");
            }
            res.json({ message: "Request rejected successfully", approved_by: approver_by });
        });
    });
};


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