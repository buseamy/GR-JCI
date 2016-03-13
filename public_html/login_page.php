<?php

/*
* @File Name:       login_page.php
* @Description:     
* @PHP version:     Currently Unknown
* @Author(s):	    Rui Takagi <takagir@ferris.edu>, Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/13/2016
*/



// Include the header:
$page_title = 'Login';
include ('includes/header.php');

// Print any error messages, if they exist:
if (isset($errors) && !empty($errors)) {

	echo '<h1>Error!</h1>
	<p class="error">The following error(s) occurred:<br />';
	foreach ($errors as $msg) {
		echo " - $msg<br />\n";
	}
	echo '</p><p>Please try again.</p>';
}

// Display the form:
?><h1>Login</h1>
<form action="login.php" method="post">
	<p><label>Username / Email Address: </label><input type="text" name="email" size="20" maxlength="60" /> </p>
	<p><label>Password: </label><input type="password" name="pass" size="20" maxlength="20" /></p>
	<p><input type="submit" name="submit" value="Login" /></p>
</form>

<?php include ('includes/footer.php'); ?>