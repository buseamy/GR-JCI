<!DOCTYPE HTML>
<?php
/*
* @File Name:		header.php
* @Description: 	Header for the site
* @PHP version: 	Currently Unknown
* @Author(s):		Jacob Cole <colej28@ferris.edu>
* @Organization:	Ferris State University
* @Last updated:	02/05/2016
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

        <!--Page title for header file-->
        <title><?php echo $page_title; ?></title>

        <!--Stylesheets-->
       	<link rel="stylesheet" href="css/style.css">

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
                <li><a class="white" href="#">Login</a></li> <!--Login page-->

				<!--This section of code will make the Editor tab visible when the Editor logs in.
Can be changed to detect any session variable. It must be placed in the list for tabs.-->

				if($_SESSION['iseditor'] > -1) {
					<li><a class="white" href="editor_index.php">Editor</a></li> <!--Editor page-->
				}
			</ul>
        </nav>
        <body>
            <div id="main">
