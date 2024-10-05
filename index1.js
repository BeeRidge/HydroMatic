const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');
const multer = require('multer');
const cors = require('cors');
const fs = require('fs');
const app = express();

// Set up storage with multer
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, 'img')); // Directory to save images
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname); // Use original file name
    }
});

const upload = multer({ storage });
app.use(express.json());
app.use(cors());

// Define the directory for serving static images
const imgDir = path.join(__dirname, 'img');
app.use('/img', express.static(imgDir));

// Async function to set up the server
async function startServer() {
    // Set up MySQL connection
    const db = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'lettucegrowth'
    });

    // Add this route in your backend
    app.get('/api/section-images/:section_id', async (req, res) => {
        const { section_id } = req.params;
    
        if (!section_id) {
            return res.status(400).send('Section ID is required');
        }
    
        try {
            const [results] = await db.query('SELECT * FROM page_images WHERE section_id = ?', [section_id]);
    
            if (results.length === 0) {
                return res.status(404).send('No images found for this section');
            }
    
            res.json(results);
        } catch (err) {
            console.error('Error fetching images for section:', err);
            res.status(500).send('Error fetching images for this section');
        }
    });
    
    

    // Serve admin content HTML file
    app.get('/admin-content', (req, res) => res.sendFile(path.join(__dirname, 'dist', 'admin-content.html')));

    // Endpoint to get admin content
    app.get('/api/admin-content', async (req, res) => {
        try {
            const [results] = await db.query('SELECT * FROM page_content');
            res.json(results);
        } catch (err) {
            console.error('Error fetching admin content:', err);
            res.status(500).send('Error fetching admin content');
        }
    });

    // Endpoint to update content
    app.put('/admin/content/:section_id', async (req, res) => {
        const { section_id } = req.params;
        const { content } = req.body;

        if (!section_id) {
            console.error('Section ID is undefined');
            return res.status(400).send('Section ID is required');
        }

        try {
            await db.query('UPDATE page_content SET content = ? WHERE section_id = ?', [content, section_id]);
            res.send('Content updated successfully.');
        } catch (err) {
            console.error('Error updating content:', err);
            res.status(500).send('Error updating content');
        }
    });

    // Endpoint to upload image (with replacement functionality)
    app.post('/api/upload-image', upload.single('image'), async (req, res) => {
        const { oldImageUrl } = req.body;
        if (!req.file) {
            return res.status(400).send('No file uploaded.');
        }

        const filename = req.file.filename;
        const fileUrl = `/img/${filename}`;

        try {
            // If oldImageUrl is provided, delete the old image file and update the DB
            if (oldImageUrl) {
                const oldImagePath = path.join(__dirname, 'img', path.basename(oldImageUrl));
                
                // Remove old image file if it exists
                if (fs.existsSync(oldImagePath)) {
                    fs.unlinkSync(oldImagePath);
                }

                // Update the old image entry in the database
                await db.query('UPDATE page_images SET filename = ?, url = ? WHERE url = ?', [filename, fileUrl, oldImageUrl]);

                return res.json({ imageUrl: fileUrl });
            } else {
                // Insert a new image into the database if no old image is provided
                const query = 'INSERT INTO page_images (filename, url) VALUES (?, ?)';
                await db.query(query, [filename, fileUrl]);
                res.json({ imageUrl: fileUrl });
            }
        } catch (err) {
            console.error('Error uploading or replacing image:', err);
            res.status(500).send('Failed to upload image');
        }
    });

    // Error handling middleware
    app.use((err, req, res, next) => {
        console.error(err.stack);
        res.status(500).send('Something broke!');
    });

    app.listen(3000, () => {
        console.log('Server started on http://localhost:3000');
    });
}

// Start the server
startServer().catch(err => {
    console.error('Failed to start server:', err);
});
