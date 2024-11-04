const jwt = require('jsonwebtoken');

// Middleware เพื่อยืนยันโทเคน
const verifyToken = (req, res, next) => {
    const token = req.header('Authorization')?.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'Access denied' });

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) return res.status(400).json({ message: 'Invalid token' });
        req.user = decoded; // เก็บข้อมูลผู้ใช้ที่ตรวจสอบแล้ว
        next();
    });
};

// ส่งออกฟังก์ชัน middleware
module.exports = { verifyToken };
