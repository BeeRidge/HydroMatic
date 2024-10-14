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
const bcrypt = require('bcrypt');
const saltRounds = 10; // The salt rounds for bcrypt
const { body, validationResult } = require('express-validator');
const PORT = process.env.PORT || 3000;

// Configure multer for file upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, 'img')); // Folder to save the uploaded files
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Use original filename
  }
});

// Set file size limit (e.g., 100 MB)
const upload = multer({
  storage,
  limits: { fileSize: 100 * 1024 * 1024 } // 100 MB limit
});

// Optional: Use body-parser if you need it for other requests
app.use(express.json({ limit: '100mb' })); // Adjust limit as necessary
app.use(express.urlencoded({ limit: '100mb', extended: true }));

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

// Variable store the signed in account
let signedAcc = null;

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
// API to verify OTP
app.post("/api/otp-verify", async (req, res) => {
  const { phone, otp } = req.body;

  // Validate the input
  if (!phone || !otp) {
    return res.status(400).json({ error: "Phone number and OTP are required" });
  }

  // Check if OTP exists for the provided phone number
  const storedOtp = otpStorage[phone];

  // Check if the OTP matches
  if (storedOtp && storedOtp === Number(otp)) {
    // OTP verified successfully
    delete otpStorage[phone]; // Clear the OTP after successful verification
    return res.status(200).json({ success: true, message: "OTP verified successfully" });
  } else {
    // OTP verification failed
    return res.status(400).json({ error: "Invalid OTP" });
  }
});
// API to Sign Up
app.post("/api/verify-otp", async (req, res) => {
  const { fname, lname, phone, password, otp } = req.body;

  if (!phone || !otp || !password) {
    return res.status(400).json({ error: "Phone number, Password, and OTP are required" });
  }

  if (otpStorage[phone] && otpStorage[phone] == otp) {
    delete otpStorage[phone]; // Clear OTP after successful verification

    try {
      const [results] = await db.query('SELECT * FROM account WHERE Acc_Pnumber = ?', [phone]);

      if (results.length === 0) {
        // **Correctly hash the password before storing it**
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        console.log('Generated hashed password:', hashedPassword); // During sign-up


        // Insert the new user with the hashed password
        const [insertResults] = await db.query("INSERT INTO account (Acc_Fname, Acc_Lname, Acc_Pnumber, Acc_Password) VALUES (?, ?, ?, ?)", [fname, lname, phone, hashedPassword]);

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
    // Query the database for the account with the provided phone number
    const [results] = await db.query('SELECT * FROM account WHERE Acc_Pnumber = ?', [phone]);

    if (results.length === 0) {
      return res.status(401).json({ error: 'Invalid phone number or password' });
    }

    // Extract the hashed password from the database
    const hashedPassword = results[0].Acc_Password;
    console.log('Stored hashed password:', hashedPassword); // During login

    // Compare the provided password with the hashed password stored in the database
    const isMatch = await bcrypt.compare(password, hashedPassword);

    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid phone number or password' });
    }
    // select account logged in
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [signedAcc]);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "LOGGED IN")';
    await db.query(activityQuery, [results[0].Acc_Fname, results[0].Acc_Lname, results[0].Acc_Pnumber]);
    // If the password matches, log the user in
    signedAcc = results[0].Acc_Pnumber;
    console.log(`Number: ${signedAcc}`);
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
    const [data] = await db.query("SELECT * FROM device_info WHERE Pnum = ?", [signedAcc]);
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
    const [data] = await db.query("SELECT * FROM display_bed WHERE Pnum = ? ORDER BY Start_Date Asc", [signedAcc]);
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
    const [results] = await db.query('SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ? AND Pnum = ?', [Var_Host, Var_Ip, signedAcc]);
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

    // Use ?? for table names
    const [check] = await db.query("SELECT * FROM ??", [Var_Host]);

    // Convert resultData.Date_Dev to Manila time (GMT+8)
    const currentDate = convertToManilaTime(new Date().toISOString());
    const resultDateDev = convertToManilaTime(check[0].Date_Dev); // Make sure to access the first result

    if (currentDate === resultDateDev) {
      // Fetch the latest record limited to 1
      const [data] = await db.query(
        "SELECT Var_Temp, Var_WLvl FROM ?? WHERE Var_Ip = ? AND Date_Dev = ? ORDER BY Num_Id DESC LIMIT 1",
        [Var_Host, Var_Ip, currentDate]
      );

      return res.json(data);
    } else {
      return res.status(404).json({ error: "No records found for today's date." });
    }
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

  // Input validation and sanitization
  if (!Var_Host || !/^[a-zA-Z0-9-_]+$/.test(Var_Host)) {
    return res.status(400).json({ error: "Invalid Hostname format." });
  }
  if (!Var_Ip || !/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(Var_Ip)) {
    return res.status(400).json({ error: "Invalid IP Address format." });
  }
  if (!Last_Day || Last_Day < 1 || Last_Day > 70) {
    return res.status(400).json({ error: "Invalid number of days." });
  }
  if (!Start_Date || isNaN(new Date(Start_Date).getTime())) {
    return res.status(400).json({ error: "Invalid date format." });
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
      `INSERT INTO display_bed (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Status, Pnum) VALUES (?, ?, ?, ?, ?, ?, "ONGOING", ?)`,
      [Var_Host, Var_Ip, Last_Day, Last_Day, Start_Date, Harvest_Date, signedAcc]
    );
    // select account logged in
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [signedAcc]);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "ADD HYDRO FRAME")';
    await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);

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
  console.log(`Number: ${signedAcc}`);
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
      `INSERT INTO archived (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Date_Archived, Status, Pnum) 
      VALUES (?, ?, ?, ?, ?, ?, CURDATE(), ?, ?)`,
      [name, ip, sDay, lDay, sDate, hDate, stat, signedAcc]
    );

    // select account logged in
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [signedAcc]);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "REMOVE HYDRO FRAME")';
    await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);

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
    const [results] = await db.query('SELECT Last_Day FROM display_bed WHERE Var_Host = ? AND Var_Ip = ? AND Pnum = ?', [Var_Host, Var_Ip, signedAcc]);

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
    const [results] = await db.query("SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ? AND Pnum = ?", [Var_Host, Var_Ip, signedAcc]);
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
    // Query to find crops that have Last_Day between 60 and 70 and have not received an SMS today
    const query = `
      SELECT * FROM display_bed 
      WHERE Last_Day >= 60 AND Last_Day <= 70 
        AND (Last_SMS_Date IS NULL OR Last_SMS_Date < CURDATE()) AND Pnum = ?
    `;

    const [crops] = await db.query(query, [signedAcc]);

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
        console.log('Sending SMS to:', signedAcc);
        console.log('Message:', message);

        // Send SMS using Semaphore API
        await axios.post('https://api.semaphore.co/api/v4/messages', {
          apikey: SEMAPHORE_API_KEY,
          number: signedAcc,
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
    const selectArchived = "SELECT * FROM archived WHERE Pnum = ? ORDER BY Archive_Id DESC";
    const [results] = await db.query(selectArchived, [signedAcc]);
    res.json(results); // Send the results as JSON
  } catch (err) {
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to fetch all archived data
app.get('/api/Dashboard-Data', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM display_bed WHERE Pnum = ? ORDER BY Var_Host ASC";
    const [results] = await db.query(selectAll, [signedAcc]);
    res.json(results); // Send the results as JSON
  } catch (err) {
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to get the total bed frames
app.get('/api/TotalBed', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM display_bed WHERE Pnum = ?";

    // Execute the query
    const [results] = await db.query(selectAll, [signedAcc]);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to get the total bed frames
app.get('/api/TotalHarvest', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM display_bed WHERE Pnum = ? AND Status = 'HARVEST'";

    // Execute the query
    const [results] = await db.query(selectAll, [signedAcc]);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to get the total bed frames
app.get('/api/TotalOngoing', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM display_bed WHERE Pnum = ? AND Status = 'ONGOING'";

    // Execute the query
    const [results] = await db.query(selectAll, [signedAcc]);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).send({ error: 'Database query error' });
  }
});
// API for account information
app.get('/api/account-details', async (req, res) => {
  try {
    console.log('Current signedAcc:', signedAcc); // Debugging line
    const query = `SELECT Acc_Fname as fname, Acc_Lname as lname, Acc_Pnumber as phone FROM account WHERE Acc_Pnumber = ? LIMIT 1`;
    const [rows] = await db.query(query, [signedAcc]);

    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    console.error('Error fetching account details:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
// API to update the first name
app.post('/api/account/update-fname', [
  body('newFname').isAlpha().escape().trim() // Validate input (only alphabets)
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { newFname } = req.body;

    // SQL query to update the first name
    const updateFnameQuery = `
          UPDATE account 
          SET Acc_Fname = ? 
          WHERE Acc_Pnumber = ?
      `;
    const [updateResult] = await db.query(updateFnameQuery, [sanitizeInput(newFname), signedAcc]);

    if (updateResult.affectedRows === 0) {
      return res.status(404).send({ error: 'Old account information is incorrect.' });
    }

    // select account logged in
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [signedAcc]);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "UPDATE FIRST NAME")';
    await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);

    res.send({ message: 'First name updated successfully.' });
  } catch (err) {
    console.error('Error updating first name:', err);
    res.status(500).send({ error: 'Error updating first name.' });
  }
});
// API to update the last name
app.post('/api/account/update-lname', [
  body('newLname').isAlpha().escape().trim()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { newLname } = req.body;

    const updateLnameQuery = `
          UPDATE account 
          SET Acc_Lname = ? 
          WHERE Acc_Pnumber = ?
      `;
    const [updateResult] = await db.query(updateLnameQuery, [sanitizeInput(newLname), signedAcc]);

    if (updateResult.affectedRows === 0) {
      return res.status(404).send({ error: 'Old account information is incorrect.' });
    }

    // select account logged in
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [signedAcc]);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "UPDATE LAST NAME")';
    await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);

    res.send({ message: 'Last name updated successfully.' });
  } catch (err) {
    console.error('Error updating last name:', err);
    res.status(500).send({ error: 'Error updating last name.' });
  }
});
// Function to sanitize input
function sanitizeInput(input) {
  return input.replace(/[^\w\s]/gi, ''); // Remove non-alphanumeric characters (except spaces)
}
// API to update the phone number
app.post('/api/account/update-phone', [
  body('newPnumber').isMobilePhone().escape().trim()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { newPnumber } = req.body;

    const checkPhoneNumberQuery = `
        SELECT * FROM account WHERE Acc_Pnumber = ?
    `;
    const [phoneResults] = await db.query(checkPhoneNumberQuery, [newPnumber]);

    if (phoneResults.length > 0) {
      return res.status(409).send({ error: 'Phone number already exists.' });
    }

    const updatePhoneQuery = `
        UPDATE account 
        SET Acc_Pnumber = ? 
        WHERE Acc_Pnumber = ?
    `;
    const [updateResult] = await db.query(updatePhoneQuery, [sanitizeInput(newPnumber), signedAcc]);

    if (updateResult.affectedRows === 0) {
      return res.status(404).send({ error: 'Old account information is incorrect.' });
    }

    // Update the phone number in related tables
    const updateArchiveQuery = `
        UPDATE archive 
        SET Pnum = ? 
        WHERE Pnum = ?
    `;
    await db.query(updateArchiveQuery, [sanitizeInput(newPnumber), sanitizeInput(signedAcc)]);

    const updateDeviceInfoQuery = `
        UPDATE device_info 
        SET Pnum = ? 
        WHERE Pnum = ?
    `;
    await db.query(updateDeviceInfoQuery, [sanitizeInput(newPnumber), sanitizeInput(signedAcc)]);

    const updateDisplayBedQuery = `
        UPDATE display_bed 
        SET Pnum = ? 
        WHERE Pnum = ?
    `;
    await db.query(updateDisplayBedQuery, [sanitizeInput(newPnumber), sanitizeInput(signedAcc)]);

    // Update the signedAcc variable
    const [select] = await db.query("SELECT * FROM account WHERE Acc_Pnumber = ?", [sanitizeInput(newPnumber)]);
    signedAcc = select[0].Acc_Pnumber;
    console.log(`Number: ${signedAcc}`);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "UPDATE PHONE NUMBER")';
    await db.query(activityQuery, [select[0].Acc_Fname, select[0].Acc_Lname, select[0].Acc_Pnumber]);
    res.send({ message: 'Phone number updated successfully.' });
  } catch (err) {
    console.error('Error updating phone number:', err);
    res.status(500).send({ error: 'Error updating phone number.' });
  }
});
// API to update password
app.post('/api/account/update-password', async (req, res) => {
  const { newPassword } = req.body;
  const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
  try {
    const query = 'UPDATE account SET Acc_Password = ? WHERE Acc_Pnumber = ?';
    await db.query(query, [hashedPassword, signedAcc]); // Assuming signedAcc is the authenticated user's phone number
    // select account logged in
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [signedAcc]);
    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "UPDATE PASSWORD")';
    await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);
    res.json({ message: 'Password updated successfully' });
  } catch (err) {
    console.error('Error updating password:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
// API for forgot password
app.post('/api/account/forgot-password', async (req, res) => {
  const { phone, newPassword } = req.body;

  try {
    // Check if the account exists
    const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
    const [rows] = await db.query(accountCheckQuery, [phone]);

    if (rows.length === 0) {
      return res.status(404).json({ success: false, error: 'No account found with the provided phone number.' });
    }

    // If account exists, proceed to update the password
    const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
    const updatePasswordQuery = 'UPDATE account SET Acc_Password = ? WHERE Acc_Pnumber = ?';
    await db.query(updatePasswordQuery, [hashedPassword, phone]);

    // Insert the activity into the activities table
    const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "FORGOT PASSWORD")';
    await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);

    return res.json({ success: true, message: 'Password updated successfully' });
  } catch (err) {
    console.error('Error updating password:', err);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
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

    const [checkResult] = await db.query("SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ? AND Pnum = ?", [varHost, varIp, signedAcc]);

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

        await db.query("INSERT INTO display_bed (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Status, Pnum) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", [resultData.Var_Host, resultData.Var_Ip, resultData.Start_Day, resultData.Last_Day, resultData.Start_Date, resultData.Harvest_Date, status, signedAcc]);

        const [deleteResult] = await db.query("DELETE FROM archived WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?", [id, varHost, varIp, formattedDate]);

        if (deleteResult.affectedRows > 0) {
          // select account logged in
          const accountCheckQuery = 'SELECT * FROM account WHERE Acc_Pnumber = ?';
          const [rows] = await db.query(accountCheckQuery, [signedAcc]);
          // Insert the activity into the activities table
          const activityQuery = 'INSERT INTO activities (Fname, Lname, Pnum, Activity) VALUES (?, ?, ?, "RECOVER HYDRO FRAME")';
          await db.query(activityQuery, [rows[0].Acc_Fname, rows[0].Acc_Lname, rows[0].Acc_Pnumber]);
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
        'SELECT Last_Day FROM display_bed WHERE Var_Host = ? AND Var_Ip = ? AND Pnum = ?',
        [Var_Host, Var_Ip, signedAcc]
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
// POST route to insert or check device info
app.post('/api/save_device_info', async (req, res) => {
  const { hostname = '', ip_address = '', fname = '', lname = '', pnum = '' } = req.body;

  // Validate input
  if (!hostname || !ip_address || !fname || !lname || !pnum) {
    return res.status(400).send('Hostname, IP address, first name, last name, and phone number are required.');
  }

  try {
    // Check if the record exists
    const [result] = await db.query(
      `SELECT * FROM device_info WHERE Var_Host = ? AND Var_Ip = ?`,
      [hostname, ip_address]
    );

    if (result.length === 0) {
      // Insert new record if it does not exist
      await db.query(
        `INSERT INTO device_info (Var_Host, Var_Ip, fname, lname, pnum, Status) VALUES (?, ?, ?, ?, ?, "ACTIVE")`,
        [hostname, ip_address, fname, lname, pnum]
      );
      res.send('New record created successfully.');
    } else {
      res.send('Record already exists.');
    }
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).send('Error checking or saving the device info.');
  }
});
// POST route for inserting sensor data
app.post('/api/insert_data', async (req, res) => {
  const { temperature, water_level, ip_address, hostname } = req.body;

  if (!temperature || !water_level || !ip_address) {
    return res.status(400).send('Missing required data');
  }

  try {
    // Check if the IP address exists in the device_info table and get the Var_Host
    const [deviceInfo] = await db.query(
      `SELECT Var_Host FROM device_info WHERE Var_Ip = ?`,
      [ip_address]
    );

    let varHost;

    if (deviceInfo.length > 0) {
      // If the IP address is found, use the corresponding Var_Host
      varHost = deviceInfo[0].Var_Host;
    } else {
      // If the IP address is not found, use the hostname from the request
      varHost = hostname;
    }

    // Check if the table exists for the given varHost
    const [tableCheck] = await db.query(`SHOW TABLES LIKE ?`, [varHost]);

    if (tableCheck.length === 0) {
      // If table does not exist, create it
      await db.query(`
              CREATE TABLE ${varHost} (
                  Num_Id INT(255) NOT NULL AUTO_INCREMENT,
                  Var_Ip VARCHAR(50) NOT NULL,
                  Var_Temp VARCHAR(50) NOT NULL,
                  Var_WLvl VARCHAR(50) NOT NULL,
                  Date_Dev DATE NOT NULL,
                  Time_Dev TIME NOT NULL,
                  PRIMARY KEY (Num_Id)
              );
          `);
      console.log(`Table ${varHost} created successfully`);
    }

    // Insert the sensor data into the table
    await db.query(
      `INSERT INTO ${varHost} (Var_Ip, Var_Temp, Var_WLvl, Date_Dev, Time_Dev)
           VALUES (?, ?, ?, CURDATE(), CURTIME())`,
      [ip_address, temperature, water_level]
    );
    res.send('New record created successfully');
  } catch (err) {
    console.error('Error inserting data:', err);
    res.status(500).send('Error inserting data');
  }
});
// Route to get content data from the database
app.get('/api/Page-Content', async (req, res) => {
  const sql = 'SELECT * FROM pagecontent';

  try {
    const [results] = await db.query(sql);
    console.log(results); // Log results to see what is returned
    if (results.length === 0) {
      return res.status(404).json({ error: 'No content found' });
    }
    res.json(results);
  } catch (err) {
    console.error(err); // Log the error for debugging
    res.status(500).json({ error: 'Failed to retrieve content' });
  }
});
// Route to save page content
app.post('/api/Save-Content', async (req, res) => {
  const updates = req.body; // Expecting an array of objects with tagId and tagContent

  try {
    // Iterate through each item and update in database (using a prepared statement for safety)
    const promises = updates.map(item => {
      const sql = 'UPDATE pagecontent SET tagContent = ? WHERE tagId = ? AND sectionId = ?';
      return db.query(sql, [item.tagContent, item.tagId, item.sectionId]);
    });

    await Promise.all(promises); // Wait for all updates to complete
    res.json({ message: 'Content updated successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to update content' });
  }
});
// Route to get image content data from the database
app.get('/api/Image-Content', async (req, res) => {
  const sql = 'SELECT * FROM pageimage'; // Adjust sectionId if needed

  try {
    const [results] = await db.query(sql);
    console.log(results); // Log results to see what is returned
    if (results.length === 0) {
      return res.status(404).json({ error: 'No content found' });
    }
    res.json(results);
  } catch (err) {
    console.error(err); // Log the error for debugging
    res.status(500).json({ error: 'Failed to retrieve content' });
  }
});
// Route to Save Image
app.post('/api/Save-Image', upload.single('imageUpload'), async (req, res) => {
  try {
    const { sectionId, imageId } = req.body; // Get sectionId and imageId from request body
    const imgData = req.file; // multer will add the uploaded file to req.file

    if (!imgData) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    const src = `img/${imgData.filename}`;
    // Here you can perform your database update operation
    const sql = 'UPDATE pageimage SET filename = ?, src = ? WHERE imageId = ? AND sectionId = ?';
    const result = await db.query(sql, [imgData.filename, src, imageId, sectionId]); // Perform your DB operation

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Image not found or section ID invalid' });
    }

    return res.json({ message: 'Image updated successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to update image', details: err.message });
  }
});

/*------------------------------------------------- ADMIN ------------------------------------------- */

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

// API to get the total Users
app.get('/api/admin/TotalUser', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM device_info";

    // Execute the query
    const [results] = await db.query(selectAll, [signedAcc]);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).send({ error: 'Database query error' });
  }
});
// API to get the total Device
app.get('/api/admin/TotalDevice', async (req, res) => {
  try {
    const selectAll = "SELECT * FROM account";

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
// API to display recently created account
app.get('/api/admin/new-users', async (req, res) => {
  try {
      // Query to get all new users from the account table
      const userQuery = 'SELECT * FROM account ORDER BY Date DESC'; // Ensure this is the correct table and field names
      const [rows] = await db.query(userQuery);
      res.json({ success: true, users: rows }); // Ensure you are sending users
  } catch (err) {
      console.error('Error fetching user data:', err);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
});
// API to display user activities
app.get('/api/admin/user-activities', async (req, res) => {
  try {
    // Query to get all user activities from the activities table
    const activityQuery = 'SELECT * FROM activities ORDER BY Date DESC';
    const [rows] = await db.query(activityQuery);
    res.json({ success: true, activities: rows });
  } catch (err) {
    console.error('Error fetching user activity data:', err);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
});
// API to see device info
app.get('/api/admin/device-info', async (req, res) => {
  try {
    // Query to get all devices from the device_info table
    const deviceQuery = 'SELECT * FROM device_info';
    const [rows] = await db.query(deviceQuery);

    // Send the result back as JSON
    res.json({ success: true, devices: rows });
  } catch (err) {
    console.error('Error fetching device data:', err);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
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
app.get("/admin-cms", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-cms.html"));
});
// Handle admin-main.html
app.get("/admin-main", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-main.html"));
});
// Handle admin-main.html
app.get("/admin-user", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-user.html"));
});
// Handle admin-main.html
app.get("/home", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "home.html"));
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
  console.log(`Server is running on http://localhost:${PORT}`);
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
