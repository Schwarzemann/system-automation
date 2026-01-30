<?php

// In case PHPMyAdmin shits the bed

$host = "localhost";
$user = "root";
$pass = "password";
$db   = "your_database";
$file = "your_dump.sql";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

$templine = '';
$lines = file($file);
foreach ($lines as $line) {
    if (substr($line, 0, 2) == '--' || $line == '') continue;
    $templine .= $line;
    if (substr(trim($line), -1, 1) == ';') {
        if (!$conn->query($templine)) echo 'Error: ' . $conn->error . "<br>";
        $templine = '';
    }
}
echo "Import completed";
$conn->close();
?>