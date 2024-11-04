exports.approveOrRejectRequest = async (req, res) => {
    const requestId = req.params.id;
    const { approve_status } = req.body; // ได้รับค่าจาก Body

    try {
        const result = await db.query('UPDATE request SET status = ? WHERE id = ?', [approve_status, requestId]);
        
        if (result.affectedRows > 0) {
            return res.status(200).json({ message: `Request ${approve_status}` });
        } else {
            return res.status(404).json({ message: 'Request not found' });
        }
    } catch (error) {
        console.error('Error updating request status:', error);
        return res.status(500).json({ message: 'Error updating request status' });
    }
};
