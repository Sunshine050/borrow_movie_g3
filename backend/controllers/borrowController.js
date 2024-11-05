const BorrowRequest = require('../models/BorrowRequest');
const moment = require('moment'); // ใช้ moment.js ในการจัดการวันที่
const History = require('../models/History'); // เพิ่มการเรียกใช้ History
const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล
const Asset = require('../models/Asset')

// ฟังก์ชันการขอยืม
exports.requestBorrow = (req, res) => {
    const { borrowerId, assetId, requestDate, duration } = req.body;

    console.log('Request data:', req.body); // log ข้อมูลคำขอ

    // ตรวจสอบทรัพย์สินว่ามีอยู่ในฐานข้อมูลหรือไม่
    Asset.getById(assetId, (err, asset) => {
        if (err) {
            console.error('Error fetching asset:', err.message);
            return res.status(500).json({ error: 'Error fetching asset: ' + err.message });
        }
        if (!asset) {
            console.warn('Asset not found with ID:', assetId);
            return res.status(404).json({ error: 'Asset not found' });
        }

        // เพิ่มโค้ดในการสร้างคำขอการยืมที่นี่
        console.log('Processing borrow request with data:', { borrowerId, assetId, requestDate, duration });

        // ส่งผลลัพธ์กลับไปยัง client
        res.status(201).json({ message: 'Borrow request processed successfully' });
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
    // Implementation needed
};

// ฟังก์ชันอนุมัติคำขอยืม
exports.approveRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.user_id;

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
    const approver_by = req.user.user_id;

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

// ฟังก์ชันสำหรับคืนทรัพย์สิน
exports.returnAsset = (req, res) => {
    const { requestId } = req.body;

    if (!requestId) {
        return res.status(400).json({ error: 'Request ID is required' });
    }

    // อัปเดตสถานะการคืนในฐานข้อมูล
    const returnSql = 'UPDATE request SET return_status = ?, return_date = ? WHERE request_id = ?';
    const returnDate = moment().toDate();

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
