const BorrowRequest = require('../models/BorrowRequest');
const moment = require('moment'); // ใช้ moment.js ในการจัดการวันที่
const BorrowStatus = require('../models/BorrowStatus');
const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

// ฟังก์ชันสำหรับสร้างคำขอยืม
exports.requestBorrow = async (req, res) => {
    const { borrowerId, assetId, requestDate, duration } = req.body;

    // ตรวจสอบค่าที่ได้รับ
    if (!borrowerId || !assetId || !requestDate || !duration) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        // คำนวณวันที่คืน
        const borrowDate = moment(requestDate).toDate(); // แปลง requestDate เป็น Date
        const returnDate = moment(borrowDate).add(duration, 'days').toDate(); // คำนวณ returnDate

        // ดึงสถานะ 'pending' จากฐานข้อมูล
        const defaultStatus = await BorrowStatus.findOne({ where: { statusName: 'pending' } });
        if (!defaultStatus) {
            return res.status(500).json({ error: 'Default status not found' });
        }

        // สร้างข้อมูลสำหรับการสร้างการจอง
        const data = {
            borrower_id: borrowerId,
            asset_id: assetId,
            borrow_date: borrowDate,
            return_date: returnDate,
            approve_status: defaultStatus.id // ใช้ ID ของสถานะที่ดึงมาจากฐานข้อมูล
        };

        // ส่งข้อมูลไปยัง BorrowRequest.create
        const result = await BorrowRequest.create(data);
        res.status(201).json({ message: 'Borrow request created', requestId: result.insertId });
    } catch (err) {
        console.error('Error creating borrow request:', err);
        return res.status(500).json({ error: 'Failed to create borrow request' });
    }
};

// ฟังก์ชันสำหรับดึงคำขอยืมทั้งหมด
exports.getBorrowRequest = async (req, res) => {
    try {
        const results = await BorrowRequest.getAll();
        res.json(results);
    } catch (err) {
        console.error('Error fetching borrow requests:', err);
        return res.status(500).json({ error: 'Failed to fetch borrow requests' });
    }
};

// ฟังก์ชันสำหรับดูประวัติการยืม
exports.getBorrowHistory = async (req, res) => {
    const userId = req.user.id; // สมมติว่าคุณมีการจัดการผู้ใช้ใน req.user

    try {
        const results = await BorrowRequest.getHistory(userId);
        res.json(results);
    } catch (err) {
        console.error('Error fetching borrow history:', err);
        return res.status(500).json({ error: 'Failed to fetch borrow history' });
    }
};// ฟังก์ชันอนุมัติคำขอยืม
exports.approveRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.user_id; // ใช้ `approver_by` แทน `user_id`

    const updateSql = 'UPDATE request SET approve_status = ?, return_status = ?, approved_by = ? WHERE request_id = ?';
    db.query(updateSql, ['approved', 'not_returned', approver_by, request_id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error approving request");
        }
        if (results.affectedRows === 0) {
            return res.status(404).send("Request not found");
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
};

// ฟังก์ชันสำหรับปฏิเสธคำขอยืม
exports.rejectRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.user_id; // ใช้ `approver_by` แทน `user_id`

    const sql = 'UPDATE request SET approve_status = ?, approved_by = ? WHERE request_id = ?';
    db.query(sql, ['rejected', approver_by, request_id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error rejecting request");
        }
        if (results.affectedRows === 0) {
            return res.status(404).send("Request not found");
        }

        // ส่งผลลัพธ์การปฏิเสธพร้อมกับ approver_by
        res.json({ message: "Request rejected successfully", approved_by: approver_by });
    });
};

