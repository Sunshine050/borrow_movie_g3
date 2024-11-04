const db = require('../config/db');

const User = {
    findByUsername: (username, callback) => {
        db.query('SELECT * FROM users WHERE username = ?', [username], callback);
    },
    create: (data, callback) => {
        db.query('INSERT INTO users SET ?', data, callback);
    }
};

module.exports = User;
