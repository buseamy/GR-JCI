<?php 
/*
* @File Name:		logout.php
* @Description: 	Logout script that's based on the ISYS288 logout script, redirects the user after they logout 
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/

session_start(); // Access the existing session.
require('./include_utils/login_functions.php');

// If no session variable exists, redirect the user:
if (!isset($_SESSION['UserID'])) {

	// Need the functions:
	require ('include_utils/login_functions.php');
	redirect_user('index.php');	
	
} else { // Cancel the session:

	$_SESSION = array(); // Clear the variables.
	session_destroy(); // Destroy the session itself.
	setcookie ('PHPSESSID', '', time()-3600, '/', '', 0, 0); // Destroy the cookie.

}
       // Redirect:
       redirect_user('index.php');

// Set the page title and include the HTML header:
$page_title = 'Logged Out!';
include ('includes/header.php');

// Print a message
echo "
<div class=\"content\">
    <img class=\"responsive\" src=\"images/glasses.jpg\" alt=\"reading glasses and book\">
</div>
<div class=\"contentwidth\">
    <div class=\"row flush\">
        <div class=\"col s7\">
			<h1>Logged Out!</h1>
			<p>You are now logged out!</p>
		</div>";
require 'includes/sidebar.php'; // Include sidebar 		
echo "</div></div>";



?>

<?php
include ('./includes/footer.php');
?>