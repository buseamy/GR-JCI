<!DOCTYPE HTML>
<?php
/*
* @File Name:		header.php
* @Description: 	Header for the site
* @PHP version: 	Currently Unknown
* @Author(s):		Jacob Cole <colej28@ferris.edu> Rui Takagi <takagir@ferris.edu>
* @Organization:	Ferris State University
* @Last updated:	03/13/2016
*/

/*
 * The purpose of this file is to display page title, meta information, include links to
 * style sheets, and contain the site navigation.
 */
 ?>
<html>
    <head>
        <!--Meta information-->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">

        <!--Page title from page-->
        <title><?php echo $page_title; ?></title>

        <!--Stylesheets-->
       	<link rel="stylesheet" href="css/style.css">
        <!--Scripts-->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    </head>
    <div id="container">
        <header id="header" class="span12">
                <div id="logo" class="span4">
                    <img src="images/jci_logo_red.png" alt="" class="jci_logo_red">
                    <img src="images/jci_logo_blue.png" alt="" class="jci_logo_blue">
                    <img src="images/jci_logo_yellow.png" alt="" class="jci_logo_yellow">
                </div>
                <a href="index.php"><h1 class="black span8">JCI Website</h1></a>
        </header>
        <nav id="navigation" class="span12">
			<ul>
                <li><a class="white" href="index.php">Home</a></li> <!--Home page-->
                <li><a class="white" href="#">Register</a></li> <!--Register page-->
                <li><a class="white" href="#">Contact us</a></li> <!--Contact page-->
				 <?php // Create a logout if logged in, creates login if logged out
				 session_start();
				 //Editor tab is displayed if the user is an editor
				if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1 ) {
					echo '<li><a class="white" href="logout.php">Logout</a></li>';
					echo '<li><a class="white" href="editor_index.php">Editor</a></li>' ;
				} else if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1){
					echo '<li><a class="white" href="logout.php">Logout</a></li>';
				} else if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
					echo '<li><a class="white" href="logout.php">Logout</a></li>';
				} else {
					echo '<li><a class="white" href="login_page.php">Login</a></li>';
				}
				?>

				<li><a class="white" href=" https://www.sfcr.org/">JCI Website</a></li> <!--Home page-->
				<li><a class="white" href="teaching_notes.php">Teaching Notes</a></li> <!--Home page-->
			</ul>
        </nav>
        <body>
            <div id="main">
