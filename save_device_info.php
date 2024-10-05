<?php
// Database connection parameters
$servername = "localhost"; // Update with your server name
$username = "root"; // Update with your database username
$password = ""; // Update with your database password
$dbname = "lettucegrowth"; // Update with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve POST data
$hostname = isset($_POST['hostname']) ? $conn->real_escape_string($_POST['hostname']) : '';
$ip_address = isset($_POST['ip_address']) ? $conn->real_escape_string($_POST['ip_address']) : '';

$check = "SELECT * FROM device_info WHERE Var_Host = '$hostname' AND Var_Ip = '$ip_address'";
$resCheck = mysqli_query($conn, $check);

if (mysqli_num_rows($resCheck) == 0) {
    // SQL query to insert data into the database
    $sql = "INSERT INTO device_info (Var_Host, Var_Ip) VALUES ('$hostname', '$ip_address')";

    if ($conn->query($sql) === TRUE) {
        echo "New record created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
} 

// Close connection
$conn->close();
