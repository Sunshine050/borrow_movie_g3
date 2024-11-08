const Request = require('../models/BorrowRequest'); // เพิ่มการ require โมดูล Request
const Asset = require('../models/Asset'); // เพิ่มการ require โมดูล Asset

exports.createRequest = (req, res) => {
    const requestData = req.body;

    // ตรวจสอบความถูกต้องของข้อมูล
    if (!requestData.assetId || !requestData.borrowerId || !requestData.borrowDate || !requestData.returnDate) {
        return res.status(400).json({ error: 'Missing required fields: assetId, borrowerId, borrowDate, and returnDate are required.' });
    }

    console.log('Creating request with data:', requestData); // log ข้อมูลที่รับเข้าม

    // เตรียมข้อมูลสำหรับการสร้างคำขอ
    const newRequest = {
        asset_id: requestData.assetId,
        borrower_id: requestData.borrowerId,
        borrow_date: requestData.borrowDate,
        return_date: requestData.returnDate,
        approve_status: 'pending', // ตั้งสถานะเริ่มต้นเป็น 'pending'
    };

    // เพิ่มข้อมูลคำขอลงในตาราง request
    Request.create(newRequest, (err, requestResults) => {
        if (err) {
            console.error('Error creating request:', err.message);
            return res.status(500).json({ error: 'Error creating request: ' + err.message });
        }

        console.log('Request created successfully, request ID:', requestResults.insertId);
        res.status(201).json({ success: true, message: 'Request created successfully', requestId: requestResults.insertId });
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
        console.log('Asset updated successfully with ID:', assetId); // log เมื่ออัปเดตสำเร็จ
        res.json({ success: true, message: 'Asset updated successfully' }); // เปลี่ยนแปลงใน response
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
        console.log('Asset disabled successfully with ID:', assetId); // log เมื่อปิดใช้งานสำเร็จ
        res.json({ success: true, message: 'Asset disabled successfully' }); // เปลี่ยนแปลงใน response
    });
};

exports.getAssets = (req, res) => {
    console.log('Fetching all assets...');
    Asset.getAll((err, results) => {
        if (err) {
            console.error('Error fetching assets:', err.message);
            return res.status(500).json({ error: 'Unable to fetch assets: ' + err.message });
        }
        console.log('Assets fetched successfully:', results);
        res.json({ success: true, data: results }); // เปลี่ยนแปลงใน response
    });
};
