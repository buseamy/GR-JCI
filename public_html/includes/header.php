<?php session_start();

/*
 * The purpose of this file is to display page title, meta information, include links to
 * style sheets, and contain the site navigation.
 */
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
        		    <ul class="nav col s5">
        			    <li class=""><a href="#">Critical Incidents</a></li>
            			<li class=""><a href="#">Contact Us</a></li>
            			<li class=""><a href="account_settings.php">Account Settings</a></li>
                        <?php // Create a logout if logged in, creates login if logged out
           				 //Editor tab is displayed if the user is an editor
           				if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1 ) {
           					echo '<li><a id="togglelogin" href="#/">Logout</a></li>';
           				} else if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1){
           					echo '<li><a id="togglelogin" href="#/">Logout</a></li>';
           				} else if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
           					echo '<li><a id="togglelogin" href="#/">Logout</a></li>';
           				} else {
           					echo '<li><a id="togglelogin" href="#/">Login</a></li>';
           				}
           				?>
            		</ul>
        		    <div class="searchdiv col s3">
            			<form class="search-container" action="">
            			  <input id="search-box" type="text" class="search-box" placeholder="Search..." name="q" />
            			  <label for="search-box"><span class="glyphicon glyphicon-search search-icon"></span></label>
            			</form>
            		</div>
                </div>
                <div class="loginbar" style="display:none">
                    <form>
                	  <input type="text" class="regular login" placeholder="username"/>
                	  <input type="password" class="regular login" placeholder="password"/>
                	  <a href="template_dashboard.html"><button class="guest path" type="button">Login</button>
                	</form>
                	<a class="loginlink" href="template_create_account.html"><p>Don't have an account? Create one now.</p></a>
                </div>
                <div class="row flush">
                  <div class="col s3 searchdrop white">
                	  <div class="searchresult">
                		  <div class="result guest"></div>
                          <h4 class="searchheading">How to Page</h4>
                          <p class="searchsummary">The process of writing and submitting an incident, and the process to publishing.</p>
                	  </div>
                	  <div class="searchresult">
                		  <div class="result guest"></div>
                          <h4 class="searchheading">Create an Account</h4>
                          <p class="searchsummary">Make an account to submit critical incidents and get published.</p>
                	  </div>
                	  <div class="searchresult">
                		  <div class="result author"></div>
                          <h4 class="searchheading">Rules of Submission</h4>
                          <p class="searchsummary">The journal follows strict rules when compiling incidents for publishing.</p>
                	  </div>
                	  <div class="searchresult">
                		  <div class="result reviewer"></div>
                          <h4 class="searchheading">Reviewing Incidents</h4>
                          <p class="searchsummary">The journal follows strict review guidelines when sorting through incidents for publishing.</p>
                	  </div>
                  </div>
                </div>
            </header>
