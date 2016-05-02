<?php

/*
* @File Name:       login_page.php
* @Description:     The login page that the user is redirected to if the user types in incorrect credentials in the header 
* @PHP version:     Currently Unknown
* @Author(s):	    Rui Takagi <takagir@ferris.edu>, Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/13/2016
*/
// Include the header:
$page_title = 'Login';
include ('includes/header.php');
?>
<div class="content">
    <img class="responsive" src="images/glasses.jpg" alt="reading glasses and book">
</div>
<?php
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
?>

<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
		<div class="guest roundcorner">
                <h3 class="title">Login</h3>
        </div>
				<form action="login.php" method="post">
					<p><label>Username / Email Address: </label><input type="text" name="email" size="20" maxlength="60" /> </p>
					<p><label>Password: </label><input type="password" name="pass" size="20" maxlength="20" /></p>
					<button class="guest" type="submit" value="Login" >Login</button>
				</form>
		</div>
		<?php require ('./includes/sidebar.php'); // Include the site sidebar ?>
	</div>
	
</div>

<?php include ('includes/footer.php'); ?>