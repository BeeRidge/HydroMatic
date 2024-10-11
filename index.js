const express = require("express");
const path = require("path");
const mysql = require("mysql2/promise");
const bodyParser = require("body-parser");
require("dotenv").config();
const axios = require("axios");
const multer = require('multer');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const app = express();
const PORT = process.env.PORT || 3000;

// Configure multer for file upload with original filename preservation
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, 'img')); // Folder to save the uploaded files
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, file.originalname); // Use original filename
  }
});

const upload = multer({ storage });

// Create a connection to the database
const db = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "lettucegrowth",
});

// Test the database connection
const testConnection = async () => {
  try {
    const connection = await db.getConnection();
    console.log("Connected to the database");
    connection.release(); // Release the connection back to the pool
  } catch (err) {
    console.error("Error connecting to the database:", err.stack);
  }
};
testConnection();

// Middleware for parsing JSON
app.use(bodyParser.json());

// Serve static files from the "dist" and "img" directories
app.use("/dist", express.static(path.join(__dirname, "dist")));
app.use("/img", express.static(path.join(__dirname, "img")));

// Semaphore API Key
const SEMAPHORE_API_KEY = "9211423d3b8b372cac30d1357da0729f";

// Store OTPs temporarily (In production, use a database or a cache like Redis)
const otpStorage = {};

// Generate a random OTP
const generateOtp = () => Math.floor(100000 + Math.random() * 900000);

// API to send OTP
app.post("/api/send-otp", async (req, res) => {
  const { phone } = req.body;
  delete otpStorage[phone]; // Clear OTP after successful verification

  if (!phone) {
    return res.status(400).json({ error: "Phone number is required" });
  }

  const otp = generateOtp();
  otpStorage[phone] = otp; // Store OTP temporarily for verification later

  try {
    const response = await axios.post(
      "https://api.semaphore.co/api/v4/messages",
      {
        apikey: SEMAPHORE_API_KEY,
        number: phone,
        message: `Your OTP code is: ${otp}. Please use this code to complete your registration. If you did not request this code, please ignore this message.`,
        sendername: "HydroMatic", // Replace with your actual brand name
      }
    );

    res.status(200).json({ success: true, message: "OTP sent successfully" });
  } catch (error) {
    console.error(
      "Error sending OTP:",
      error.response ? error.response.data : error.message
    );
    res.status(500).json({ error: "Failed to send OTP" });
  }
});
// API to verify OTP and create an account if OTP is valid
app.post("/api/verify-otp", async (req, res) => {
  const { phone, otp, password } = req.body;

  if (!phone || !otp || !password) {
    return res.status(400).json({ error: "Phone number, Password, and OTP are required" });
  }

  if (otpStorage[phone] && otpStorage[phone] == otp) {
    delete otpStorage[phone]; // Clear OTP after successful verification

    try {
      const [results] = await db.query('SELECT * FROM account WHERE Acc_Pnumber = ? AND Acc_Password = ?', [phone, password]);

      if (results.length === 0) {
        // User doesn't exist, insert into database
        const [insertResults] = await db.query("INSERT INTO account (Acc_Pnumber, Acc_Password, Acc_OTP) VALUES (?, ?, ?)", [phone, password, otp]);
        res.status(200).json({ success: true, message: "Account created successfully!" });
      } else {
        res.status(400).json({ error: "You've already created an account." });
      }
    } catch (err) {
      console.error("Error processing request:", err);
      res.status(500).json({ error: "Error processing request" });
    }
  } else {
    res.status(400).json({ error: "Invalid OTP" });
  }
});
// Login API
app.post('/api/login', async (req, res) => {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ error: 'Phone number and password are required' });
  }

  try {
    const [results] = await db.query('SELECT * FROM account WHERE Acc_Pnumber = ? AND Acc_Password = ?', [phone, password]);

    if (results.length === 0) {
      return res.status(401).json({ error: 'Invalid phone number or password' });
    }

    res.status(200).json({ success: true, message: 'Login successful', user: results[0] });
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});
// Data for displaying the image and description of growth
app.get("/api/growthtimeline", async (req, res) => {
  try {
    const [results] = await db.query("SELECT * FROM growthtimeline");
    res.json(results);
  } catch (err) {
    console.error("Error fetching:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Get all the data from table device_info
app.get("/api/device_info", async (req, res) => {
  try {
    const [results] = await db.query('SHOW TABLES LIKE "device_info"');
    if (results.length === 0) {
      return res.status(404).json({ error: "Table device_info not found" });
    }
    const [data] = await db.query("SELECT * FROM device_info");
    res.json(data);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Get all the data from table display_bed
app.get("/api/display_bed", async (req, res) => {
  try {
    const [results] = await db.query('SHOW TABLES LIKE "display_bed"');
    if (results.length === 0) {
      return res.status(404).json({ error: "Table display_bed not found" });
    }
    const [data] = await db.query("SELECT * FROM display_bed");
    res.json(data);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Get specific the data from table display_bed
app.post("/api/display_table", async (req, res) => {
  const { Var_Host, Var_Ip } = req.body;

  if (!Var_Host || !Var_Ip) {
    return res.status(400).json({ error: "Missing Var_Host or Var_Ip" });
  }

  try {
    const [results] = await db.query('SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?', [Var_Host, Var_Ip]);
    if (results.length === 0) {
      return res.status(404).json({ error: "No data found for the given Var_Host and Var_Ip" });
    }
    res.json(results);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Get the data from specific table Limit to 1
app.post("/api/send-Data", async (req, res) => {
  const { Var_Host, Var_Ip } = req.body;

  try {
    const [results] = await db.query("SHOW TABLES LIKE ?", [Var_Host]);
    if (results.length === 0) {
      return res.status(404).json({ error: "Table not found" });
    }

    const [data] = await db.query("SELECT * FROM ?? WHERE Var_Ip = ? ORDER BY Num_Id DESC LIMIT 1", [Var_Host, Var_Ip]);
    res.json(data);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Displaying data logs on the table
app.post("/api/DataLogs", async (req, res) => {
  const { Var_Host, Var_Ip, Start_Date } = req.body;

  console.log("Request body:", { Var_Host, Var_Ip, Start_Date });

  try {
    const [tables] = await db.query("SHOW TABLES LIKE ?", [Var_Host]);
    if (tables.length === 0) {
      return res.status(404).json({ error: "Table not found" });
    }

    const [results] = await db.query(
      "SELECT * FROM ?? WHERE Var_Ip = ? AND Date_Dev >= ? ORDER BY Num_Id DESC",
      [Var_Host, Var_Ip, Start_Date]
    );

    console.log("Data fetched from database:", results);
    res.json(results);
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// API to check device if inactive and active
app.post('/api/checkDevice', async (req, res) => {
  try {
    // Get all devices from the device_info table
    const selectDevices = "SELECT * FROM device_info";
    const [devices] = await db.query(selectDevices);

    if (devices.length === 0) {
      return res.status(404).json({ error: "No devices found" });
    }

    // Loop through all devices and check their respective table for date/time comparison
    for (const device of devices) {
      const { Var_Host, Var_Ip } = device;

      // Check if the table for the device exists
      const [tables] = await db.query("SHOW TABLES LIKE ?", [Var_Host]);
      if (tables.length === 0) {
        // Update the device status to REPAIR if its table doesn't exist
        await db.query("UPDATE device_info SET Status = 'REPAIR' WHERE Var_Host = ? AND Var_Ip = ?", [Var_Host, Var_Ip]);
        continue; // Skip to the next device
      }

      // Get the latest record from the device-specific table
      const [deviceData] = await db.query("SELECT * FROM ?? WHERE Var_Ip = ? ORDER BY Date_Dev DESC, Time_Dev DESC LIMIT 1", [Var_Host, Var_Ip]);

      if (deviceData.length === 0) {
        continue; // Skip this device if no records are found
      }

      const currentDate = convertToManilaTime(new Date().toISOString());
      const latestDeviceDate = convertToManilaTime(deviceData[0].Date_Dev);
      const latestDeviceTime = formatTime(deviceData[0].Time_Dev); // Format to HH:MM
      const currentTime = getManilaTime(); // Format to HH:MM

      // Compare the date and time
      if (latestDeviceDate !== currentDate || latestDeviceTime !== currentTime) {
        // If date/time mismatch, update the device_info status to INACTIVE
        await db.query("UPDATE device_info SET Status = 'INACTIVE' WHERE Var_Host = ? AND Var_Ip = ?", [Var_Host, Var_Ip]);
      } else {
        await db.query("UPDATE device_info SET Status = 'ACTIVE' WHERE Var_Host = ? AND Var_Ip = ?", [Var_Host, Var_Ip]);
      }
    }

    // If all checks are successful
    res.status(200).json({ message: "Device statuses updated successfully" });

  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: 'Database query error' });
  }
});
// Creating bed display
app.post("/api/add-bed-database", async (req, res) => {
  console.log("Request received for /api/add-bed-database");

  const { Var_Host, Var_Ip, Last_Day, Start_Date } = req.body;

  // Validate incoming data
  if (!Var_Host || !Var_Ip || !Last_Day || !Start_Date) {
    console.error("Missing required fields");
    return res.status(400).json({ error: "Missing required fields" });
  }

  // Convert Start_Date to a JavaScript Date object
  const startDate = new Date(Start_Date);

  // Check if Start_Date is valid
  if (isNaN(startDate.getTime())) {
    console.error("Invalid Start_Date format");
    return res.status(400).json({ error: "Invalid Start_Date format" });
  }

  // Calculate Harvest_Date by adding (70 - Last_Day) days to Start_Date
  const harvestDate = new Date(startDate);
  harvestDate.setDate(harvestDate.getDate() + (70 - Last_Day));

  // Format the Harvest_Date in YYYY-MM-DD format
  const Harvest_Date = harvestDate.toISOString().split("T")[0];

  try {
    // Check if the device already exists in display_bed
    const [results] = await db.query("SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?", [Var_Host, Var_Ip]);

    if (results.length > 0) {
      // Device already exists
      console.error("Device with the same hostname or IP already exists");
      return res.status(409).json({ error: "Device with the same hostname or IP already exists" });
    }

    // Insert new bed
    await db.query(
      `INSERT INTO display_bed (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Status) VALUES (?, ?, ?, ?, ?, ?, "ONGOING")`,
      [Var_Host, Var_Ip, Last_Day, Last_Day, Start_Date, Harvest_Date]
    );

    console.log("Bed inserted successfully!");
    return res.status(200).json({ message: "Bed inserted successfully!" });
  } catch (err) {
    console.error("Error:", err);
    return res.status(500).json({ error: "Error inserting data into database" });
  }
});
// POST endpoint to remove a bed
app.post("/api/delete-device", async (req, res) => {
  const { Var_Host } = req.body;

  if (!Var_Host) {
    return res.status(400).json({ message: "No hostname provided." });
  }

  try {
    // SQL query to select the record to be deleted
    const [results] = await db.query("SELECT * FROM display_bed WHERE Var_Host = ?", [Var_Host]);

    if (results.length === 0) {
      return res.status(404).json({ message: "Bed not found." });
    }

    // Get the record details
    const { Var_Host: name, Var_Ip: ip, Start_Day: sDay, Last_Day: lDay, Start_Date: sDate, Harvest_Date: hDate } = results[0];

    // SQL query to delete the record
    const [deleteResult] = await db.query("DELETE FROM display_bed WHERE Var_Host = ?", [Var_Host]);

    if (deleteResult.affectedRows === 0) {
      return res.status(404).json({ message: "Bed not found." });
    }

    // Determine status
    const stat = lDay < 70 ? "REMOVED" : "FINISHED";

    // Insert into archived
    await db.query(
      `INSERT INTO archived (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Date_Archived, Status) 
      VALUES (?, ?, ?, ?, ?, ?, CURDATE(), ?)`,
      [name, ip, sDay, lDay, sDate, hDate, stat]
    );

    console.log("Insert Successful to archived");
    res.status(200).json({ message: "Bed successfully deleted." });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ message: "Failed to delete the bed from the database." });
  }
});
// Endpoint to update the Last_Day and Last_Update_Date
app.post("/api/update-last-day", async (req, res) => {
  const { Var_Host, Var_Ip, Start_Day, Start_Date, currentDate } = req.body;

  try {
    // SQL query to select Last_Day from the database
    const [results] = await db.query('SELECT Last_Day FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?', [Var_Host, Var_Ip]);

    if (results.length === 0) {
      return res.status(404).json({ message: "Bed not found" });
    }

    const lastDay = results[0].Last_Day;

    if (lastDay <= 70) {
      // SQL query to update the Last_Day and Update_Date using DATEDIFF
      await db.query(
        `UPDATE display_bed
        SET Last_Day = DATEDIFF(?, ?) + ? - 1, Update_Date = ?
        WHERE Var_Host = ? AND Var_Ip = ?`,
        [currentDate, Start_Date, Start_Day, currentDate, Var_Host, Var_Ip]
      );

      res.status(200).json({ message: "Update successful" });
    } else {
      res.status(400).json({ message: "Last_Day exceeds 70" });
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Database error" });
  }
});
// API for Dates
app.post("/api/dates", async (req, res) => {
  console.log("Request body:", req.body);
  const { Var_Host, Var_Ip } = req.body;

  try {
    const [results] = await db.query("SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?", [Var_Host, Var_Ip]);
    console.log("Fetched results:", results);
    res.json(results);
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// API route for growth stages
app.get("/api/growth-stages", async (req, res) => {
  try {
    const [results] = await db.query("SELECT * FROM growthtimeline");

    // Transform the database rows into the desired format
    const growthStages = results.map((row) => ({
      phase_name: row.phase_name,
      description: row.description,
      start_day: row.start_day,
      end_day: row.end_day,
    }));

    res.json(growthStages);
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Error fetching growth stages" });
  }
});
// API notify
app.post('/api/notify-harvest', async (req, res) => {
  try {
    const { phone } = req.body;

    // Query to find crops that have Last_Day between 60 and 70 and have not received an SMS today
    const query = `
      SELECT * FROM display_bed 
      WHERE Last_Day >= 60 AND Last_Day <= 70 
        AND (Last_SMS_Date IS NULL OR Last_SMS_Date < CURDATE())
    `;

    const [crops] = await db.query(query);

    // Log the result to check if crops are found
    console.log('Crops found with Last_Day between 60 and 70:', crops);

    if (crops.length === 0) {
      return res.status(200).json({ message: 'No crops ready for harvest within the specified range or it already sent an SMS notification' });
    }

    // Loop through each crop and send SMS
    try {
      for (const crop of crops) {
        const cropName = crop.Var_Host; // Replace with actual crop name column if needed
        const lastDay = crop.Last_Day;  // Last_Day from database
        const harvestDate = new Date(crop.Harvest_Date); // Harvest date

        // Format harvestDate to "Thu Sep 26 2024"
        const formattedHarvestDate = harvestDate.toDateString();

        // Create SMS message for crops ready to harvest based on Last_Day
        const message = `Dear Farmer, your crop from "${cropName}" is ready to harvest. It has been growing for ${lastDay} days. Please harvest the crops until ${formattedHarvestDate}.`;

        // Log SMS details for debugging
        console.log('Sending SMS to:', phone);
        console.log('Message:', message);

        // Send SMS using Semaphore API
        await axios.post('https://api.semaphore.co/api/v4/messages', {
          apikey: SEMAPHORE_API_KEY,
          number: phone,
          message: message,
          sendername: "HydroMatic", // Replace with your actual sender name
        }).catch(smsError => {
          console.error('Error sending SMS:', smsError);
          throw smsError; // Throw error to handle it outside the loop
        });

        // Update the date of the last SMS sent
        const updateQuery = 'UPDATE display_bed SET Last_SMS_Date = CURDATE(), Status = "HARVEST"  WHERE Var_Host = ? AND Var_Ip = ?';
        await db.query(updateQuery, [crop.Var_Host, crop.Var_Ip]);
      }

      // After sending all SMS, send a success response
      res.status(200).json({ message: 'SMS notifications sent successfully' });
    } catch (smsError) {
      console.error('Error sending SMS notifications:', smsError);
      res.status(500).json({ message: 'Error sending SMS notifications' });
    }
  } catch (error) {
    console.error('Error in /api/notify-harvest:', error);
    res.status(500).json({ message: 'Error processing request' });
  }
});
// API to fetch all archived data
app.get('/api/archived', async (req, res) => {
  try {
    const selectArchived = "SELECT * FROM archived ORDER BY Archive_Id DESC";
    const [results] = await db.query(selectArchived);
    res.json(results); // Send the results as JSON
  } catch (err) {
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to fetch all archived data
app.get('/api/Dashboard-Data', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM display_bed ORDER BY Var_Host ASC";
    const [results] = await db.query(selectAll);
    res.json(results); // Send the results as JSON
  } catch (err) {
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to get the total bed frames
app.get('/api/TotalBed', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM display_bed";

    // Execute the query
    const [results] = await db.query(selectAll);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).send({ error: 'Database query error' });
  }
});
// API Update accounts
app.post('/api/account', async (req, res) => {
  try {
    console.log("Request body:", req.body);
    const { Acc_Pnumber, Acc_Password, old_Pnum, old_Pass } = req.body;

    // Validate input
    if (!Acc_Pnumber || !Acc_Password || !old_Pnum || !old_Pass) {
      return res.status(400).send({ error: 'All fields are required.' });
    }

    // SQL query to check if the new phone number already exists
    const checkPhoneNumberQuery = `SELECT * FROM account WHERE Acc_Pnumber = ?`;
    const [phoneResults] = await db.query(checkPhoneNumberQuery, [Acc_Pnumber]);

    if (phoneResults.length > 0) {
      // If the phone number already exists, send an error response
      return res.status(409).send({ error: 'Phone number already exists.' });
    }

    // SQL query to update account where old phone number and old password match
    const updateAccountQuery = `
      UPDATE account 
      SET Acc_Pnumber = ?, Acc_Password = ? 
      WHERE Acc_Pnumber = ? AND Acc_Password = ?
    `;
    const [updateResult] = await db.query(updateAccountQuery, [Acc_Pnumber, Acc_Password, old_Pnum, old_Pass]);

    if (updateResult.affectedRows === 0) {
      // If no rows were updated, it means the old phone number and password didn't match any record
      return res.status(404).send({ error: 'Old account information is incorrect.' });
    }

    // Send a success response
    res.send({ message: 'Account information updated successfully.' });
  } catch (err) {
    console.error('Error updating account:', err);
    res.status(500).send({ error: 'Error updating account information.' });
  }
});
// API edit device name
app.post('/api/edit-name', async (req, res) => {
  try {
    console.log("Request body:", req.body);
    const { newName, oldName } = req.body;

    if (!newName || !oldName) {
      return res.status(400).json({ error: "Both newName and oldName are required" });
    }

    // Check if a table with the new name already exists
    const checkNewNameQuery = 'SHOW TABLES LIKE ?';
    const [newNameResults] = await db.query(checkNewNameQuery, [newName]);

    if (newNameResults.length > 0) {
      return res.status(409).json({ error: "A table with the new name already exists" }); // Conflict error
    }

    // Check if the old table exists
    const checkOldNameQuery = 'SHOW TABLES LIKE ?';
    const [oldNameResults] = await db.query(checkOldNameQuery, [oldName]);

    if (oldNameResults.length === 0) {
      return res.status(404).json({ error: "Old table not found" });
    }

    // Check if the old table exists
    const checkOldBedQuery = 'SELECT * FROM display_bed WHERE Var_Host = ?';
    const [oldBedResults] = await db.query(checkOldBedQuery, [oldName]);

    if (oldBedResults.length === 0) {
      return res.status(404).json({ error: "No 'BED' with same device info found" });
    }

    // Check if a record with newName already exists in device_info
    const checkDeviceInfoQuery = 'SELECT * FROM device_info WHERE Var_Host = ?';
    const [deviceInfoResults] = await db.query(checkDeviceInfoQuery, [newName]);

    if (deviceInfoResults.length > 0) {
      return res.status(409).json({ error: "A device with the new name already exists in device_info" }); // Conflict error
    }

    // Rename the table
    const renameTableQuery = `RENAME TABLE \`${oldName}\` TO \`${newName}\``;
    await db.query(renameTableQuery);

    // Update Var_Host in device_info
    const updateDeviceInfoQuery = 'UPDATE device_info SET Var_Host = ? WHERE Var_Host = ?';
    await db.query(updateDeviceInfoQuery, [newName, oldName]);

    const updateDisplayBedQuery = 'UPDATE display_bed SET Var_Host = ? WHERE Var_Host = ?';
    await db.query(updateDisplayBedQuery, [newName, oldName]);

    console.log("Update successfully");
    res.status(200).json({ message: "Device name updated successfully" });
  } catch (err) {
    console.error("Error updating device name:", err);
    res.status(500).json({ error: "Error updating device name" });
  }
});
// API to edit device IP address
app.post('/api/edit-ip', async (req, res) => {
  try {
    console.log("Request body:", req.body);
    const { newip, oldip, hostname } = req.body;

    if (!newip || !oldip || !hostname) {
      return res.status(400).json({ error: "All data fields are required" });
    }

    const connection = await db.getConnection();

    try {
      // Check if the old IP exists in the hostname's table
      const [oldIpResults] = await connection.query(`SELECT * FROM \`${hostname}\` WHERE Var_Ip = ?`, [oldip]);

      if (oldIpResults.length === 0) {
        return res.status(404).json({ error: "Old IP not found in the specified table" });
      }

      // Check if the new IP already exists in the hostname's table
      const [newIpResults] = await connection.query(`SELECT * FROM \`${hostname}\` WHERE Var_Ip = ?`, [newip]);

      if (newIpResults.length > 0) {
        return res.status(409).json({ error: "New IP already exists in the specified table" });
      }

      // Check if the new IP exists in `device_info`
      const [deviceInfoResults] = await connection.query('SELECT * FROM device_info WHERE Var_Ip = ?', [newip]);

      if (deviceInfoResults.length > 0) {
        return res.status(409).json({ error: "New IP already exists in device_info" });
      }

      // Check if the old IP exists in `display_bed`
      const [oldBedIpResults] = await connection.query('SELECT * FROM display_bed WHERE Var_Ip = ?', [oldip]);

      if (oldBedIpResults.length === 0) {
        return res.status(404).json({ error: "Old IP not found in display_bed" });
      }

      // Check if the new IP exists in `display_bed`
      const [newBedIpResults] = await connection.query('SELECT * FROM display_bed WHERE Var_Ip = ?', [newip]);

      if (newBedIpResults.length > 0) {
        return res.status(409).json({ error: "New IP already exists in display_bed" });
      }

      // Update IP in all tables
      await connection.query(`UPDATE \`${hostname}\` SET Var_Ip = ? WHERE Var_Ip = ?`, [newip, oldip]);
      await connection.query('UPDATE device_info SET Var_Ip = ? WHERE Var_Ip = ?', [newip, oldip]);
      await connection.query('UPDATE display_bed SET Var_Ip = ? WHERE Var_Ip = ?', [newip, oldip]);

      console.log("IP update successful across all tables");
      return res.status(200).json({ message: "IP address updated successfully" });
    } finally {
      connection.release(); // Release the connection back to the pool
    }
  } catch (err) {
    console.error("Error processing request:", err);
    return res.status(500).json({ error: "Server error" });
  }
});
// API update bed
app.post('/api/update-bed', async (req, res) => {
  try {
    const { Var_Host, Var_Ip, Last_Day, Start_Date } = req.body;

    console.log('Request body:', { Var_Host, Var_Ip, Last_Day, Start_Date });

    if (!Var_Host || !Var_Ip || !Last_Day || !Start_Date) {
      return res.status(400).json({ error: 'All fields (Var_Host, Var_Ip, Last_Day, Start_Date) are required.' });
    }

    const [result] = await db.query(`
      UPDATE display_bed
      SET Start_Day = ?, Start_Date = ?
      WHERE Var_Host = ? AND Var_Ip = ?
    `, [Last_Day, Start_Date, Var_Host, Var_Ip]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'No bed found with the specified Host and IP.' });
    }

    res.json({ message: 'Bed information updated successfully.' });
  } catch (err) {
    console.error('Error updating bed information:', err);
    return res.status(500).json({ error: 'Error updating bed information.' });
  }
});
// API removing from archive
app.post('/api/remove', async (req, res) => {
  try {
    console.log("Request body:", req.body);
    const { id, varHost, varIp, date } = req.body;

    if (!id || !varHost || !varIp || !date) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const dateParts = date.split('-');
    if (dateParts.length !== 3) {
      return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
    }

    const formattedDate = `${dateParts[2]}-${dateParts[0]}-${dateParts[1]}`;
    if (!/^\d{4}-\d{2}-\d{2}$/.test(formattedDate)) {
      return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
    }

    const [result] = await db.query(`
      DELETE FROM archived 
      WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?
    `, [id, varHost, varIp, formattedDate]);

    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Record removed successfully' });
    } else {
      res.status(404).json({ error: 'Record not found' });
    }
  } catch (error) {
    console.error('Error executing query:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});
// API recover from archive
app.post('/api/recover', async (req, res) => {
  try {
    console.log("Request body:", req.body);
    const { id, varHost, varIp, date } = req.body;

    if (!id || !varHost || !varIp || !date) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const dateParts = date.split('-');
    if (dateParts.length !== 3) {
      return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
    }

    const formattedDate = `${dateParts[2]}-${dateParts[0]}-${dateParts[1]}`;
    if (!/^\d{4}-\d{2}-\d{2}$/.test(formattedDate)) {
      return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
    }

    const [checkResult] = await db.query("SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?", [varHost, varIp]);

    if (checkResult.length === 0) {
      const [archivedResult] = await db.query("SELECT * FROM archived WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?", [id, varHost, varIp, formattedDate]);

      if (archivedResult.length === 1) {
        const resultData = archivedResult[0];
        const lday = resultData.Last_Day;
        let status;
        if (lday >= 60) {
          status = "HARVEST";
        } else {
          status = "ONGOING";
        }

        await db.query("INSERT INTO display_bed (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Status) VALUES (?, ?, ?, ?, ?, ?, ?)", [resultData.Var_Host, resultData.Var_Ip, resultData.Start_Day, resultData.Last_Day, resultData.Start_Date, resultData.Harvest_Date, status]);

        const [deleteResult] = await db.query("DELETE FROM archived WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?", [id, varHost, varIp, formattedDate]);

        if (deleteResult.affectedRows > 0) {
          res.status(200).json({ message: 'Record recovered and inserted successfully' });
        } else {
          res.status(404).json({ error: 'Record not found for deletion' });
        }
      } else {
        res.status(404).json({ error: 'Record not found in archived' });
      }
    } else {
      res.status(400).json({ error: 'Record already exists in display_bed' });
    }
  } catch (error) {
    console.error('Error executing query:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});
// API Notify user when there's a problem
app.post("/api/notify-anomaly", async (req, res) => {
  const { Var_Host, Var_Ip, Start_Date, phone } = req.body;

  if (!Var_Host || !Var_Ip || !Start_Date || !phone) {
    return res.status(400).json({ error: "All fields are required" });
  }

  try {
    // Convert current date to YYYY-MM-DD format in Manila time (GMT+8)
    const currentDate = convertToManilaTime(new Date().toISOString());

    const connection = await db.getConnection();

    try {
      // SQL query to select Last_Day from the database
      const [rows] = await connection.query(
        'SELECT Last_Day FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?',
        [Var_Host, Var_Ip]
      );

      if (rows.length > 0) {
        const lastDay = rows[0].Last_Day;

        // Check if Last_Day is less than or equal to 60
        if (lastDay < 60) {
          const [tableCheck] = await connection.query(
            'SHOW TABLES LIKE ?',
            [Var_Host]
          );

          if (tableCheck.length === 0) {
            return res.status(404).json({ error: "Table not found" });
          }

          const [results] = await connection.query(
            'SELECT * FROM ?? WHERE Var_Ip = ? AND Date_Dev >= ? ORDER BY Num_Id DESC',
            [Var_Host, Var_Ip, Start_Date]
          );

          if (results.length > 0) {
            const resultData = results[0];

            // Convert resultData.Date_Dev to Manila time (GMT+8)
            const resultDateDev = convertToManilaTime(resultData.Date_Dev);
            const resultTimeDev = formatTime(resultData.Time_Dev); // Format to HH:MM
            const currentManilaTime = getManilaTime(); // Format to HH:MM

            console.log('Var_Host:', Var_Host, 'Var_Ip:', Var_Ip, 'Start_Date:', Start_Date, 'phone:', phone);
            console.log('Current Date:', currentDate);
            console.log('DateDev Date:', resultDateDev);
            console.log('Raw Time_Dev:', resultData.Time_Dev);
            console.log('Formatted TimeDev Date:', resultTimeDev);
            console.log('Formatted Current Manila Time:', currentManilaTime);
            console.log('Last Day:', lastDay);

            // Check if Var_Temp is present and dates match
            if (resultData.Var_Temp !== undefined && (resultData.Var_Temp < 20 || resultData.Var_Temp > 26) && currentDate === resultDateDev && currentManilaTime === resultTimeDev) {
              const cropName = Var_Host;

              // Create SMS message for crops experiencing a temperature issue
              const message = `Caution! Your crop from "${cropName}" is experiencing a temperature issue. Please check your crop. The water temperature cannot be less than 21°C or more than 25°C. Date:${currentDate} Time:${resultTimeDev}`;

              // Log SMS details for debugging
              console.log('Sending SMS to:', phone);
              console.log('Message:', message);

              // Send SMS using Semaphore API
              await axios.post('https://api.semaphore.co/api/v4/messages', {
                apikey: SEMAPHORE_API_KEY, // Use environment variable for API key
                number: phone,
                message: message,
                sendername: "HydroMatic",
              }).catch(smsError => {
                console.error('Error sending SMS:', smsError);
              });
            }

            // Check if Var_WLvl is present and dates match
            if (resultData.Var_WLvl !== undefined && resultData.Var_WLvl === 'LOW' && currentDate === resultDateDev && currentManilaTime === resultTimeDev) {
              const cropName = Var_Host;

              // Create SMS message for crops with low water level
              const message = `Caution! Please inspect your crop since the water level from your "${cropName}" is lower than usual. Date:${currentDate} Time:${resultTimeDev}`;

              // Log SMS details for debugging
              console.log('Sending SMS to:', phone);
              console.log('Message:', message);

              // Send SMS using Semaphore API
              await axios.post('https://api.semaphore.co/api/v4/messages', {
                apikey: SEMAPHORE_API_KEY, // Use environment variable for API key
                number: phone,
                message: message,
                sendername: "HydroMatic",
              }).catch(smsError => {
                console.error('Error sending SMS:', smsError);
              });
            }
          } else {
            console.error("No data found for the query:", selectQuery);
            return res.status(404).json({ message: "No data found for the given criteria" });
          }
        } else {
          return res.status(404).json({ message: "Last_Day exceeds 60" });
        }
      } else {
        return res.status(404).json({ message: "Bed not found" });
      }
    } finally {
      connection.release(); // Release the connection back to the pool
    }
  } catch (err) {
    console.error('Error processing request:', err);
    return res.status(500).json({ error: "Server error" });
  }
});
// Fetch all admin content
app.get('/api/admin-content', async (req, res) => {
  try {
    const [results] = await db.query('SELECT * FROM page_content ORDER BY section_id ASC');
    res.json(results);
  } catch (err) {
    console.error('Error fetching admin content:', err);
    res.status(500).send('Error fetching admin content');
  }
});
// Update admin content for a specific section
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
// Fetch images for a specific section
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
// API to handle image upload
app.post('/api/upload-image', upload.single('image'), async (req, res) => {
  const { oldImageUrl } = req.body;
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }

  const filename = req.file.originalname; // Use original filename
  const fileUrl = `/img/${filename}`;

  try {
    if (oldImageUrl) {
      const oldImagePath = path.join(__dirname, 'img', path.basename(oldImageUrl));

      // Remove the old image file if it exists
      if (fs.existsSync(oldImagePath)) {
        fs.unlinkSync(oldImagePath);
      }

      // Update the old image entry in the database
      await db.query('UPDATE page_images SET filename = ?, url = ? WHERE url = ?', [filename, fileUrl, oldImageUrl]);

      return res.json({ imageUrl: fileUrl });
    } else {
      // Insert a new image into the database
      const query = 'INSERT INTO page_images (filename, url) VALUES (?, ?)';
      await db.query(query, [filename, fileUrl]);
      res.json({ imageUrl: fileUrl });
    }
  } catch (err) {
    console.error('Error uploading or replacing image:', err);
    res.status(500).send('Failed to upload image');
  }
});
// Function to Log in admin
const adminEmail = 'admin@gmail.com';
const adminPassword = 'password123';

// Set up JWT secret key
const secretKey = 'pablo12';
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.post('/admin-login', (req, res) => {
  const { email, password } = req.body;

  // Check if the provided email and password are correct
  if (email === adminEmail && password === adminPassword) {
    // Generate JWT token
    const token = jwt.sign({ email: adminEmail }, secretKey, { expiresIn: '1h' });

    // Send the token back to the client
    res.json({ token });
  } else {
    // Return error if credentials are wrong
    res.status(401).json({ error: 'Invalid email or password' });
  }
});
// Handle admin-login.html
app.get("/admin-login", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-login.html"));
});
// Handle index.html
app.get("/index", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});
// Handle dashboard.html
app.get("/dashboard", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "dashboard.html"));
});
// Handle settings.html
app.get("/settings", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "settings.html"));
});
// Handle archive.html
app.get("/archive", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "archive.html"));
});
// Handle login.html
app.get("/login", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "login.html"));
});
// Handle tables.html
app.get("/tables", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "tables.html"));
});
// Serve admin content HTML file
app.get("/admin-content", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-content.html"));
});
// Handle admin-content1.html
app.get("/admin-content1", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-content1.html"));
});
// Handle admin-main.html
app.get("/admin-main", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-main.html"));
});
// Serve the home page
app.get("/", (req, res) => {
  console.log("Serving landing.html");
  res.sendFile(path.join(__dirname, "dist", "landing.html"), (err) => {
    if (err) {
      console.error("Error serving landing.html:", err);
      res.status(500).send("Internal Server Error");
    }
  });
});
// Handle 404 errors
app.use((req, res) => {
  res.status(404).send("404 Not Found");
});
// Handle PORT serve
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


// Utility function to convert database date to Manila time (GMT+8)
function convertToManilaTime(dateString) {
  const date = new Date(dateString);

  // Get the time in milliseconds and add 8 hours (8 * 60 * 60 * 1000 milliseconds)
  const manilaTime = new Date(date.getTime() + (8 * 60 * 60 * 1000));

  // Return only the date part in YYYY-MM-DD format
  return manilaTime.toISOString().split('T')[0];
}


function formatTime(timeInput) {
  // If timeInput is already in HH:MM format, return it as is
  if (typeof timeInput === 'string' && /^[0-2][0-3]:[0-5][0-9]$/.test(timeInput)) {
    return timeInput; // Return the time in HH:MM format
  }

  // Handle if timeInput is a string in HH:mm:ss format
  if (typeof timeInput === 'string' && /^([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/.test(timeInput)) {
    return timeInput.substring(0, 5); // Return only the HH:MM part
  }

  // Handle if timeInput is a Date object or timestamp
  const date = new Date(timeInput);
  if (isNaN(date)) {
    console.error('Invalid date:', timeInput); // Log invalid date
    return '00:00'; // Return a default value or handle as necessary
  }

  const hours = String(date.getHours()).padStart(2, '0'); // Get hours and pad with zero
  const minutes = String(date.getMinutes()).padStart(2, '0'); // Get minutes and pad with zero

  return `${hours}:${minutes}`; // Return time in HH:MM format
}


function getManilaTime() {
  const manilaOffset = 8 * 60; // Manila is GMT+8
  const localDate = new Date();
  const utcDate = new Date(localDate.getTime() + (localDate.getTimezoneOffset() * 60000));
  const manilaTime = new Date(utcDate.getTime() + (manilaOffset * 60000));

  const hours = String(manilaTime.getHours()).padStart(2, '0'); // Get hours and pad with zero
  const minutes = String(manilaTime.getMinutes()).padStart(2, '0'); // Get minutes and pad with zero

  return `${hours}:${minutes}`; // Return time in HH:MM format
}
