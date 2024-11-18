const express = require("express");
const path = require("path");
const mysql = require("mysql2/promise");
const bodyParser = require("body-parser");
require("dotenv").config();
const axios = require("axios");
const multer = require("multer");
const jwt = require("jsonwebtoken");
const fs = require("fs");
const app = express();
const bcrypt = require("bcrypt");
const session = require("express-session");
const saltRounds = 10; // The salt rounds for bcrypt
const { body, validationResult } = require("express-validator");
const PORT = process.env.PORT || 3000;

// Configure session middleware
app.use(
  session({
    secret: "a5da10672b82ad5af1bb0abb714293c5fa9667005bc4712017ac00eea56d27",
    resave: false,
    saveUninitialized: true,
    cookie: {
      secure: false, // Set true only if using HTTPS
      httpOnly: true,
      sameSite: 'lax', // Allows cross-origin navigation on the same domain
      maxAge: 24 * 60 * 60 * 1000, // 1-day expiration
    },
  })
);

// Configure multer for file upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, "img")); // Folder to save the uploaded files
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Use original filename
  },
});
// Set file size limit (e.g., 100 MB)
const upload = multer({
  storage,
  limits: { fileSize: 100 * 1024 * 1024 }, // 100 MB limit
});
// Create a connection to the database
const db = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "hydromatic",
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
// Optional: Use body-parser if you need it for other requests
app.use(express.json({ limit: "100mb" })); // Adjust limit as necessary
app.use(express.urlencoded({ limit: "100mb", extended: true }));
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
    return res
      .status(200)
      .json({ success: true, message: "OTP verified successfully" });
  } else {
    // OTP verification failed
    return res.status(400).json({ error: "Invalid OTP" });
  }
});
// API to Sign Up
app.post("/api/verify-otp", async (req, res) => {
  const { fname, lname, phone, password, otp } = req.body;

  if (!phone || !otp || !password) {
    return res
      .status(400)
      .json({ error: "Phone number, Password, and OTP are required" });
  }

  if (otpStorage[phone] && otpStorage[phone] == otp) {
    delete otpStorage[phone]; // Clear OTP after successful verification

    try {
      const [results] = await db.query(
        "SELECT * FROM account WHERE AccountPhoneNumber = ?",
        [phone]
      );

      if (results.length === 0) {
        // **Correctly hash the password before storing it**
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        console.log("Generated hashed password:", hashedPassword); // During sign-up

        // Insert the new user with the hashed password
        const [insertResults] = await db.query(
          "INSERT INTO account (AccountFirstname, AccountLastname, AccountPhoneNumber, AccountPassword, Date) VALUES (?, ?, ?, ?, CURDATE())",
          [fname, lname, phone, hashedPassword]
        );

        res
          .status(200)
          .json({ success: true, message: "Account created successfully!" });
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
app.post("/api/login", async (req, res) => {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res
      .status(400)
      .json({ error: "Phone number and password are required" });
  }

  try {
    const [results] = await db.query(
      "SELECT * FROM account WHERE AccountPhoneNumber = ?",
      [phone]
    );

    if (results.length === 0) {
      return res.status(401).json({ error: "Invalid Phone Number" });
    }

    const hashedPassword = results[0].AccountPassword;
    const isMatch = await bcrypt.compare(password, hashedPassword);

    if (!isMatch) {
      return res.status(401).json({ error: "Invalid Password" });
    }

    // Set the user session
    req.session.user = {
      id: results[0].AccountId,
      phone: results[0].AccountPhoneNumber,
      fname: results[0].AccountFirstname,
      lname: results[0].AccountLastname,
    };

    // Insert login activity
    const activityQuery =
      'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "LOGGED IN")';
    await db.query(activityQuery, [results[0].AccountId]);

    res.status(200).json({
      success: true,
      message: "Login successful",
      user: req.session.user,
    });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});
// User logout
app.post("/api/logout", async (req, res) => {
  try {
    // Check if user session exists
    if (!req.session.user || !req.session.user.id) {
      return res.status(400).json({ error: "No active session found" });
    }

    const AccountId = req.session.user.id; // Assign AccountId from session data

    // Destroy the session and perform database operations within callback
    req.session.destroy(async (err) => {
      if (err) {
        console.error("Error destroying session:", err);
        return res.status(500).json({ error: "Failed to log out" });
      }

      // Only proceed with logging if AccountId is valid
      if (AccountId) {
        // Insert logout activity into the database
        const activityQuery =
          'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "LOGGED OUT")';
        try {
          await db.query(activityQuery, [AccountId]);
          console.log("Logout activity logged successfully");
        } catch (dbErr) {
          console.error("Error logging logout activity:", dbErr);
          return res.status(500).json({ error: "Failed to log activity" });
        }
      }

      // Respond with success message
      res.status(200).json({ message: "User logged out successfully" });
    });
  } catch (error) {
    console.error("Error in logout process:", error);
    res.status(500).json({ error: "An error occurred during logout" });
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
// API to get user-specific data
app.get("/api/device_info", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const [results] = await db.query('SHOW TABLES LIKE "deviceinformation"');
    if (results.length === 0) {
      return res
        .status(404)
        .json({ error: "Table deviceinformation not found" });
    }
    const [data] = await db.query(
      "SELECT * FROM deviceinformation WHERE OwnerPhoneNumber = ?",
      [req.session.user.phone]
    );
    res.json(data);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Updated /api/display_bed route
app.get("/api/display_bed", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const [results] = await db.query('SHOW TABLES LIKE "hydroframe"');
    if (results.length === 0) {
      return res.status(404).json({ error: "Table hydroframe not found" });
    }
    const [data] = await db.query(
      "SELECT * FROM hydroframe WHERE AccountId = ? ORDER BY HydroFrameStartDay ASC",
      [req.session.user.id]
    );
    res.json(data);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Get specific data from table display_bed
app.post("/api/display_table", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  const { DeviceHostname, DeviceIpAddress } = req.body;

  if (!DeviceHostname || !DeviceIpAddress) {
    return res.status(400).json({ error: "Missing Hostname or Ip Address" });
  }

  try {
    const [results] = await db.query(
      "SELECT * FROM hydroframe WHERE DeviceHostName = ? AND DeviceIpAddress = ? AND AccountId = ?",
      [DeviceHostname, DeviceIpAddress, req.session.user.id]
    );
    if (results.length === 0) {
      return res
        .status(404)
        .json({ error: "No data found for the given Hostname and Ip Address" });
    }
    res.json(results);
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
app.post("/api/send-Data", async (req, res) => {
  const { DeviceHostname, DeviceIpAddress } = req.body;

  // Log received parameters
  console.log("DeviceHostname:", DeviceHostname);
  console.log("DeviceIpAddress:", DeviceIpAddress);

  try {
    const [results] = await db.query("SHOW TABLES LIKE ?", [DeviceHostname]);
    if (results.length === 0) {
      console.error("Table not found:", DeviceHostname);
      return res.status(404).json({ error: "Table not found" });
    }

    const [check] = await db.query("SELECT * FROM ??", [DeviceHostname]);
    if (!check || check.length === 0) {
      console.error("No data found in table:", DeviceHostname);
      return res.status(404).json({ error: "No data in the specified table" });
    }

    // Ensure `convertToManilaTime` is defined and working correctly
    const currentDate = convertToManilaTime(new Date().toISOString());
    const resultDateDev = convertToManilaTime(check[0].Date);

    if (currentDate === resultDateDev) {
      const [data] = await db.query(
        "SELECT WaterLevel, WaterTemperature FROM ?? WHERE DeviceIpAddress = ? AND Date = ? ORDER BY Id DESC LIMIT 1",
        [DeviceHostname, DeviceIpAddress, currentDate]
      );

      if (data.length === 0) {
        console.error("No records found for today's date and device IP.");
        return res
          .status(404)
          .json({ error: "No records found for today's date." });
      }

      return res.json(data);
    } else {
      console.error("No records found for today's date:", currentDate);
      return res
        .status(404)
        .json({ error: "No records found for today's date." });
    }
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// Displaying data logs on the table
app.post("/api/DataLogs", async (req, res) => {
  const { DeviceHostname, DeviceIpAddress, HydroFrameStartDate } = req.body;

  console.log("Request body:", {
    DeviceHostname,
    DeviceIpAddress,
    HydroFrameStartDate,
  });

  try {
    const [tables] = await db.query("SHOW TABLES LIKE ?", [DeviceHostname]);
    if (tables.length === 0) {
      return res.status(404).json({ error: "Table not found" });
    }

    const [results] = await db.query(
      "SELECT * FROM ?? WHERE DeviceIpAddress = ? AND Date >= ? ORDER BY Id DESC",
      [
        DeviceHostname,
        DeviceIpAddress,
        convertToManilaTime(HydroFrameStartDate),
      ]
    );

    console.log("Data fetched from database:", results);
    res.json(results);
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Error fetching data from database" });
  }
});
// API to check device if inactive and active
app.post("/api/checkDevice", async (req, res) => {
  try {
    // Get all devices from the device_info table
    const selectDevices =
      "SELECT * FROM deviceinformation WHERE OwnerPhoneNumber = ?";
    const [devices] = await db.query(selectDevices, [req.session.user.phone]);

    if (devices.length === 0) {
      return res.status(404).json({ error: "No devices found" });
    }

    // Loop through all devices and check their respective table for date/time comparison
    for (const device of devices) {
      const { DeviceHostname, DeviceIpAddress } = device;

      // Check if the table for the device exists
      const [tables] = await db.query("SHOW TABLES LIKE ?", [DeviceHostname]);
      if (tables.length === 0) {
        // Update the device status to REPAIR if its table doesn't exist
        await db.query(
          "UPDATE deviceinformation SET DeviceStatus = 'REPAIR' WHERE DeviceHostname = ? AND DeviceIpAddress = ?",
          [DeviceHostname, DeviceIpAddress]
        );
        continue; // Skip to the next device
      }

      // Get the latest record from the device-specific table
      const [deviceData] = await db.query(
        "SELECT * FROM ?? WHERE DeviceIpAddress = ? ORDER BY Date DESC, Time DESC LIMIT 1",
        [DeviceHostname, DeviceIpAddress]
      );

      if (deviceData.length === 0) {
        continue; // Skip this device if no records are found
      }

      const currentDate = convertToManilaTime(new Date().toISOString());
      const latestDeviceDate = convertToManilaTime(deviceData[0].Date);
      const latestDeviceTime = formatTime(deviceData[0].Time); // Format to HH:MM
      const currentTime = getManilaTime(); // Format to HH:MM

      // Compare the date and time
      if (
        latestDeviceDate !== currentDate ||
        latestDeviceTime !== currentTime
      ) {
        // If date/time mismatch, update the device_info status to INACTIVE
        await db.query(
          "UPDATE deviceinformation SET DeviceStatus = 'INACTIVE' WHERE DeviceHostname = ? AND DeviceIpAddress = ?",
          [DeviceHostname, DeviceIpAddress]
        );
      } else {
        await db.query(
          "UPDATE deviceinformation SET DeviceStatus = 'ACTIVE' WHERE DeviceHostname = ? AND DeviceIpAddress = ?",
          [DeviceHostname, DeviceIpAddress]
        );
      }
    }

    // If all checks are successful
    res.status(200).json({ message: "Device statuses updated successfully" });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: "Database query error" });
  }
});
// Updated /api/add-bed-database route
app.post("/api/add-bed-database", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  const {
    DeviceHostname,
    DeviceIpAddress,
    HydroFrameLastDay,
    HydroFrameStartDate,
  } = req.body;

  if (
    !DeviceHostname ||
    !DeviceIpAddress ||
    !HydroFrameLastDay ||
    !HydroFrameStartDate
  ) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  try {
    const [results] = await db.query(
      "SELECT * FROM hydroframe WHERE DeviceHostname = ? AND DeviceIpAddress = ?",
      [DeviceHostname, DeviceIpAddress]
    );

    if (results.length > 0) {
      return res.status(409).json({
        error: "Device with the same Hostname or IP Address already exists",
      });
    }

    const startDate = new Date(HydroFrameStartDate);
    const harvestDate = new Date(startDate);
    harvestDate.setDate(harvestDate.getDate() + (70 - HydroFrameLastDay));
    const HydroFrameHarvestDate = harvestDate.toISOString().split("T")[0];

    await db.query(
      `INSERT INTO hydroframe (DeviceHostname, DeviceIpAddress, HydroFrameStartDay, HydroFrameLastDay, HydroFrameStartDate, HydroFrameHarvestDate, HydroFrameStatus, AccountId) VALUES (?, ?, ?, ?, ?, ?, "ONGOING", ?)`,
      [
        DeviceHostname,
        DeviceIpAddress,
        HydroFrameLastDay,
        HydroFrameLastDay,
        HydroFrameStartDate,
        HydroFrameHarvestDate,
        req.session.user.id,
      ]
    );

    const activityQuery =
      'INSERT INTO useractivity ( AccountId, Activity) VALUES ( ?, "ADD HYDRO FRAME")';
    await db.query(activityQuery, [req.session.user.id]);

    res.status(200).json({ message: "Bed inserted successfully!" });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Error inserting data into database" });
  }
});
// Updated POST endpoint to remove a bed
app.post("/api/delete-device", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  
  const { DeviceHostname } = req.body;

  if (!DeviceHostname) {
    return res.status(400).json({ message: "No hostname provided." });
  }

  try {
    // SQL query to select the record to be deleted
    const [results] = await db.query(
      "SELECT * FROM hydroframe WHERE DeviceHostname = ? AND AccountId = ?",
      [DeviceHostname, req.session.user.id]
    );

    if (results.length === 0) {
      return res.status(404).json({ message: "Bed not found." });
    }

    // Get the record details
    const {
      DeviceHostname: name,
      DeviceIpAddress: ip,
      HydroFrameStartDay: sDay,
      HydroFrameLastDay: lDay,
      HydroFrameStartDate: sDate,
      HydroFrameHarvestDate: hDate,
      HydroFrameStatus: status, // Fetch HydroFrameStatus to determine the archive status
    } = results[0];

    // SQL query to delete the record
    const [deleteResult] = await db.query(
      "DELETE FROM hydroframe WHERE DeviceHostname = ? AND AccountId = ?",
      [DeviceHostname, req.session.user.id]
    );

    if (deleteResult.affectedRows === 0) {
      return res.status(404).json({ message: "Bed not found." });
    }

    // Determine status based on HydroFrameStatus
    const stat = status === "HARVEST" ? "FINISHED" : "REMOVED";

    // Insert into archived
    await db.query(
      `INSERT INTO archive (DeviceHostname, DeviceIpAddress, ArchiveStartDay, ArchiveLastDay, ArchiveStartDate, ArchiveHarvestDate, ArchiveDate, ArchiveStatus, AccountId) 
      VALUES (?, ?, ?, ?, ?, ?, CURDATE(), ?, ?)`,

      [name, ip, sDay, lDay, sDate, hDate, stat, req.session.user.id]
    );

    // Insert the activity into the activities table
    const activityQuery =
      'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "REMOVE HYDRO FRAME")';
    await db.query(activityQuery, [req.session.user.id]);

    res.status(200).json({ message: "Bed successfully deleted." });
  } catch (err) {
    console.error("Error:", err);
    res
      .status(500)
      .json({ message: "Failed to delete the bed from the database." });
  }
});

app.post("/api/update-last-day", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  const {
    DeviceHostname,
    DeviceIpAddress,
    HydroFrameStartDay,
    HydroFrameStartDate,
    currentDate,
  } = req.body;

  try {
    const [results] = await db.query(
      "SELECT HydroFrameLastDay FROM hydroframe WHERE DeviceHostname = ? AND DeviceIpAddress = ? AND AccountId = ?",
      [DeviceHostname, DeviceIpAddress, req.session.user.id]
    );

    if (!Array.isArray(results) || results.length === 0) {
      return res.status(404).json({ message: "Bed not found" });
    }

    const lastDay = results[0].HydroFrameLastDay;

    if (lastDay <= 70) {
      if (lastDay >= 60) {
        await db.query(
          `UPDATE hydroframe
          SET HydroFrameStatus = 'HARVEST'
          WHERE DeviceHostname = ? AND DeviceIpAddress = ? AND AccountId = ?`,
          [DeviceHostname, DeviceIpAddress, req.session.user.id]
        );
      }

      await db.query(
        `UPDATE hydroframe
        SET HydroFrameLastDay = DATEDIFF(?, ?) + ? - 1, HydroFrameUpdateDate = ?
        WHERE DeviceHostname = ? AND DeviceIpAddress = ? AND AccountId = ?`,
        [
          currentDate,
          HydroFrameStartDate,
          HydroFrameStartDay,
          currentDate,
          DeviceHostname,
          DeviceIpAddress,
          req.session.user.id,
        ]
      );

      return res.status(200).json({ message: "Update successful" });
    } else {
      return res.status(400).json({ message: "HydroFrameLastDay exceeds 70" });
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Database error", details: err.message });
  }
});


// API for Dates
app.post("/api/dates", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  const { DeviceHostname, DeviceIpAddress } = req.body;

  try {
    const [results] = await db.query(
      "SELECT * FROM hydroframe WHERE DeviceHostname = ? AND DeviceIpAddress = ? AND AccountId = ?",
      [DeviceHostname, DeviceIpAddress, req.session.user.id]
    );
    res.json(results);
  } catch (err) {
    console.error("Error fetching data:", err);
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
      HydroFrameStartDay: row.HydroFrameStartDay,
      end_day: row.end_day,
    }));

    res.json(growthStages);
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: "Error fetching growth stages" });
  }
});
// Updated /api/notify-harvest endpoint
app.post("/api/notify-harvest", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const query = `
      SELECT * FROM hydroframe 
      WHERE HydroFrameLastDay >= 60 AND HydroFrameLastDay <= 70 
      AND (HydroFrameLastSMSDate IS NULL OR HydroFrameLastSMSDate < CURDATE()) AND AccountId = ?
    `;

    const [crops] = await db.query(query, [req.session.user.id]);

    if (crops.length === 0) {
      return res.status(200).json({
        message:
          "No crops ready for harvest within the specified range or it already sent an SMS notification",
      });
    }

    for (const crop of crops) {
      const cropName = crop.DeviceHostname;
      const lastDay = crop.HydroFrameLastDay;
      const harvestDate = new Date(crop.HydroFrameHarvestDate);
      const formattedHarvestDate = harvestDate.toDateString();

      const message = `Dear Farmer, your crop from "${cropName}" is ready to harvest. It has been growing for ${lastDay} days. Please harvest the crops until ${formattedHarvestDate}.`;

      await axios.post("https://api.semaphore.co/api/v4/messages", {
        apikey: SEMAPHORE_API_KEY,
        number: req.session.user.phone,
        message: message,
        sendername: "HydroMatic",
      });

      const updateQuery =
        'UPDATE hydroframe SET HydroFrameLastSMSDate = CURDATE(), HydroFrameStatus = "HARVEST" WHERE DeviceHostname = ? AND DeviceIpAddress = ?';
      await db.query(updateQuery, [crop.DeviceHostname, crop.DeviceIpAddress]);
    }

    res.status(200).json({ message: "SMS notifications sent successfully" });
  } catch (error) {
    console.error("Error in /api/notify-harvest:", error);
    res.status(500).json({ message: "Error processing request" });
  }
});
// Updated /api/archived endpoint
app.get("/api/archived", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  try {
    const selectArchived =
      "SELECT * FROM archive WHERE AccountId = ? ORDER BY ArchiveId DESC";
    const [results] = await db.query(selectArchived, [req.session.user.id]);
    res.json(results); // Send the results as JSON
  } catch (err) {
    res.status(500).send({ error: "Database query error" });
  }
});
// Updated /api/Dashboard-Data endpoint
app.get("/api/Dashboard-Data", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const selectAll =
      "SELECT * FROM hydroframe WHERE AccountId = ? ORDER BY DeviceHostname ASC";
    const [results] = await db.query(selectAll, [req.session.user.id]);
    res.json(results);
  } catch (err) {
    res.status(500).send({ error: "Database query error" });
  }
});
// API to get the total bed frames
app.get("/api/TotalBed", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const selectAll = "SELECT * FROM hydroframe WHERE AccountId = ?";
    const [results] = await db.query(selectAll, [req.session.user.id]);
    const totalRows = results.length;
    res.json({ total: totalRows });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: "Database query error" });
  }
});
// API to get the total bed frames with Status 'HARVEST'
app.get("/api/TotalHarvest", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const selectAll =
      "SELECT * FROM hydroframe WHERE AccountId = ? AND HydroFrameStatus = 'HARVEST'";
    const [results] = await db.query(selectAll, [req.session.user.id]);
    const totalRows = results.length;
    res.json({ total: totalRows });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: "Database query error" });
  }
});
// API to get the total bed frames with Status 'ONGOING'
app.get("/api/TotalOngoing", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const selectAll =
      "SELECT * FROM hydroframe WHERE AccountId = ? AND HydroFrameStatus = 'ONGOING'";
    const [results] = await db.query(selectAll, [req.session.user.id]);
    const totalRows = results.length;
    res.json({ total: totalRows });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: "Database query error" });
  }
});
// Updated /api/account-details route
app.get("/api/account-details", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  try {
    const query = `SELECT AccountFirstname as fname, AccountLastname as lname, AccountPhoneNumber as phone FROM account WHERE AccountId = ? LIMIT 1`;
    const [rows] = await db.query(query, [req.session.user.id]);

    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  } catch (err) {
    console.error("Error fetching account details:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
// API to update the first name
app.post(
  "/api/account/update-fname",
  [
    body("newFname").isAlpha().escape().trim(), // Validate input (only alphabets)
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    if (!req.session.user) {
      return res.status(401).send({ error: "Unauthorized" });
    }

    try {
      const { newFname } = req.body;

      // SQL query to update the first name in the account table
      const updateAccountFnameQuery = `
      UPDATE account 
      SET AccountFirstname = ? 
      WHERE AccountId = ?
    `;
      const [accountUpdateResult] = await db.query(updateAccountFnameQuery, [
        sanitizeInput(newFname),
        req.session.user.id,
      ]);

      if (accountUpdateResult.affectedRows === 0) {
        return res
          .status(404)
          .send({ error: "No account found or first name is unchanged." });
      }

      // SQL query to update the first name in the device_info table
      const updateDeviceFnameQuery = `
      UPDATE deviceinformation 
      SET OwnerFirstname = ? 
      WHERE OwnerPhoneNumber = ? AND OwnerFirstname <> ?
    `;
      await db.query(updateDeviceFnameQuery, [
        sanitizeInput(newFname),
        req.session.user.phone,
        sanitizeInput(newFname),
      ]);

      // Insert the activity into the activities table
      const activityQuery =
        'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "UPDATE FIRST NAME")';
      await db.query(activityQuery, [req.session.user.id]);

      res.send({ message: "First name updated successfully." });
    } catch (err) {
      console.error("Error updating first name:", err);
      res.status(500).send({ error: "Error updating first name." });
    }
  }
);
// API to update the last name
app.post(
  "/api/account/update-lname",
  [body("newLname").isAlpha().escape().trim()],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    if (!req.session.user) {
      return res.status(401).send({ error: "Unauthorized" });
    }

    try {
      const { newLname } = req.body;

      const updateLnameQuery = `
      UPDATE account 
      SET AccountLastname = ? 
      WHERE AccountId = ?
    `;
      const [updateResult] = await db.query(updateLnameQuery, [
        sanitizeInput(newLname),
        req.session.user.id,
      ]);

      if (updateResult.affectedRows === 0) {
        return res
          .status(404)
          .send({ error: "Old account information is incorrect." });
      }

      // SQL query to update the last name in the device_info table
      const updateDeviceLnameQuery = `
      UPDATE deviceinformation 
      SET OwnerLastname = ? 
      WHERE OwnerPhoneNumber = ? AND OwnerLastname <> ?
    `;
      await db.query(updateDeviceLnameQuery, [
        sanitizeInput(newLname),
        req.session.user.phone,
        sanitizeInput(newLname),
      ]);

      // Insert the activity into the activities table
      const activityQuery =
        'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "UPDATE LAST NAME")';
      await db.query(activityQuery, [req.session.user.id]);

      res.send({ message: "Last name updated successfully." });
    } catch (err) {
      console.error("Error updating last name:", err);
      res.status(500).send({ error: "Error updating last name." });
    }
  }
);
// API to update the phone number
app.post(
  "/api/account/update-phone",
  [body("newPnumber").isMobilePhone().escape().trim()],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    if (!req.session.user) {
      return res.status(401).send({ error: "Unauthorized" });
    }

    try {
      const { newPnumber } = req.body;

      const checkPhoneNumberQuery = `
      SELECT * FROM account WHERE AccountPhoneNumber = ?
    `;
      const [phoneResults] = await db.query(checkPhoneNumberQuery, [
        newPnumber,
      ]);

      if (phoneResults.length > 0) {
        return res.status(409).send({ error: "Phone number already exists." });
      }

      const updatePhoneQuery = `
      UPDATE account 
      SET AccountPhoneNumber = ? 
      WHERE AccountId = ?
    `;
      const [updateResult] = await db.query(updatePhoneQuery, [
        sanitizeInput(newPnumber),
        req.session.user.id,
      ]);

      if (updateResult.affectedRows === 0) {
        return res
          .status(404)
          .send({ error: "Old account information is incorrect." });
      }

      const updateDeviceInfoQuery = `
      UPDATE deviceinformation 
      SET OwnerPhoneNumber = ? 
      WHERE OwnerPhoneNumber = ?
    `;
      await db.query(updateDeviceInfoQuery, [
        sanitizeInput(newPnumber),
        req.session.user.phone,
      ]);

      // Update the session phone
      req.session.user.phone = newPnumber;

      // Insert the activity into the activities table
      const activityQuery =
        'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "UPDATE PHONE NUMBER")';
      await db.query(activityQuery, [req.session.user.id]);

      res.send({ message: "Phone number updated successfully." });
    } catch (err) {
      console.error("Error updating phone number:", err);
      res.status(500).send({ error: "Error updating phone number." });
    }
  }
);
// API to update password
app.post("/api/account/update-password", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).send({ error: "Unauthorized" });
  }

  const { newPassword } = req.body;
  const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
  try {
    const query = "UPDATE account SET AccountPassword = ? WHERE AccountId = ?";
    await db.query(query, [hashedPassword, req.session.user.id]);

    // Insert the activity into the activities table
    const activityQuery =
      'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "UPDATE PASSWORD")';
    await db.query(activityQuery, [req.session.user.id]);

    res.json({ message: "Password updated successfully" });
  } catch (err) {
    console.error("Error updating password:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
// API for forgot password
app.post("/api/account/forgot-password", async (req, res) => {
  const { phone, newPassword } = req.body;

  try {
    const accountCheckQuery =
      "SELECT * FROM account WHERE AccountPhoneNumber = ?";
    const [rows] = await db.query(accountCheckQuery, [phone]);

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: "No account found with the provided phone number.",
      });
    }

    const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
    const updatePasswordQuery =
      "UPDATE account SET AccountPassword = ? WHERE AccountPhoneNumber = ?";
    await db.query(updatePasswordQuery, [hashedPassword, phone]);

    const activityQuery =
      'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "FORGOT PASSWORD")';
    await db.query(activityQuery, [rows[0].AccountId]);

    res.json({ success: true, message: "Password updated successfully" });
  } catch (err) {
    console.error("Error updating password:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// Updated /api/recover endpoint
app.post("/api/recover", async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  const { id, varHost, varIp, date } = req.body;

  if (!id || !varHost || !varIp || !date) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  try {
    const [checkResult] = await db.query(
      "SELECT * FROM hydroframe WHERE DeviceHostname = ? AND DeviceIpAddress = ? AND AccountId = ?",
      [varHost, varIp, req.session.user.id]
    );

    if (checkResult.length === 0) {
      const [archivedResult] = await db.query(
        "SELECT * FROM archive WHERE ArchiveId = ? AND DeviceHostname = ? AND DeviceIpAddress = ?",
        [id, varHost, varIp]
      );

      if (archivedResult.length === 1) {
        const resultData = archivedResult[0];
        const lday = resultData.ArchiveLastDay;
        const status = lday >= 60 ? "HARVEST" : "ONGOING";

        await db.query(
          "INSERT INTO hydroframe (DeviceHostname, DeviceIpAddress, HydroFrameStartDay, HydroFrameLastDay, HydroFrameStartDate, HydroFrameHarvestDate, HydroFrameStatus, AccountId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
          [
            resultData.DeviceHostname,
            resultData.DeviceIpAddress,
            resultData.ArchiveStartDay,
            resultData.ArchiveLastDay,
            resultData.ArchiveStartDate,
            resultData.ArchiveHarvestDate,
            status,
            req.session.user.id,
          ]
        );

        const [deleteResult] = await db.query(
          "DELETE FROM archive WHERE ArchiveId = ? AND DeviceHostname = ? AND DeviceIpAddress = ?",
          [id, varHost, varIp]
        );

        if (deleteResult.affectedRows > 0) {
          // Insert the activity into the activities table
          const activityQuery =
            'INSERT INTO useractivity (AccountId, Activity) VALUES (?, "RECOVER HYDRO FRAME")';
          await db.query(activityQuery, [req.session.user.id]);
          res
            .status(200)
            .json({ message: "Record recovered and inserted successfully" });
        } else {
          res.status(404).json({ error: "Record not found for deletion" });
        }
      } else {
        res.status(404).json({ error: "Record not found in archived" });
      }
    } else {
      res.status(400).json({ error: "Record already exists in display_bed" });
    }
  } catch (error) {
    console.error("Error executing query:", error);
    return res.status(500).json({ error: "Database error" });
  }
});
// API Notify user when there's a problem
app.post("/api/notify-anomaly", async (req, res) => {
  const { DeviceHostname, DeviceIpAddress, HydroFrameStartDate, phone } =
    req.body;

  if (!DeviceHostname || !DeviceIpAddress || !HydroFrameStartDate || !phone) {
    return res.status(400).json({ error: "All fields are required" });
  }

  try {
    // Convert current date to YYYY-MM-DD format in Manila time (GMT+8)
    const currentDate = convertToManilaTime(new Date().toISOString());

    const connection = await db.getConnection();

    try {
      // SQL query to select HydroFrameLastDay from the database
      const [rows] = await connection.query(
        "SELECT HydroFrameLastDay FROM hydroframe WHERE DeviceHostname = ? AND DeviceIpAddress = ? AND AccountId = ?",
        [DeviceHostname, DeviceIpAddress, req.session.user.id]
      );

      if (rows.length > 0) {
        const lastDay = rows[0].HydroFrameLastDay;

        // Check if HydroFrameLastDay is less than or equal to 60
        if (lastDay < 60) {
          const [tableCheck] = await connection.query("SHOW TABLES LIKE ?", [
            DeviceHostname,
          ]);

          if (tableCheck.length === 0) {
            return res.status(404).json({ error: "Table not found" });
          }

          const [results] = await connection.query(
            "SELECT * FROM ?? WHERE DeviceIpAddress = ? AND Date >= ? ORDER BY Id DESC",
            [DeviceHostname, DeviceIpAddress, HydroFrameStartDate]
          );

          if (results.length > 0) {
            const resultData = results[0];

            // Convert resultData.Date_Dev to Manila time (GMT+8)
            const resultDateDev = convertToManilaTime(resultData.Date);
            const resultTimeDev = formatTime(resultData.Time); // Format to HH:MM
            const currentManilaTime = getManilaTime(); // Format to HH:MM

            // Check if WaterTemperature is present and dates match
            if (
              resultData.WaterTemperature !== undefined &&
              (resultData.WaterTemperature < 20 ||
                resultData.WaterTemperature > 26) &&
              currentDate === resultDateDev &&
              currentManilaTime === resultTimeDev
            ) {
              const cropName = DeviceHostname;

              // Create SMS message for crops experiencing a temperature issue
              const message = `Caution! Your crop from "${cropName}" is experiencing a temperature issue. Please check your crop. The water temperature cannot be less than 21°C or more than 25°C. Date:${currentDate} Time:${resultTimeDev}`;

              // Log SMS details for debugging
              console.log("Sending SMS to:", phone);
              console.log("Message:", message);

              // Send SMS using Semaphore API
              await axios
                .post("https://api.semaphore.co/api/v4/messages", {
                  apikey: SEMAPHORE_API_KEY, // Use environment variable for API key
                  number: phone,
                  message: message,
                  sendername: "HydroMatic",
                })
                .catch((smsError) => {
                  console.error("Error sending SMS:", smsError);
                });
            }

            // Check if WaterLevel is present and dates match
            if (
              resultData.Wat !== undefined &&
              resultData.WaterLevel === "LOW" &&
              currentDate === resultDateDev &&
              currentManilaTime === resultTimeDev
            ) {
              const cropName = DeviceHostname;

              // Create SMS message for crops with low water level
              const message = `Caution! Please inspect your crop since the water level from your "${cropName}" is lower than usual. Date:${currentDate} Time:${resultTimeDev}`;

              // Log SMS details for debugging
              console.log("Sending SMS to:", phone);
              console.log("Message:", message);

              // Send SMS using Semaphore API
              await axios
                .post("https://api.semaphore.co/api/v4/messages", {
                  apikey: SEMAPHORE_API_KEY, // Use environment variable for API key
                  number: phone,
                  message: message,
                  sendername: "HydroMatic",
                })
                .catch((smsError) => {
                  console.error("Error sending SMS:", smsError);
                });
            }
          } else {
            console.error("No data found for the query:", selectQuery);
            return res
              .status(404)
              .json({ message: "No data found for the given criteria" });
          }
        } else {
          return res
            .status(404)
            .json({ message: "HydroFrameLastDay exceeds 60" });
        }
      } else {
        return res.status(404).json({ message: "Bed not found" });
      }
    } finally {
      connection.release(); // Release the connection back to the pool
    }
  } catch (err) {
    console.error("Error processing request:", err);
    return res.status(500).json({ error: "Server error" });
  }
});
// POST route to insert or check device info
app.post("/api/save_device_info", async (req, res) => {
  const {
    hostname = "",
    ip_address = "",
    fname = "",
    lname = "",
    pnum = "",
  } = req.body;

  // Validate input
  if (!hostname || !ip_address || !fname || !lname || !pnum) {
    return res
      .status(400)
      .send(
        "Hostname, IP address, first name, last name, and phone number are required."
      );
  }

  try {
    // Check if the record exists
    const [result] = await db.query(
      `SELECT * FROM deviceinformation WHERE DeviceHostname = ? AND DeviceIpAddress = ?`,
      [hostname, ip_address]
    );

    if (result.length === 0) {
      // Insert new record if it does not exist
      await db.query(
        `INSERT INTO deviceinformation (DeviceHostname, DeviceIpAddress, OwnerFirstname, OwnerLastname, OwnerPhoneNumber, DeviceStatus) VALUES (?, ?, ?, ?, ?, "ACTIVE")`,
        [hostname, ip_address, fname, lname, pnum]
      );
      res.send("New record created successfully.");
    } else {
      res.send("Record already exists.");
    }
  } catch (err) {
    console.error("Error executing query:", err);
    res.status(500).send("Error checking or saving the device info.");
  }
});
// POST route for inserting sensor data
app.post("/api/insert_data", async (req, res) => {
  const { temperature, water_level, ip_address, hostname } = req.body;

  if (!temperature || !water_level || !ip_address) {
    return res.status(400).send("Missing required data");
  }

  try {
    const [deviceInfo] = await db.query(
      `SELECT DeviceHostname FROM deviceinformation WHERE DeviceIpAddress = ?`,
      [ip_address]
    );

    let DeviceHostname;

    if (deviceInfo.length > 0) {
      DeviceHostname = deviceInfo[0].DeviceHostname;
    } else {
      DeviceHostname = hostname;
    }

    const [tableCheck] = await db.query(`SHOW TABLES LIKE ?`, [DeviceHostname]);

    if (tableCheck.length === 0) {
      await db.query(`
              CREATE TABLE ${DeviceHostname} (
                  Id INT(255) NOT NULL AUTO_INCREMENT,
                  DeviceIpAddress VARCHAR(50) NOT NULL,
                  WaterLevel VARCHAR(50) NOT NULL,
                  WaterTemperature VARCHAR(50) NOT NULL,
                  Date DATE NOT NULL,
                  Time TIME NOT NULL,
                  PRIMARY KEY (Id)
              );
          `);
      console.log(`Table ${DeviceHostname} created successfully`);
    }

    await db.query(
      `INSERT INTO ${DeviceHostname} (DeviceIpAddress, WaterLevel, WaterTemperature, Date, Time)
           VALUES (?, ?, ?, CURDATE(), CURTIME())`,
      [ip_address, temperature, water_level]
    );
    res.send("New record created successfully");
  } catch (err) {
    console.error("Error inserting data:", err);
    res.status(500).send("Error inserting data");
  }
});
// Middleware to check if user is logged in
const checkUserSession = (req, res, next) => {
  if (req.session.user) {
    next(); // Proceed to the next middleware or route handler if the user is logged in
  } else {
    res.redirect(`http://192.168.100.25:${PORT}/`); // Redirect to the landing page if not logged in as a user
  }
};
// API endpoint to check the session status
app.get("/api/check-session", (req, res) => {
  if (req.session.user || req.session.admin) {
    // If the user or admin session exists, the user is authenticated
    res.json({ isAuthenticated: true });
  } else {
    // If no session, the user is not authenticated
    res.json({ isAuthenticated: false });
  }
});

/*------------------------------------------------- ADMIN ------------------------------------------- */

// Admin Login
app.post("/admin-login", async (req, res) => {
  const { user, password } = req.body;
  try {
    // Query the database to verify the admin's email and password
    const [rows] = await db.execute(
      "SELECT * FROM admin WHERE AdminUsername = ? AND AdminPassword = ?",
      [user, password]
    );

    if (rows.length > 0) {
      // Set the admin session
      req.session.admin = { user: rows[0].Username };
      res.json({ message: "Login successful" });
    } else {
      res.status(401).json({ error: "Invalid email or password" });
    }
  } catch (error) {
    console.error("Database error:", error);
    res.status(500).json({ error: "An error occurred while logging in" });
  }
});
// Admin logout
app.post("/admin-logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ error: "Failed to log out" });
    }
    res.status(200).json({ message: "Admin logged out successfully" });
  });
});
// Route to get content data from the database
app.get("/api/Page-Content", async (req, res) => {
  const sql = "SELECT * FROM pagecontent";

  try {
    const [results] = await db.query(sql);
    console.log(results); // Log results to see what is returned
    if (results.length === 0) {
      return res.status(404).json({ error: "No content found" });
    }
    res.json(results);
  } catch (err) {
    console.error(err); // Log the error for debugging
    res.status(500).json({ error: "Failed to retrieve content" });
  }
});
// Route to save page content
app.post("/api/Save-Content", async (req, res) => {
  const updates = req.body; // Expecting an array of objects with tagId and tagContent

  try {
    // Iterate through each item and update in database (using a prepared statement for safety)
    const promises = updates.map((item) => {
      const sql =
        "UPDATE pagecontent SET tagContent = ? WHERE tagId = ? AND sectionId = ?";
      return db.query(sql, [item.tagContent, item.tagId, item.sectionId]);
    });

    await Promise.all(promises); // Wait for all updates to complete
    res.json({ message: "Content updated successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to update content" });
  }
});
// Route to get image content data from the database
app.get("/api/Image-Content", async (req, res) => {
  const sql = "SELECT * FROM pageimage"; // Adjust sectionId if needed

  try {
    const [results] = await db.query(sql);
    console.log(results); // Log results to see what is returned
    if (results.length === 0) {
      return res.status(404).json({ error: "No content found" });
    }
    res.json(results);
  } catch (err) {
    console.error(err); // Log the error for debugging
    res.status(500).json({ error: "Failed to retrieve content" });
  }
});
// Route to Save Image
app.post("/api/Save-Image", upload.single("imageUpload"), async (req, res) => {
  try {
    const { sectionId, imageId } = req.body; // Get sectionId and imageId from request body
    const imgData = req.file; // multer will add the uploaded file to req.file

    if (!imgData) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const src = `img/${imgData.filename}`;
    // Here you can perform your database update operation
    const sql =
      "UPDATE pageimage SET filename = ?, src = ? WHERE imageId = ? AND sectionId = ?";
    const result = await db.query(sql, [
      imgData.filename,
      src,
      imageId,
      sectionId,
    ]); // Perform your DB operation

    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ error: "Image not found or section ID invalid" });
    }

    return res.json({ message: "Image updated successfully" });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "Failed to update image", details: err.message });
  }
});
// PATCH endpoint to update user details
app.patch("/api/admin/updateUser/:id", async (req, res) => { // Add async here
  console.log(`Received request to update user with ID: ${req.params.id}`); // Log request
  console.log("Request body:", req.body); // Log request body

  const userId = req.params.id;
  const { AccountFirstname, AccountLastname, AccountPhoneNumber } = req.body;

  try {
    if (!AccountFirstname || !AccountLastname || !AccountPhoneNumber) {
      return res
        .status(400)
        .json({ success: false, error: "All fields are required" });
    }

    const sql = `UPDATE account SET AccountFirstname = ?, AccountLastname = ?, AccountPhoneNumber = ? WHERE AccountId = ?`;
    const [result] = await db.query(sql, [AccountFirstname, AccountLastname, AccountPhoneNumber, userId]); // Add userId to the parameters

    if (result.affectedRows > 0) {
      res.json({
        success: true,
        message: "Account details updated successfully.",
      });
    } else {
      res.status(404).json({ success: false, error: "Account not found." });
    }

  } catch (error) {
    console.error("Error updating Account:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// PATCH endpoint to update device details
app.patch("/api/admin/updateDevice/:deviceId", async (req, res) => {
  const { deviceId } = req.params;
  const {
    OwnerFirstname,
    OwnerLastname,
    OwnerPhoneNumber,
    DeviceHostname,
    DeviceIpAddress,
  } = req.body;

  try {
    // Validate inputs
    if (
      !OwnerFirstname ||
      !OwnerLastname ||
      !OwnerPhoneNumber ||
      !DeviceHostname ||
      !DeviceIpAddress
    ) {
      return res
        .status(400)
        .json({ success: false, error: "All fields are required." });
    }

    // Update query
    const query = ` UPDATE deviceinformation SET OwnerFirstname = ?, OwnerLastname = ?, OwnerPhoneNumber = ?, DeviceHostname = ?, DeviceIpAddress = ? WHERE DeviceId = ? `;
    const [result] = await db.query(query, [
      OwnerFirstname,
      OwnerLastname,
      OwnerPhoneNumber,
      DeviceHostname,
      DeviceIpAddress,
      deviceId,
    ]);

    if (result.affectedRows > 0) {
      res.json({
        success: true,
        message: "Device details updated successfully.",
      });
    } else {
      res.status(404).json({ success: false, error: "Device not found." });
    }
  } catch (error) {
    console.error("Error updating device:", error);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
app.patch("/api/admin/updateHydroFrame/:id", async (req, res) => {
  const hydroFrameId = req.params.id;
  const {
      DeviceHostname,
      DeviceIpAddress,
      HydroFrameStartDate,
      HydroFrameStartDay,
      HydroFrameLastDay,
      HydroFrameHarvestDate,
      HydroFrameStatus
  } = req.body;

  try {
      if (
          !DeviceHostname ||
          !DeviceIpAddress ||
          !HydroFrameStartDate ||
          !HydroFrameStartDay ||
          !HydroFrameLastDay ||
          !HydroFrameHarvestDate ||
          !HydroFrameStatus
      ) {
          return res.status(400).json({ success: false, error: "All fields are required" });
      }

      const sql = `UPDATE hydroframe SET 
          DeviceHostname = ?, 
          DeviceIpAddress = ?, 
          HydroFrameStartDate = ?, 
          HydroFrameStartDay = ?, 
          HydroFrameLastDay = ?, 
          HydroFrameHarvestDate = ?, 
          HydroFrameStatus = ? 
      WHERE HydroFrameId = ?`;

      const [result] = await db.query(sql, [
          DeviceHostname,
          DeviceIpAddress,
          HydroFrameStartDate,
          HydroFrameStartDay,
          HydroFrameLastDay,
          HydroFrameHarvestDate,
          HydroFrameStatus,
          hydroFrameId
      ]);

      if (result.affectedRows === 0) {
          return res.status(404).json({ success: false, error: "HydroFrame not found" });
      }

      res.json({ success: true, message: "HydroFrame updated successfully" });
  } catch (error) {
      console.error("Error updating HydroFrame:", error);
      res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
app.patch("/api/admin/updateArchive/:id", async (req, res) => {
  const ArchiveId = req.params.id;
  const {
      DeviceHostname,
      DeviceIpAddress,
      ArchiveStartDate,
      ArchiveStartDay,
      ArchiveLastDay,
      ArchiveHarvestDate,
      ArchiveStatus
  } = req.body;

  try {
      if (
          !DeviceHostname ||
          !DeviceIpAddress ||
          !ArchiveStartDate ||
          !ArchiveStartDay ||
          !ArchiveLastDay ||
          !ArchiveHarvestDate ||
          !ArchiveStatus
      ) {
          return res.status(400).json({ success: false, error: "All fields are required" });
      }

      const sql = `UPDATE archive SET 
          DeviceHostname = ?, 
          DeviceIpAddress = ?, 
          ArchiveStartDate = ?, 
          ArchiveStartDay = ?, 
          ArchiveLastDay = ?, 
          ArchiveHarvestDate = ?, 
          ArchiveStatus = ? 
      WHERE ArchiveId = ?`;

      const [result] = await db.query(sql, [
          DeviceHostname,
          DeviceIpAddress,
          ArchiveStartDate,
          ArchiveStartDay,
          ArchiveLastDay,
          ArchiveHarvestDate,
          ArchiveStatus,
          ArchiveId
      ]);

      if (result.affectedRows === 0) {
          return res.status(404).json({ success: false, error: "Archive not found" });
      }

      res.json({ success: true, message: "Archive updated successfully" });
  } catch (error) {
      console.error("Error updating Archive:", error);
      res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

// API to get the total user
app.get("/api/admin/TotalUser", async (req, res) => {
  try {
    const selectAll = "SELECT * FROM account";

    // Execute the query
    const [results] = await db.query(selectAll);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: "Database query error" });
  }
});
// API to get the total Device
app.get("/api/admin/TotalDevice", async (req, res) => {
  try {
    const selectAll = "SELECT * FROM deviceinformation";

    // Execute the query
    const [results] = await db.query(selectAll);

    // Get the total number of rows
    const totalRows = results.length;

    // Send the total as an object (key-value)
    res.json({ total: totalRows });
  } catch (err) {
    console.error("Database query error:", err);
    res.status(500).send({ error: "Database query error" });
  }
});
// API to display recently created account
app.get("/api/admin/new-users", async (req, res) => {
  try {
    // Query to get all new users from the account table
    const userQuery = "SELECT * FROM account ORDER BY AccountId DESC"; // Ensure this is the correct table and field names
    const [rows] = await db.query(userQuery);
    res.json({ success: true, users: rows }); // Ensure you are sending users
  } catch (err) {
    console.error("Error fetching user data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// API to display recently created account
app.get("/api/admin/users", async (req, res) => {
  try {
    // Query to get all new users from the account table
    const userQuery = "SELECT * FROM account"; // Ensure this is the correct table and field names
    const [rows] = await db.query(userQuery);
    res.json({ success: true, users: rows }); // Ensure you are sending users
  } catch (err) {
    console.error("Error fetching user data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// API to display recently created account
app.get("/api/admin/devices", async (req, res) => {
  try {
    // Query to get all new users from the account table
    const deviceQuery = "SELECT * FROM deviceinformation"; // Ensure this is the correct table and field names
    const [rows] = await db.query(deviceQuery);
    res.json({ success: true, device: rows }); // Ensure you are sending users
  } catch (err) {
    console.error("Error fetching user data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
app.get("/api/admin/hydroframe", async (req, res) => {
  try {
    // SQL query to join hydroframe and account tables on AccountId
    const query = `
      SELECT 
        h.*, 
        a.AccountFirstname, 
        a.AccountLastname, 
        a.AccountPhoneNumber 
      FROM hydroframe h
      INNER JOIN account a ON h.AccountId = a.AccountId
    `;

    const [results] = await db.query(query);

    res.json({ success: true, data: results }); // Send the joined data
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});

app.get("/api/admin/archive", async (req, res) => {
  try {
    // SQL query to join hydroframe and account tables on AccountId
    const query = `
      SELECT 
        ar.*, 
        ac.AccountFirstname, 
        ac.AccountLastname, 
        ac.AccountPhoneNumber 
      FROM archive ar
      INNER JOIN account ac ON ar.AccountId = ac.AccountId
    `;

    const [results] = await db.query(query);

    res.json({ success: true, data: results }); // Send the joined data
  } catch (err) {
    console.error("Error fetching data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// API to display user activities with account details
app.get("/api/admin/user-activities", async (req, res) => {
  try {
    // Query to join useractivity with account and get account details
    const activityQuery = `
      SELECT 
        useractivity.Activity, 
        useractivity.Date, 
        account.AccountFirstname, 
        account.AccountLastname, 
        account.AccountPhoneNumber 
      FROM useractivity
      JOIN account ON useractivity.AccountId = account.AccountId
      ORDER BY useractivity.Date DESC
    `;

    const [rows] = await db.query(activityQuery);
    res.json({ success: true, activities: rows });
  } catch (err) {
    console.error("Error fetching user activity data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// API to see device info
app.get("/api/admin/device-info", async (req, res) => {
  try {
    // Query to get all devices from the device_info table
    const deviceQuery = "SELECT * FROM deviceinformation";
    const [rows] = await db.query(deviceQuery);

    // Send the result back as JSON
    res.json({ success: true, devices: rows });
  } catch (err) {
    console.error("Error fetching device data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// API to see device info
app.get("/api/admin/hydro-frames", async (req, res) => {
  try {
    // Query to get all devices from the device_info table
    const deviceQuery = "SELECT * FROM hydroframe";
    const [rows] = await db.query(deviceQuery);

    // Send the result back as JSON
    res.json({ success: true, frames: rows });
  } catch (err) {
    console.error("Error fetching device data:", err);
    res.status(500).json({ success: false, error: "Internal Server Error" });
  }
});
// Middleware to check if admin is logged in
const checkAdminSession = (req, res, next) => {
  if (req.session.admin) {
    next(); // Proceed to the next middleware or route handler if the admin is logged in
  } else {
    res.redirect(`http://192.168.100.25:${PORT}/admin-login`); // Redirect to the landing page if not logged in as an admin
  }
};
// Handle admin-login.html
app.get("/admin-login", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-login.html"));
});
// Admin-protected routes
app.get("/admin-main", checkAdminSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-main.html"));
});
app.get("/admin-user", checkAdminSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-user.html"));
});
app.get("/admin-cms", checkAdminSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-cms.html"));
});
// Handle login.html
app.get("/login", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "login.html"));
});
// User-protected routes
app.get("/index", checkUserSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});
app.get('/dashboard', checkUserSession, (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'dashboard.html'));
});

app.get("/settings", checkUserSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "settings.html"));
});
app.get("/archive", checkUserSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "archive.html"));
});
app.get("/tables", checkUserSession, (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "tables.html"));
});
// Serve the home page
app.get("/", (req, res) => {
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
app.listen(PORT, '192.168.100.25', () => {
  console.log(`Server is running on http://192.168.100.25:${PORT}`);
});

/* ----------------------------------------------------Functions--------------------------------------------------------- */

// Function to sanitize input
function sanitizeInput(input) {
  return input.replace(/[^\w\s]/gi, ""); // Remove non-alphanumeric characters (except spaces)
}
// Utility function to convert database date to Manila time (GMT+8)
function convertToManilaTime(dateString) {
  const date = new Date(dateString);

  // Get the time in milliseconds and add 8 hours (8 * 60 * 60 * 1000 milliseconds)
  const manilaTime = new Date(date.getTime() + 8 * 60 * 60 * 1000);

  // Return only the date part in YYYY-MM-DD format
  return manilaTime.toISOString().split("T")[0];
}
function formatTime(timeInput) {
  // If timeInput is already in HH:MM format, return it as is
  if (
    typeof timeInput === "string" &&
    /^[0-2][0-3]:[0-5][0-9]$/.test(timeInput)
  ) {
    return timeInput; // Return the time in HH:MM format
  }

  // Handle if timeInput is a string in HH:mm:ss format
  if (
    typeof timeInput === "string" &&
    /^([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/.test(timeInput)
  ) {
    return timeInput.substring(0, 5); // Return only the HH:MM part
  }

  // Handle if timeInput is a Date object or timestamp
  const date = new Date(timeInput);
  if (isNaN(date)) {
    console.error("Invalid date:", timeInput); // Log invalid date
    return "00:00"; // Return a default value or handle as necessary
  }

  const hours = String(date.getHours()).padStart(2, "0"); // Get hours and pad with zero
  const minutes = String(date.getMinutes()).padStart(2, "0"); // Get minutes and pad with zero

  return `${hours}:${minutes}`; // Return time in HH:MM format
}
function getManilaTime() {
  const manilaOffset = 8 * 60; // Manila is GMT+8
  const localDate = new Date();
  const utcDate = new Date(
    localDate.getTime() + localDate.getTimezoneOffset() * 60000
  );
  const manilaTime = new Date(utcDate.getTime() + manilaOffset * 60000);

  const hours = String(manilaTime.getHours()).padStart(2, "0"); // Get hours and pad with zero
  const minutes = String(manilaTime.getMinutes()).padStart(2, "0"); // Get minutes and pad with zero

  return `${hours}:${minutes}`; // Return time in HH:MM format
}
