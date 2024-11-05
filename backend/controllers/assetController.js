const Asset = require('../models/Asset');
const Request = require('../models/BorrowRequest'); // เพิ่มการ require โมดูล Request


// ฟังก์ชันสร้างคำขอใหม่ในตาราง request
exports.createRequest = (req, res) => {
    const requestData = req.body; // ข้อมูลคำขอที่ส่งมาจาก client

    // ตรวจสอบความถูกต้องของข้อมูล
    if (!requestData.asset_id || !requestData.borrower_id) {
        return res.status(400).json({ error: 'Missing required fields: asset_id and borrower_id are required.' });
    }

    console.log('Creating request with data:', requestData); // log ข้อมูลที่รับเข้าม

    // เพิ่มข้อมูลคำขอลงในตาราง request
    Request.create(requestData, (err, requestResults) => {
        if (err) {
            console.error('Error creating request:', err.message); // log ข้อผิดพลาด
            return res.status(500).json({ error: 'Error creating request: ' + err.message });
        }

        console.log('Request created successfully, request ID:', requestResults.insertId); // log ID ของคำขอที่สร้าง

        // ส่งผลลัพธ์กลับไปยัง client
        res.status(201).json({ message: 'Request created', requestId: requestResults.insertId });
    });
};


// แก้ไขทรัพย์สิน
exports.updateAsset = (req, res) => {
    const assetId = req.params.id; // ID ของทรัพย์สินที่จะแก้ไข
    const data = req.body; // ข้อมูลที่จะแก้ไข
    console.log('Updating asset with ID:', assetId, 'Data:', data); // log ID และข้อมูลที่จะอัปเดต

    Asset.update(assetId, data, (err, results) => {
        if (err) {
            console.error('Error updating asset:', err.message); // log ข้อผิดพลาด
            return res.status(500).json({ error: 'Error updating asset: ' + err.message });
        }
        if (results.affectedRows === 0) {
            console.warn('Asset not found with ID:', assetId); // log เตือนกรณีไม่พบทรัพย์สิน
            return res.status(404).json({ message: 'Asset not found' });
        }
        console.log('Asset updated successfully'); // log เมื่ออัปเดตสำเร็จ
        res.json({ message: 'Asset updated' });
    });
};

// ปิดใช้งานทรัพย์สิน
exports.disableAsset = (req, res) => {
    const assetId = req.params.id; // ID ของทรัพย์สินที่จะแก้ไข
    console.log('Disabling asset with ID:', assetId); // log ID ของทรัพย์สินที่จะปิดใช้งาน

    Asset.disable(assetId, (err, results) => {
        if (err) {
            console.error('Error disabling asset:', err.message); // log ข้อผิดพลาด
            return res.status(500).json({ error: 'Error disabling asset: ' + err.message });
        }
        if (results.affectedRows === 0) {
            console.warn('Asset not found with ID:', assetId); // log เตือนกรณีไม่พบทรัพย์สิน
            return res.status(404).json({ message: 'Asset not found' });
        }
        console.log('Asset disabled successfully'); // log เมื่อปิดใช้งานสำเร็จ
        res.json({ message: 'Asset disabled' });
    });
};

exports.getAssets = (req, res) => {
    console.log('Fetching all assets...');
    // เพิ่มโค้ดการดึงข้อมูลจากฐานข้อมูลที่นี่
    Asset.getAll((err, results) => {
        if (err) {
            console.error('Error fetching assets:', err.message);
            return res.status(500).json({ error: 'Unable to fetch assets: ' + err.message });
        }
        console.log('Assets fetched successfully:', results);
        res.json(results);
    });
};