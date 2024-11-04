const express = require('express');
const router = express.Router();
const assetController = require('../controllers/assetController');

// ดึงข้อมูลทรัพย์สินทั้งหมด (ทุกบทบาทสามารถเข้าถึง)
router.get('/', assetController.getAssets); // เปลี่ยน '/api/assets' เป็น '/' เพื่อให้ตรงกับ base route

// ตั้งค่าเส้นทาง POST สำหรับสร้าง asset
router.post('/create', assetController.createAsset); // ลบ verifyToken และ checkRole ออก

// แก้ไขทรัพย์สิน
router.put('/:id', assetController.updateAsset); // ลบ verifyToken และ checkRole ออก

// ปิดใช้งานทรัพย์สิน
router.delete('/:id', assetController.disableAsset); // ลบ verifyToken และ checkRole ออก

module.exports = router;
