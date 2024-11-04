const db = require('../config/db'); // เชื่อมต่อกับฐานข้อมูล

const Asset = {
    getAll: (callback) => {
        db.query('SELECT * FROM asset', callback);
    },

    create: (data, callback) => {
        db.query('INSERT INTO asset (asset_name, asset_status, file_path, categorie) VALUES (?, ?, ?, ?)', 
        [data.asset_name, data.asset_status, data.file_path, data.categorie], callback);
    },

    update: (assetId, data, callback) => {
        db.query('UPDATE asset SET asset_name = ?, asset_status = ?, file_path = ?, categorie = ? WHERE asset_id = ?', 
        [data.asset_name, data.asset_status, data.file_path, data.categorie, assetId], callback);
    },

    disable: (assetId, callback) => {
        db.query('UPDATE asset SET asset_status = "disabled" WHERE asset_id = ?', [assetId], callback);
    }
};

module.exports = Asset;
