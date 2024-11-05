const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

const Asset = {
    // ฟังก์ชันดึงข้อมูลทั้งหมด
    getAll: (callback) => {
        db.query('SELECT * FROM asset', (err, results) => {
            if (err) {
                return callback(err, null);
            }
            return callback(null, results);
        });
    },

    // ฟังก์ชันค้นหาทรัพย์สินตาม ID
    getById: (assetId, callback) => {
        db.query('SELECT * FROM asset WHERE asset_id = ?', [assetId], (err, results) => {
            if (err) {
                return callback(err, null);
            }
            if (results.length === 0) {
                return callback(null, null); // ไม่มีทรัพย์สินที่พบ
            }
            return callback(null, results[0]); // ส่งคืนทรัพย์สินที่พบ
        });
    },

    // ฟังก์ชันสร้างทรัพย์สินใหม่
    create: (data, callback) => {
        const { asset_name, asset_status, file_path, categorie } = data;
        db.query('INSERT INTO asset (asset_name, asset_status, file_path, categorie) VALUES (?, ?, ?, ?)',
            [asset_name, asset_status, file_path, categorie], (err, results) => {
                if (err) {
                    return callback(err, null);
                }
                return callback(null, { id: results.insertId, ...data }); // ส่งคืน ID ที่สร้างขึ้นพร้อมกับข้อมูล
            });
    },

    // ฟังก์ชันอัปเดตข้อมูลทรัพย์สิน
    update: (assetId, data, callback) => {
        const { asset_name, asset_status, file_path, categorie } = data;
        db.query('UPDATE asset SET asset_name = ?, asset_status = ?, file_path = ?, categorie = ? WHERE asset_id = ?',
            [asset_name, asset_status, file_path, categorie, assetId], (err, results) => {
                if (err) {
                    return callback(err, null);
                }
                return callback(null, results.affectedRows > 0); // คืนค่าความสำเร็จ
            });
    },

    // ฟังก์ชันปิดการใช้งานทรัพย์สิน
    disable: (assetId, callback) => {
        db.query('UPDATE asset SET asset_status = "disabled" WHERE asset_id = ?', [assetId], (err, results) => {
            if (err) {
                return callback(err, null);
            }
            return callback(null, results.affectedRows > 0); // คืนค่าความสำเร็จ
        });
    }
};

module.exports = Asset;
