const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  port: '',
  user: 'root',
  password: '', 
  database: 'borrow_movie'
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to the database group3 borrow_movie');
});

module.exports = connection;
