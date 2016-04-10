<?php
/*
 * The purpose of this file is to display page title, meta information, include links to
 * style sheets, and contain the site navigation.
 */

if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}
 ?>
 <!DOCTYPE HTML>
<html>
    <head>
        <!--Meta information-->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!--Page title from page-->
        <title><?php echo $page_title; ?></title>

        <!--[if lt IE9]>
            <script src="http://html5shiv.googlecode.com/svn/trunk/html.js"></sript>
        <![endif]-->

        <!--Stylesheets
       	<link rel="stylesheet" href="css/style.css">-->
        <link href='https://fonts.googleapis.com/css?family=Titillium+Web:400,600,700,300' rel='stylesheet' type='text/css'>
	    <link rel="stylesheet" href="css/stylesheet.css" type="text/css">
        <link rel="stylesheet" href="css/global.css" type="text/css" media="screen">
        <link rel="stylesheet" href="css/glyphs.css" type="text/css" media="screen">

        <!--Scripts-->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    </head>
    <body class="loggedout">
    	<div class="pagewidth toppad">
            <header>
            	<div class="navbar row">
        			<a class="col s2 navbar-brand logotype alt_text active" href="index.php">Journal of<br> Critical Incidents</a>
        		    <ul class="nav col s8">
                        <?php // Create a logout if logged in, creates login if logged out
           				 //Editor tab is displayed if the user is an editor
           				if (isset($_SESSION['UserID'])) { //if logged in
                            echo '<li><a href="dashboard.php">Dashboard</a></li>';
                            echo '<li><a href="search_cases.php">Critical Incidents</a></li>';
                			echo '<li><a href="contact.php">Contact Us</a></li>';
                            echo '<li><a href="account_settings.php">Account Settings</a></li>';
							echo '<li><a href="editorial_policy.php">About</a></li>';
           					echo '<li><a href="logout.php">Logout</a></li>';
           				} else { //if logged out
                            echo '<li><a href="search_cases.php">Critical Incidents</a></li>';
                			echo '<li><a href="contact.php">Contact Us</a></li>';
							echo '<li><a href="editorial_policy.php">About</a></li>';
           					echo '<li><a id="togglelogin" href="login.php" onclick="return false;">Login</a></li>';
           				}?>
            		</ul>
                </div>
                <div class="loginbar" style="display:none">
                    <form action="login.php" method="post">
                	  <input type="text" class="regular login" name="email" placeholder="username"/>
                	  <input type="password" name="pass" class="regular login" placeholder="password"/>
                	  <input type="submit" name="submit" value="Login" />
                	  <!--<a href="login.php"><button class="guest path" type="button">Login</button>-->
                	</form>
                	<a class="loginlink" href="register.php"><p>Don't have an account? Create one now.</p></a>
                </div>
            </header>
