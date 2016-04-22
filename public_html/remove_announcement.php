<?php $page_title = 'Remove Announcement';

// Written by: Jonathan Sankey on 4/15/2016
// This page removes announcements from the database
// It is accessed through the announcement managment page

require('./include_utils/login_functions.php'); //redirect

// Check for a valid announcement ID, through GET or POST:
if ( (isset($_GET['id'])) && (is_numeric($_GET['id'])) ) { // From announcement_management.php
	$id = $_GET['id'];
} elseif ( (isset($_POST['id'])) && (is_numeric($_POST['id'])) ) { // From announcement_management.php
	$id = $_POST['id'];
} else { // No valid ID, kill the script.
	echo '<p class="error">Announcement not found.</p>'; 
	exit();
}

require ('../mysqli_connect.php');

// Make the query:
$q = "CALL spRemoveAnnouncement('$id')";		
if (mysqli_query ($dbc, $q)) { // If it ran OK.	
	redirect_user('manage_announcements.php');
} else { // If the query did not run OK.
	echo '<p class="error">The user could not be deleted due to a system error.</p>'; // Public message.
	echo '<p>' . mysqli_error($dbc) . '</p>'; // Debugging message.
}

mysqli_close($dbc);
?>