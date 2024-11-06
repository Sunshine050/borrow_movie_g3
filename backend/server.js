const express = require('express');
const db = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const assetRoutes = require('./routes/assetRoutes');
const borrowRoutes = require('./routes/borrowRoutes');
require('dotenv').config(); // เพิ่มบรรทัดนี้ที่ด้านบนของไฟล์


const app = express();
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/assets', assetRoutes);
app.use('/api/borrow', borrowRoutes); 

app.listen(4000, () => {
  console.log('Server is running on port 4000');
});