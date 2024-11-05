const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { verifyToken } = require('../middleware/authMiddleware');

// เส้นทางสำหรับนักเรียน (Borrower)
router.post('/login', authController.loginUser);
router.post('/register', authController.registerUser);

// เส้นทางสำหรับเจ้าหน้าที่ (Staff) และผู้บังคับบัญชา (Lecturer)
router.get('/user', verifyToken, authController.getAllUsers);
router.get('/users/:id', verifyToken, authController.getOneUser);

module.exports = router;
