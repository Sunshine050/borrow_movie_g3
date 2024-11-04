const express = require('express');
const router = express.Router();
const borrowController = require('../controllers/borrowController');
const { verifyToken } = require('../middleware/authMiddleware');

// เส้นทางสำหรับนักเรียน (Borrower)
router.post('/', verifyToken, borrowController.requestBorrow); // นักเรียนส่งคำขอยืม
router.get('/', verifyToken, borrowController.getBorrowRequest); // นักเรียนตรวจสอบสถานะคำขอยืม

// เส้นทางสำหรับเจ้าหน้าที่ (Staff) และผู้บังคับบัญชา (Lecturer)
router.get('/history', verifyToken, borrowController.getBorrowHistory); // เจ้าหน้าที่ดูประวัติการยืม

module.exports = router;
