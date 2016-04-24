<?php # Script 12.13 - loggedin.php #3

/*
* @File Name:		logged_in.php
* @Description: 	This page is displayed after the user logs in successfully
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/

/* This page is based on the logged_in script
 * from 'PHP and MySQL for Dynamic Websites'. 
 * The user is redirected here from login.php.
 **/
session_start(); // Start the session.

// If no session value is present, redirect the user:
// Also validate the HTTP_USER_AGENT!
if (!isset($_SESSION['agent']) OR ($_SESSION['agent'] != md5($_SERVER['HTTP_USER_AGENT']) )) {

	// Need the functions:
	require ('includes/login_functions2.php');
	redirect_user();	
}

// Set the page title and include the HTML header
$page_title = 'Logged In!';
include ('includes/header.php');
require ('./includes/subnav.php'); // Dashboard navigation

// Print a message
echo "
<div class=\"contentwidth\">
    <div class=\"row flush\">
        <div class=\"col s7\">
			<h1>Logged In</h1>
			<p>You are now logged in!</p>
			<p><a href=\"logout.php\">Logout</a></p>
		</div>";
		
require 'includes/sidebar.php'; // Include sidebar 		
echo "</div></div>";
include ('includes/footer.php');
?>

