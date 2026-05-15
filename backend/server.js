const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306'),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'password',
    database: process.env.DB_NAME || 'webapp',
};

let pool;

async function initDB() {
    try {
      pool = mysql.createPool(dbConfig);
      await pool.query(`
        CREATE TABLE IF NOT EXISTS messages (
          id INT AUTO_INCREMENT PRIMARY KEY,
          content VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `);
      console.log('Database connected and table ready');
    } catch (err) {
      console.error('DB connection failed, retrying in 5s:', err.message);
      setTimeout(initDB, 5000);
    }
  }
initDB();

app.get('/api/health', (req, res) => {
    res.json({ status: 'healthy', pod: process.env.HOSTNAME });
});

app.get('/api/messages', async (req, res) => {
    try {
      const [rows] = await pool.query('SELECT * FROM messages ORDER BY created_at DESC LIMIT 20');
      res.json(rows);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
});

app.post('/api/messages', async (req, res) => {
    try {
      const { content } = req.body;
      const [result] = await pool.query('INSERT INTO messages (content) VALUES (?)', [content]);
      res.status(201).json({ id: result.insertId, content });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
