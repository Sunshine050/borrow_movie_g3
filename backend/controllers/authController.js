const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// ฟังก์ชันลงทะเบียนผู้ใช้
exports.registerUser = (req, res) => {
    const { username, password, name, email } = req.body;

    bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) return res.status(500).send("Error hashing password");

        const sql = 'INSERT INTO user (username, password, name, email) VALUES (?, ?, ?, ?)';
        db.query(sql, [username, hashedPassword, name, email], (err) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error registering user");
            }
            res.send("Registration successful");
        });
    });
};

// ฟังก์ชันเข้าสู่ระบบผู้ใช้
exports.loginUser = (req, res) => {
    const { username, password } = req.body;

    const sql = 'SELECT * FROM user WHERE username = ?';
    db.query(sql, [username], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error finding user");
        }
        if (results.length === 0) {
            return res.status(404).send("User not found");
        }

        const user = results[0];
        bcrypt.compare(password, user.password, (err, isMatch) => {
            if (err) {
                console.error(err);
                return res.status(500).send("Error comparing passwords");
            }
            if (!isMatch) {
                return res.status(401).send("Invalid password");
            }

            const token = jwt.sign(
                { id: user.user_id, role: user.role },
                process.env.JWT_SECRET,
                { expiresIn: '1h' }
            );

            res.json({ message: "Login successful", token });
        });
    });
};

// ฟังก์ชันดึงข้อมูลผู้ใช้ทั้งหมด
exports.getAllUsers = (req, res) => {
    const sql = 'SELECT user_id, username, email, role, name FROM user';
    db.query(sql, (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error retrieving users");
        }
        res.status(200).json(results);
    });
};

// ฟังก์ชันดึงข้อมูลผู้ใช้ตาม ID
exports.getOneUser = (req, res) => {
    const { id } = req.params;
    const sql = 'SELECT user_id, username, email, role, name FROM user WHERE user_id = ?';
    db.query(sql, [id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error retrieving user");
        }
        if (results.length === 0) {
            return res.status(404).send("User not found");
        }
        res.status(200).json(results[0]);
    });
};

// ฟังก์ชันอนุมัติคำขอยืม
exports.approveRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.approver_by;

    const updateSql = 'UPDATE request SET approve_status = ?, return_status = ?, approved_by = ? WHERE request_id = ?';
    db.query(updateSql, ['approved', 'not_returned', approver_by, request_id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error approving request");
        }
        if (results.affectedRows === 0) {
            return res.status(404).send("Request not found");
        }

        // ส่งผลลัพธ์ที่ได้รับการอนุมัติพร้อมกับ approved_by
        res.json({ message: "Request approved successfully",  approver_by });
    });
};

// ฟังก์ชันสำหรับปฏิเสธคำขอยืม
exports.rejectRequest = (req, res) => {
    const { request_id } = req.params;
    const approver_by = req.user.approver_by; 

    const sql = 'UPDATE request SET approve_status = ?, approved_by = ? WHERE request_id = ?';
    db.query(sql, ['rejected', approver_by, request_id], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send("Error rejecting request");
        }
        if (results.affectedRows === 0) {
            return res.status(404).send("Request not found");
        }

        // ส่งผลลัพธ์การปฏิเสธพร้อมกับ approved_by
        res.json({ message: "Request rejected successfully",approver_by });
    });
};
