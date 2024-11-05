const express = require('express');
const router = express.Router();
const borrowController = require('../controllers/borrowController');
const { verifyToken } = require('../middleware/authMiddleware');

// เส้นทางสำหรับนักเรียน (Borrower)
router.post('/borrower', verifyToken, borrowController.requestBorrow); // นักเรียนส่งคำขอยืม
router.get('/', verifyToken, borrowController.getBorrowRequest); // นักเรียนตรวจสอบสถานะคำขอยืม
router.get('/:id', verifyToken, borrowController.getBorrowRequestById); // นักเรียนดึงคำขอยืมตาม ID

// เส้นทางสำหรับเจ้าหน้าที่ (Staff) และผู้บังคับบัญชา (Lecturer)
router.get('/history', verifyToken, borrowController.getBorrowHistory); // เจ้าหน้าที่ดูประวัติการยืม
router.patch('/approve/:request_id', verifyToken, borrowController.approveRequest); // เจ้าหน้าที่อนุมัติคำขอยืม
router.post('/reject/:request_id', verifyToken, borrowController.rejectRequest); // เจ้าหน้าที่ปฏิเสธคำขอยืม
// router.post('/return', verifyToken, borrowController.returnAsset);
module.exports = router;
