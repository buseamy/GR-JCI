<?php # Script 19.x - mysqli_connect.php
// This file contains the database access information. 
// This file also establishes a connection to MySQL 
// and selects the database.

// Set the database access information as constants:
DEFINE ('DB_USER', 'XamppUser'); // db_user
DEFINE ('DB_PASSWORD', 'XamppPassword'); // db_password
DEFINE ('DB_HOST', 'localhost'); // localhost, 127.0.0.1
DEFINE ('DB_NAME', 'gr_jci'); // db_name

// Make the connection:
$dbc = @mysqli_connect (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

// Make the connection:
$dbc = @mysqli_connect (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME) OR die ('Could not connect to MySQL: ' . mysqli_connect_error() );

// Set the encoding...
mysqli_set_charset($dbc, 'utf8');
?>