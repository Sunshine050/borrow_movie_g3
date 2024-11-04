const Asset = require('../models/Asset');

// ดึงข้อมูลทรัพย์สินทั้งหมด
exports.getAssets = (req, res) => {
    Asset.getAll((err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
};

// เพิ่มทรัพย์สินใหม่ (เฉพาะ Staff)
exports.createAsset = (req, res) => {
    const data = req.body;
    Asset.create(data, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Asset created', assetId: results.insertId });
    });
};

// แก้ไขทรัพย์สิน
exports.updateAsset = (req, res) => {
    const assetId = req.params.id; // ID ของทรัพย์สินที่จะแก้ไข
    const data = req.body; // ข้อมูลที่จะแก้ไข

    Asset.update(assetId, data, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.affectedRows === 0) {
            return res.status(404).json({ message: 'Asset not found' });
        }
        res.json({ message: 'Asset updated' });
    });
};

// ปิดใช้งานทรัพย์สิน
exports.disableAsset = (req, res) => {
    const assetId = req.params.id; // ID ของทรัพย์สินที่จะแก้ไข

    Asset.disable(assetId, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.affectedRows === 0) {
            return res.status(404).json({ message: 'Asset not found' });
        }
        res.json({ message: 'Asset disabled' });
    });
};
