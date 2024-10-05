const express = require("express");
const path = require("path");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
require("dotenv").config();
const axios = require("axios");
const app = express();
const PORT = process.env.PORT || 3000;
// Create a connection to the database
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "lettucegrowth",
});
// Connect to the database
db.connect((err) => {
  if (err) {
    console.error("Error connecting to the database:", err.stack);
    return;
  }
  console.log("Connected to the database");
});
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
app.post("/api/verify-otp", (req, res) => {
  const { phone, otp, password } = req.body;

  if (!phone || !otp || !password) {
    return res.status(400).json({ error: "Phone number, Password, and OTP are required" });
  }

  // Check if the provided OTP matches the stored one
  if (otpStorage[phone] && otpStorage[phone] == otp) {
    delete otpStorage[phone]; // Clear OTP after successful verification

    // Check if the user already exists in the database
    const select = 'SELECT * FROM account WHERE Acc_Pnumber = ? AND Acc_Password = ?';
    db.query(select, [phone, password], (err, results) => {
      if (err) {
        console.error("Error checking table:", err);
        return res.status(500).json({ error: "Error checking table" });
      }

      if (results.length === 0) {
        // User doesn't exist, insert into database
        const insertQuery = "INSERT INTO account (`Acc_Pnumber`, `Acc_Password`, `Acc_OTP`) VALUES (?, ?, ?)";
        db.query(insertQuery, [phone, password, otp], (err, insertResults) => {
          if (err) {
            console.error("Error inserting data:", err);
            return res.status(500).json({ error: "Error inserting data" });
          }
          res.status(200).json({ success: true, message: "Account created successfully!" });
        });
      } else {
        res.status(400).json({ error: "You've already created an account." });
      }
    });
  } else {
    res.status(400).json({ error: "Invalid OTP" });
  }
});
// Login API
app.post('/api/login', (req, res) => {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ error: 'Phone number and password are required' });
  }

  const query = 'SELECT * FROM account WHERE Acc_Pnumber = ? AND Acc_Password = ?';

  db.query(query, [phone, password], (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: 'Internal server error' });
    }

    if (results.length === 0) {
      return res.status(401).json({ error: 'Invalid phone number or password' });
    }

    res.status(200).json({ success: true, message: 'Login successful', user: results[0] });
  });
});
// Data for displaying the image and description of growth
app.get("/api/growthtimeline", (req, res) => {
  const query = "SELECT * FROM growthtimeline";
  db.query(query, (err, results) => {
    if (err) {
      console.error("Error fetching:", err);
      return res
        .status(500)
        .json({ error: "Error fetching data from database" });
    }
    console.log("Fetched results:", results);
    res.json(results);
  });
});
// Get all the data from table device info
app.get("/api/device_info", (req, res) => {
  const query = 'SHOW TABLES LIKE "device_info"';
  db.query(query, (err, results) => {
    if (err) {
      console.error("Error checking table:", err);
      return res.status(500).json({ error: "Error checking table" });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: "Table device_info not found" });
    }
    db.query("SELECT * FROM device_info", (err, results) => {
      if (err) {
        console.error("Error fetching data:", err);
        return res
          .status(500)
          .json({ error: "Error fetching data from database" });
      }
      res.json(results);
    });
  });
});
// Get all the data from table display bed
app.get("/api/display_bed", (req, res) => {
  const query = 'SHOW TABLES LIKE "display_bed"';
  db.query(query, (err, results) => {
    if (err) {
      console.error("Error checking table:", err);
      return res.status(500).json({ error: "Error checking table" });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: "Table display_bed not found" });
    }
    db.query("SELECT * FROM display_bed", (err, results) => {
      if (err) {
        console.error("Error fetching data:", err);
        return res
          .status(500)
          .json({ error: "Error fetching data from database" });
      }
      res.json(results);
    });
  });
});
// Get specific the data from table display bed
app.post("/api/display_table", (req, res) => {
  const { Var_Host, Var_Ip } = req.body;

  if (!Var_Host || !Var_Ip) {
    return res.status(400).json({ error: "Missing Var_Host or Var_Ip" });
  }

  const query = 'SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?';
  db.query(query, [Var_Host, Var_Ip], (err, results) => {
    if (err) {
      console.error("Error fetching data:", err);
      return res.status(500).json({ error: "Error fetching data from database" });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: "No data found for the given Var_Host and Var_Ip" });
    }
    res.json(results);
  });
});
// Get the data from spefic table Limit to 1
app.post("/api/send-Data", (req, res) => {
  console.log("Request received for /api/send-Data");
  const { Var_Host, Var_Ip } = req.body;

  console.log("Request body:", { Var_Host, Var_Ip });

  const query = "SHOW TABLES LIKE ?";
  db.query(query, [Var_Host], (err, results) => {
    if (err) {
      console.error("Error checking table:", err);
      return res.status(500).json({ error: "Error checking table" });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: "Table not found" });
    }

    const selectQuery =
      "SELECT * FROM ?? WHERE Var_Ip = ? ORDER BY Num_Id DESC LIMIT 1";
    db.query(selectQuery, [Var_Host, Var_Ip], (err, results) => {
      if (err) {
        console.error("Error fetching data:", err);
        return res
          .status(500)
          .json({ error: "Error fetching data from database" });
      }
      res.json(results);
    });
  });
});
// Displaying data logs on the table
app.post("/api/DataLogs", (req, res) => {
  const { Var_Host, Var_Ip, Start_Date } = req.body;

  console.log("Request body:", { Var_Host, Var_Ip, Start_Date });

  const query = "SHOW TABLES LIKE ?";
  db.query(query, [Var_Host], (err, results) => {
    if (err) {
      console.error("Error checking table:", err);
      return res.status(500).json({ error: "Error checking table" });
    }
    console.log("Results from SHOW TABLES LIKE:", results);
    if (results.length === 0) {
      return res.status(404).json({ error: "Table not found" });
    }

    const selectQuery =
      "SELECT * FROM ?? WHERE Var_Ip = ? AND Date_Dev >= ? ORDER BY Num_Id DESC";
    db.query(selectQuery, [Var_Host, Var_Ip, Start_Date], (err, results) => {
      if (err) {
        console.error("Error fetching data:", err);
        return res.status(500).json({ error: "Error fetching data from database" });
      }
      console.log("Data fetched from database:", results);
      res.json(results);
    });
  });
});
// Creating bed display
app.post("/api/add-bed-database", (req, res) => {
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

  // Check if the device already exists in display_bed
  const checkQuery = "SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?";
  db.query(checkQuery, [Var_Host, Var_Ip], (err, results) => {
    if (err) {
      console.error("Error checking table:", err);
      return res.status(500).json({ error: "Error checking table" });
    }

    if (results.length > 0) {
      // Device already exists
      console.error("Device with the same hostname or IP already exists");
      return res.status(409).json({ error: "Device with the same hostname or IP already exists" });
    }

    // Insert new bed
    const insertQuery = `
      INSERT INTO display_bed (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date) 
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    db.query(insertQuery, [Var_Host, Var_Ip, Last_Day, Last_Day, Start_Date, Harvest_Date], (err, result) => {
      if (err) {
        console.error("Error inserting data:", err);
        return res.status(500).json({ error: "Error inserting data into database" });
      }

      console.log("Bed inserted successfully!");
      return res.status(200).json({ message: "Bed inserted successfully!" });
    });
  });
});
// POST endpoint to remove a bed
app.post("/api/delete-device", (req, res) => {
  const { Var_Host } = req.body;

  if (!Var_Host) {
    return res.status(400).json({ message: "No hostname provided." });
  }
  let name, ip, sDay, lDay, sDate, hDate, stat;

  const select = "SELECT * FROM display_bed WHERE Var_Host = ?";
  db.query(select, [Var_Host], (err, res) => {
    if (err) {
      console.error(err);
    } else {
      // Assuming 'res' contains at least one row of data
      if (res.length > 0) {
        name = res[0].Var_Host;
        ip = res[0].Var_Ip;
        sDay = res[0].Start_Day;
        lDay = res[0].Last_Day;
        sDate = res[0].Start_Date;
        hDate = res[0].Harvest_Date;

        // Log the values to confirm
        console.log({ name, ip, sDay, lDay, sDate, hDate });
      } else {
        console.log("No data found for the given Var_Host");
      }
    }
  });

  // SQL query to delete a record
  const sql = "DELETE FROM display_bed WHERE Var_Host = ?";

  db.query(sql, [Var_Host], (err, result) => {
    if (err) {
      console.error("Error deleting bed:", err);
      return res
        .status(500)
        .json({ message: "Failed to delete the bed from the database." });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Bed not found." });
    }

    res.status(200).json({ message: "Bed successfully deleted." });

    if (lDay < 70) {
      stat = "REMOVED";
    } else {
      stat = "FINISHED";
    }
    const insert = `INSERT INTO archived (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date, Date_Archived, Status) 
      VALUES (?, ?, ?, ?, ?, ?, CURDATE(), ?)`;
    db.query(insert, [name, ip, sDay, lDay, sDate, hDate, stat], (err, res) => {
      if (err) {
        console.error("Error insertion:", err);
      }
      console.log("Insert Successful to archived");
    });
  });
});
// Endpoint to update the Last_Day and Last_Update_Date
app.post("/api/update-last-day", (req, res) => {
  const { Var_Host, Var_Ip, Start_Day, Start_Date, currentDate } = req.body;

  // SQL query to select Last_Day from the database
  const select = 'SELECT Last_Day FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?';
  db.query(select, [Var_Host, Var_Ip], (err, ress) => {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }

    // Check if ress is an array and has a valid result
    if (ress.length > 0) {
      const lastDay = ress[0].Last_Day;

      // Check if Last_Day is less than or equal to 70
      if (lastDay <= 70) {
        // SQL query to update the Last_Day and Update_Date using DATEDIFF
        const query = `
          UPDATE display_bed
          SET Last_Day = DATEDIFF(?, ?) + ? - 1, Update_Date = ?
          WHERE Var_Host = ? AND Var_Ip = ?
        `;

        db.query(
          query,
          [currentDate, Start_Date, Start_Day, currentDate, Var_Host, Var_Ip],
          (err, results) => {
            if (err) {
              return res.status(500).json({ error: err.message });
            }
            res.status(200).json({ message: "Update successful" });
          }
        );
      } else {
        return res.status(400).json({ message: "Last_Day exceeds 70" });
      }
    } else {
      res.status(404).json({ message: "Bed not found" });
    }
  });
});
// API for Dates
app.post("/api/dates", (req, res) => {
  console.log("Request body:", req.body);
  const { Var_Host, Var_Ip } = req.body;

  const query = `SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?`;
  db.query(query, [Var_Host, Var_Ip], (err, results) => {
    if (err) {
      console.error("Error fetching:", err);
      return res
        .status(500)
        .json({ error: "Error fetching data from database" });
    }
    console.log("Fetched results:", results);
    res.json(results);
  });
});
// API route for growth stages
app.get("/api/growth-stages", (req, res) => {
  const query = "SELECT * FROM growthtimeline";

  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: "Failed to fetch data" });
    }

    // Transform the database rows into the desired format
    const growthStages = results.map((row) => ({
      phase_name: row.phase_name,
      description: row.description,
      start_day: row.start_day,
      end_day: row.end_day,
    }));

    res.json(growthStages);
  });
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

    db.query(query, async (err, result) => {
      if (err) {
        console.error('Error executing query:', err);
        return res.status(500).json({ message: 'Database query error' });
      }

      // Log the result to check if crops are found
      console.log('Crops found with Last_Day between 60 and 70:', result);

      const crops = result;

      if (crops.length === 0) {
        return res.status(200).json({ message: 'No crops ready for harvest within the specified range or it already sent an SMS notification' });
      }

      // Loop through each crop and send SMS
      try {
        for (const crop of crops) {
          const cropName = crop.Var_Host; // Replace with actual crop name column if needed
          const lastDay = crop.Last_Day;  // Last_Day from database
          const harvestDate = crop.Harvest_Date; // Harvest date

          // Create SMS message for crops ready to harvest based on Last_Day
          const message = `Dear Farmer, your crop from "${cropName}" is ready to harvest. It has been growing for ${lastDay} days. Please harvest the crops until ${harvestDate}.`;

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
          const updateQuery = 'UPDATE display_bed SET Last_SMS_Date = CURDATE() WHERE Var_Host = ? AND Var_Ip = ?';
          await new Promise((resolve, reject) => {
            db.query(updateQuery, [crop.Var_Host, crop.Var_Ip], (updateErr, updateResult) => {
              if (updateErr) {
                console.error('Error updating Last_SMS_Date:', updateErr);
                return reject(updateErr);
              }
              resolve(updateResult);
            });
          });
        }

        // After sending all SMS, send a success response
        res.status(200).json({ message: 'SMS notifications sent successfully' });
      } catch (smsError) {
        console.error('Error sending SMS notifications:', smsError);
        res.status(500).json({ message: 'Error sending SMS notifications' });
      }
    });
  } catch (error) {
    console.error('Error in /api/notify-harvest:', error);
    res.status(500).json({ message: 'Error processing request' });
  }
});
// API to fetch all archived data
app.get('/api/archived', (req, res) => {
  const selectArchived = "SELECT * FROM archived ORDER BY Archive_Id DESC";
  db.query(selectArchived, (err, results) => {
    if (err) {
      return res.status(500).send({ error: 'Database query error' });
    }
    res.json(results); // Send the results as JSON
  });
});
// API Update accounts
app.post('/api/account', (req, res) => {
  console.log("Request body:", req.body);
  const { Acc_Pnumber, Acc_Password, old_Pnum, old_Pass } = req.body;

  // Validate input
  if (!Acc_Pnumber || !Acc_Password || !old_Pnum || !old_Pass) {
    return res.status(400).send({ error: 'All fields are required.' });
  }

  // SQL query to check if the new phone number already exists
  const checkPhoneNumberQuery = `SELECT * FROM account WHERE Acc_Pnumber = ?`;

  // Execute the query to check for existing phone number
  db.query(checkPhoneNumberQuery, [Acc_Pnumber], (err, results) => {
    if (err) {
      console.error('Error checking phone number:', err);
      return res.status(500).send({ error: 'Database error when checking phone number.' });
    }

    if (results.length > 0) {
      // If the phone number already exists, send an error response
      return res.status(409).send({ error: 'Phone number already exists.' });
    }

    // SQL query to update account where old phone number and old password match
    const updateAccountQuery = `
      UPDATE account 
      SET Acc_Pnumber = ?, Acc_Password = ? 
      WHERE Acc_Pnumber = ? AND Acc_Password = ?
    `;

    // Execute the query to update the account information
    db.query(updateAccountQuery, [Acc_Pnumber, Acc_Password, old_Pnum, old_Pass], (err, result) => {
      if (err) {
        console.error('Error updating account:', err);
        return res.status(500).send({ error: 'Error updating account information.' });
      }

      if (result.affectedRows === 0) {
        // If no rows were updated, it means the old phone number and password didn't match any record
        return res.status(404).send({ error: 'Old account information is incorrect.' });
      }

      // Send a success response
      res.send({ message: 'Account information updated successfully.' });
    });
  });
});
// API edit device name
app.post('/api/edit-name', (req, res) => {
  console.log("Request body:", req.body);
  const { newName, oldName } = req.body;

  if (!newName || !oldName) {
    return res.status(400).json({ error: "Both newName and oldName are required" });
  }

  // Check if a table with the new name already exists
  const checkNewNameQuery = 'SHOW TABLES LIKE ?';
  db.query(checkNewNameQuery, [newName], (err, newNameResults) => {
    if (err) {
      console.error("Error checking new table name:", err);
      return res.status(500).json({ error: "Database error" });
    }

    if (newNameResults.length > 0) {
      return res.status(409).json({ error: "A table with the new name already exists" }); // Conflict error
    }

    // Check if the old table exists
    const checkOldNameQuery = 'SHOW TABLES LIKE ?';
    db.query(checkOldNameQuery, [oldName], (err, oldNameResults) => {
      if (err) {
        console.error("Error checking old table:", err);
        return res.status(500).json({ error: "Database error" });
      }

      if (oldNameResults.length === 0) {
        return res.status(404).json({ error: "Old table not found" });
      }
      // Check if the old table exists
      const checkOldNameQuery = 'SELECT * FROM display_bed WHERE Var_Host = ?';
      db.query(checkOldNameQuery, [oldName], (err, oldNameResults) => {
        if (err) {
          console.error("Error checking old table:", err);
          return res.status(500).json({ error: "Database error" });
        }

        if (oldNameResults.length === 0) {
          return res.status(404).json({ error: "No 'BED' with same device info found" });
        }
        // Check if a record with newName already exists in device_info
        const checkDeviceInfoQuery = 'SELECT * FROM device_info WHERE Var_Host = ?';
        db.query(checkDeviceInfoQuery, [newName], (err, deviceInfoResults) => {
          if (err) {
            console.error("Error checking device_info:", err);
            return res.status(500).json({ error: "Database error" });
          }

          if (deviceInfoResults.length > 0) {
            return res.status(409).json({ error: "A device with the new name already exists in device_info" }); // Conflict error
          }

          // Rename the table
          const renameTableQuery = `RENAME TABLE \`${oldName}\` TO \`${newName}\``;
          db.query(renameTableQuery, (err) => {
            if (err) {
              console.error("Error renaming table:", err);
              return res.status(500).json({ error: "Error renaming table" });
            }

            // Update Var_Host in device_info
            const updateDeviceInfoQuery = 'UPDATE device_info SET Var_Host = ? WHERE Var_Host = ?';
            db.query(updateDeviceInfoQuery, [newName, oldName], (err) => {
              if (err) {
                console.error("Error updating data in device_info:", err);
                return res.status(500).json({ error: "Error updating device info" });
              }

              const updateDeviceInfoQuery = 'UPDATE display_bed SET Var_Host = ? WHERE Var_Host = ?';
              db.query(updateDeviceInfoQuery, [newName, oldName], (err) => {
                if (err) {
                  console.error("Error updating data in device_info:", err);
                  return res.status(500).json({ error: "Error updating device info" });
                }

                console.log("Update successfully");
                res.status(200).json({ message: "Device name updated successfully" });
              });
            });
          });
        });
      });
    });
  });
});
// API to edit device IP address
app.post('/api/edit-ip', (req, res) => {
  console.log("Request body:", req.body);
  const { newip, oldip, hostname } = req.body;

  if (!newip || !oldip || !hostname) {
    return res.status(400).json({ error: "All data fields are required" });
  }

  // Check if the old IP exists in the hostname's table
  const checkOldIpQuery = `SELECT * FROM \`${hostname}\` WHERE Var_Ip = ?`;
  db.query(checkOldIpQuery, [oldip], (err, oldIpResults) => {
    if (err) {
      console.error("Error checking old IP in the table:", err);
      return res.status(500).json({ error: "Database error" });
    }

    if (oldIpResults.length === 0) {
      return res.status(404).json({ error: "Old IP not found in the specified table" });
    }

    // Check if the new IP already exists in the hostname's table
    const checkNewIpQuery = `SELECT * FROM \`${hostname}\` WHERE Var_Ip = ?`;
    db.query(checkNewIpQuery, [newip], (err, newIpResults) => {
      if (err) {
        console.error("Error checking new IP in the table:", err);
        return res.status(500).json({ error: "Database error" });
      }

      if (newIpResults.length > 0) {
        return res.status(409).json({ error: "New IP already exists in the specified table" });
      }

      // Check if the new IP exists in `device_info`
      const checkDeviceInfoQuery = 'SELECT * FROM device_info WHERE Var_Ip = ?';
      db.query(checkDeviceInfoQuery, [newip], (err, deviceInfoResults) => {
        if (err) {
          console.error("Error checking new IP in device_info:", err);
          return res.status(500).json({ error: "Database error" });
        }

        if (deviceInfoResults.length > 0) {
          return res.status(409).json({ error: "New IP already exists in device_info" });
        }

        // Check if the old IP exists in `display_bed`
        const checkOldBedIpQuery = 'SELECT * FROM display_bed WHERE Var_Ip = ?';
        db.query(checkOldBedIpQuery, [oldip], (err, oldBedIpResults) => {
          if (err) {
            console.error("Error checking old IP in display_bed:", err);
            return res.status(500).json({ error: "Database error" });
          }

          if (oldBedIpResults.length === 0) {
            return res.status(404).json({ error: "Old IP not found in display_bed" });
          }

          // Check if the new IP exists in `display_bed`
          const checkNewBedIpQuery = 'SELECT * FROM display_bed WHERE Var_Ip = ?';
          db.query(checkNewBedIpQuery, [newip], (err, newBedIpResults) => {
            if (err) {
              console.error("Error checking new IP in display_bed:", err);
              return res.status(500).json({ error: "Database error" });
            }

            if (newBedIpResults.length > 0) {
              return res.status(409).json({ error: "New IP already exists in display_bed" });
            }

            // If all checks pass, proceed to update IP in all tables
            const updateTableIpQuery = `UPDATE \`${hostname}\` SET Var_Ip = ? WHERE Var_Ip = ?`;
            db.query(updateTableIpQuery, [newip, oldip], (err) => {
              if (err) {
                console.error("Error updating IP in the table:", err);
                return res.status(500).json({ error: "Error updating IP in the table" });
              }

              const updateDeviceInfoIpQuery = 'UPDATE device_info SET Var_Ip = ? WHERE Var_Ip = ?';
              db.query(updateDeviceInfoIpQuery, [newip, oldip], (err) => {
                if (err) {
                  console.error("Error updating IP in device_info:", err);
                  return res.status(500).json({ error: "Error updating IP in device_info" });
                }

                const updateBedIpQuery = 'UPDATE display_bed SET Var_Ip = ? WHERE Var_Ip = ?';
                db.query(updateBedIpQuery, [newip, oldip], (err) => {
                  if (err) {
                    console.error("Error updating IP in display_bed:", err);
                    return res.status(500).json({ error: "Error updating IP in display_bed" });
                  }

                  console.log("IP update successful across all tables");
                  return res.status(200).json({ message: "IP address updated successfully" });
                });
              });
            });
          });
        });
      });
    });
  });
});
// API update bed
app.post('/api/update-bed', (req, res) => {
  // Extract data from the request body
  const { Var_Host, Var_Ip, Last_Day, Start_Date } = req.body;

  // Log the incoming request for debugging
  console.log('Request body:', { Var_Host, Var_Ip, Last_Day, Start_Date });

  // Validate that all required fields are present
  if (!Var_Host || !Var_Ip || !Last_Day || !Start_Date) {
    return res.status(400).json({ error: 'All fields (Var_Host, Var_Ip, Last_Day, Start_Date) are required.' });
  }

  // Define the SQL query to update the bed information
  const updateBedQuery = `
      UPDATE display_bed
      SET Start_Day = ?, Start_Date = ?
      WHERE Var_Host = ? AND Var_Ip = ?
  `;

  // Execute the query to update the bed information
  db.query(updateBedQuery, [Last_Day, Start_Date, Var_Host, Var_Ip], (err, result) => {
    if (err) {
      console.error('Error updating bed information:', err);
      return res.status(500).json({ error: 'Error updating bed information.' });
    }

    // Check if any row was affected (updated)
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'No bed found with the specified Host and IP.' });
    }

    // Send a success response
    res.json({ message: 'Bed information updated successfully.' });
  });
});
// API removing from archive
app.post('/api/remove', (req, res) => {
  console.log("Request body:", req.body);
  const { id, varHost, varIp, date } = req.body;

  // Check if all required fields are provided
  if (!id || !varHost || !varIp || !date) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Convert the date from MM-DD-YYYY to YYYY-MM-DD
  const dateParts = date.split('-');
  if (dateParts.length !== 3) {
    return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
  }

  // Reformat the date to YYYY-MM-DD
  const formattedDate = `${dateParts[2]}-${dateParts[0]}-${dateParts[1]}`;

  // Validate the reformatted date
  const isValidDate = /^\d{4}-\d{2}-\d{2}$/.test(formattedDate);
  if (!isValidDate) {
    return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
  }

  const query = "DELETE FROM archived WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?";

  // Execute the query using the formatted date
  db.query(query, [id, varHost, varIp, formattedDate], (error, results) => {
    if (error) {
      console.error('Error executing query:', error);
      return res.status(500).json({ error: 'Database error' });
    }

    if (results.affectedRows > 0) {
      res.status(200).json({ message: 'Record removed successfully' });
    } else {
      res.status(404).json({ error: 'Record not found' });
    }
  });
});
//API recover from archive
app.post('/api/recover', (req, res) => {
  console.log("Request body:", req.body);
  const { id, varHost, varIp, date } = req.body;

  // Check if all required fields are provided
  if (!id || !varHost || !varIp || !date) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Convert the date from MM-DD-YYYY to YYYY-MM-DD
  const dateParts = date.split('-');
  if (dateParts.length !== 3) {
    return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
  }

  // Reformat the date to YYYY-MM-DD
  const formattedDate = `${dateParts[2]}-${dateParts[0]}-${dateParts[1]}`;

  // Validate the reformatted date
  const isValidDate = /^\d{4}-\d{2}-\d{2}$/.test(formattedDate);
  if (!isValidDate) {
    return res.status(400).json({ error: 'Invalid date format. Use MM-DD-YYYY.' });
  }

  const check = "SELECT * FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?";
  db.query(check, [varHost, varIp], (error, checkResult) => {
    if (error) {
      console.error('Error executing query:', error);
      return res.status(500).json({ error: 'Database error' });
    }

    // If no record is found in display_bed, proceed to archived table
    if (checkResult.length == 0) {
      const select = "SELECT * FROM archived WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?";
      db.query(select, [id, varHost, varIp, formattedDate], (err, archivedResult) => {
        if (err) {
          console.error('Error executing query:', err);
          return res.status(500).json({ error: 'Database error' });
        }

        // Check if the record exists in archived
        if (archivedResult.length === 1) {
          const resultData = archivedResult[0]; // Get the first record from the result

          // Insert the data into display_bed
          const insert = "INSERT INTO display_bed (Var_Host, Var_Ip, Start_Day, Last_Day, Start_Date, Harvest_Date) VALUES (?, ?, ?, ?, ?, ?)";
          db.query(insert, [resultData.Var_Host, resultData.Var_Ip, resultData.Start_Day, resultData.Last_Day, resultData.Start_Date, resultData.Harvest_Date], (insertErr, insertRes) => {
            if (insertErr) {
              console.error('Error executing insert query:', insertErr);
              return res.status(500).json({ error: 'Database error' });
            }

            // After inserting, delete the record from archived
            const deleteQuery = "DELETE FROM archived WHERE Archive_Id = ? AND Var_Host = ? AND Var_Ip = ? AND Date_Archived = ?";
            db.query(deleteQuery, [id, varHost, varIp, formattedDate], (deleteErr, deleteResult) => {
              if (deleteErr) {
                console.error('Error executing delete query:', deleteErr);
                return res.status(500).json({ error: 'Database error' });
              }

              if (deleteResult.affectedRows > 0) {
                res.status(200).json({ message: 'Record recovered and inserted successfully' });
              } else {
                res.status(404).json({ error: 'Record not found for deletion' });
              }
            });
          });
        } else {
          res.status(404).json({ error: 'Record not found in archived' });
        }
      });
    } else {
      res.status(400).json({ error: 'Record already exists in display_bed' });
    }
  });
});
// API Notify user when theres a problem
app.post("/api/notify-anomaly", (req, res) => {
  const { Var_Host, Var_Ip, Start_Date, phone } = req.body;

  // Convert current date to YYYY-MM-DD format in Manila time (GMT+8)
  const currentDate = convertToManilaTime(new Date().toISOString());

  // SQL query to select Last_Day from the database
  const select = 'SELECT Last_Day FROM display_bed WHERE Var_Host = ? AND Var_Ip = ?';
  db.query(select, [Var_Host, Var_Ip], (err, ress) => {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }

    // Check if ress is an array and has a valid result
    if (ress.length > 0) {
      const lastDay = ress[0].Last_Day;

      // Check if Last_Day is less than or equal to 60
      if (lastDay < 60) {
        const show = "SHOW TABLES LIKE ?";
        db.query(show, [Var_Host], (err, results) => {
          if (err) {
            console.error("Error checking table:", err);
            return res.status(500).json({ error: "Error checking table" });
          }
          console.log("Results from SHOW TABLES LIKE:", results);
          if (results.length === 0) {
            return res.status(404).json({ error: "Table not found" });
          }

          const selectQuery = "SELECT * FROM ?? WHERE Var_Ip = ? AND Date_Dev >= ? ORDER BY Num_Id DESC";
          db.query(selectQuery, [Var_Host, Var_Ip, Start_Date], (err, results) => {
            if (err) {
              console.error("Error fetching data:", err);
              return res.status(500).json({ error: "Error fetching data from database" });
            }

            console.log("Data fetched from database:", results);

            // Ensure there is at least one result
            if (results.length > 0) {
              const resultData = results[0];

              // Convert resultData.Date_Dev to Manila time (GMT+8)
              const resultDateDev = convertToManilaTime(resultData.Date_Dev);
              console.log(resultDateDev, currentDate);

              // Check if Var_Temp is present and dates match
              if (resultData.Var_Temp !== undefined && (resultData.Var_Temp < 21 || resultData.Var_Temp > 25) && currentDate === resultDateDev) {
                const cropName = Var_Host;

                // Create SMS message for crops experiencing a temperature issue
                const message = `Caution! Your crop from "${cropName}" is experiencing a temperature issue. Please check your crop. The water temperature cannot be less than 21°C or more than 25°C. ${currentDate}`;

                // Log SMS details for debugging
                console.log('Sending SMS to:', phone);
                console.log('Message:', message);

                // Send SMS using Semaphore API
                axios.post('https://api.semaphore.co/api/v4/messages', {
                  apikey: SEMAPHORE_API_KEY,
                  number: phone,
                  message: message,
                  sendername: "HydroMatic",
                }).catch(smsError => {
                  console.error('Error sending SMS:', smsError);
                });
              }

              // Check if Var_WLvl is present and dates match
              if (resultData.Var_WLvl !== undefined && resultData.Var_WLvl === 'LOW' && currentDate === resultDateDev) {
                const cropName = Var_Host;

                // Create SMS message for crops with low water level
                const message = `Caution! Please inspect your crop since the water level from your "${cropName}" is lower than usual. ${currentDate}`;

                // Log SMS details for debugging
                console.log('Sending SMS to:', phone);
                console.log('Message:', message);

                // Send SMS using Semaphore API
                axios.post('https://api.semaphore.co/api/v4/messages', {
                  apikey: SEMAPHORE_API_KEY,
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
          });
        });
      } else {
        return res.status(400).json({ message: "Last_Day exceeds 60" });
      }
    } else {
      return res.status(404).json({ message: "Bed not found" });
    }
  });
});
// Handle index.html
app.get("/index.html", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});
// Handle settings.html
app.get("/settings.html", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "settings.html"));
});
// Handle archive.html
app.get("/archive.html", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "archive.html"));
});
// Handle tables.html
app.get("/tables.html", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "tables.html"));
});
// Serve admin content HTML file
app.get("/admin-content", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "admin-content.html"));
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


