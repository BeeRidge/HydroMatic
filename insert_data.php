<?php
$servername = "localhost";
$username = "root"; // Default XAMPP username
$password = ""; // Default XAMPP password (empty)
$dbname = "lettucegrowth";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

if (isset($_POST['temperature']) && $_POST['water_level'] && $_POST['ip_address'] && $_POST['hostname']) {
    // Retrieve the data from the POST request
    $temperature = $_POST['temperature'];
    $water_level = $_POST['water_level'];
    $ip_address = $_POST['ip_address'];
    $hostname = $_POST['hostname'];

    // Corrected: Remove single quotes around $hostname
    $checkIp = "SELECT Var_Ip FROM $hostname WHERE Var_Ip = '$ip_address'";
    $resCheck = mysqli_query($conn, $checkIp);

    if (mysqli_num_rows($resCheck) == 0) {
        // Check if the table exists
        $tableCheckQuery = "SHOW TABLES LIKE '$hostname'";
        $result = mysqli_query($conn, $tableCheckQuery);

        if (mysqli_num_rows($result) == 0) {
            $createTableQuery = "
                CREATE TABLE $hostname (
                    Num_Id INT(255) NOT NULL AUTO_INCREMENT,
                    Var_Ip VARCHAR(50) NOT NULL,
                    Var_Temp VARCHAR(50) NOT NULL,
                    Var_WLvl VARCHAR(50) NOT NULL,
                    Date_Dev DATE NOT NULL,
                    Time_Dev TIME NOT NULL,
                    PRIMARY KEY (Num_Id)
                );
            ";
            if (mysqli_query($conn, $createTableQuery) === TRUE) {
                echo "Table $hostname created successfully";
            } else {
                echo "Error creating table: " . $conn->error;
            }
        }
    }
    
    // Corrected: Remove single quotes around $hostname
    $sql = "INSERT INTO $hostname (Var_Ip, Var_Temp, Var_WLvl, Date_Dev, Time_Dev) 
            VALUES ('$ip_address', '$temperature', '$water_level', CURDATE(), CURTIME())";

    if (mysqli_query($conn, $sql) === TRUE) {
        echo "New record created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    
} else {
    echo "Missing required POST data";
}

$conn->close();
