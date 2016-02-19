<? // Registration for all users written by Jamal Ahmed code referred to was from Isys288 register.php

$page_title = 'Register';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database
	//require ('../../mysqli_connect.php');
		
	$errors = array(); // Initialize an error array.


	// modified from http://stackoverflow.com/questions/20910762/return-values-from-a-mysql-database-that-match-a-specific-php-variable
	// checks if username already exists
	/* Doesn't work
	$checkquery=("SELECT username FROM users WHERE username = '$username'");
	$result=mysqli_query($checkquery);
	if (!$result) {
		$errors[] = 'username or E-mail already exists.';
	}
	*/
	// checks if password matches
	if (!empty($_POST['pass1'])) {
	if ($_POST['pass1'] != $_POST['pass2']) {
		$errors[] = 'Your password did not match the confirmed password.';
	} else {
		$password = mysqli_real_escape_string($dbc, trim($_POST['pass1']));
	}
	} else {
		$errors[] = 'You forgot to enter your password.';
	}
	
	// checks if email matches
	if (!empty($_POST['email'])) {
	if ($_POST['email'] != $_POST['email2']) {
		$errors[] = 'Your E-mail addresses did not match.';
	} else {
		$email = mysqli_real_escape_string($dbc, trim($_POST['email']));
		}
	} else {
		$errors[] = 'You forgot to enter your E-mail address.';
	}
	// checks if email already exists
	/* Doesn't work 
	$checkquery1=("SELECT email FROM users WHERE email = '$e'");
	$result1=mysqli_query($checkquery1);
	if (!$result1) {
		$errors[] = 'username or E-mail already exists.';
	}
	*/
	
	// for check for numeric value refer to http://php.net/manual/en/function.is-numeric.php
	// check for first name
	if (empty($_POST['first_name'])) {
		$errors[] = 'You forgot to enter your first name.';
	} else if (Is_numeric($_POST['first_name'])) {
		$errors[] = 'Your name should not contain numbers.';
	}  else {
		$firstname = mysqli_real_escape_string($dbc, trim($_POST['first_name']));
	}
	
	// Check for a last name:
	if (empty($_POST['last_name'])) {
		$errors[] = 'You forgot to enter your last name.';
	} else if (Is_numeric($_POST['last_name'])) {
		$errors[] = 'Your name should not contain numbers.';
	}  else {
		$lastname = mysqli_real_escape_string($dbc, trim($_POST['last_name']));
	}
	
	// if no value is entered into box null value is inserted
	if (empty($_POST['address'])) {
		$address = null;
	} else {
		$address = mysqli_real_escape_string($dbc, trim($_POST['address']));
	}	

	if (empty($_POST['city'])) {
		$city = null;
	} else {
		$city = mysqli_real_escape_string($dbc, trim($_POST['city']));
	}	

	if (empty($_POST['state'])) {
		$state = null;
	} else {
		$state = mysqli_real_escape_string($dbc, trim($_POST['state']));
	}	

	if (empty($_POST['zip'])) {
		$zip = null;
	} else {
		$zip = mysqli_real_escape_string($dbc, trim($_POST['zip']));
	}	

	if (empty($_POST['phone'])) {
		$phone = null;
	} else {
		$phone = mysqli_real_escape_string($dbc, trim($_POST['phone']));
	}
	
	if (empty($_POST['code'])) {
		$code = null;
	} else {
		$code = mysqli_real_escape_string($dbc, trim($_POST['code']));
	}	
	
	if (empty($_POST['association'])) {
		$association = null;
	} else {
		$association = mysqli_real_escape_string($dbc, trim($_POST['association']));
	}	
	
	if (empty($errors)) { // If everything's OK.
	
		// Register the user in the database...
		
		// Make the query:
		$q = "INSERT INTO users (first_name, last_name, email, pass, registration_date) VALUES ('$fn', '$ln', '$e', SHA1('$p'), NOW() )";		
		$r = @mysqli_query ($dbc, $q); // Run the query.
		if ($r) { // If it ran OK.
		
			// Print a message:
			echo '
		<p>You are now registered.</p><p><br /></p>';	
		
		} else { // If it did not run OK.
			
			// Public message:
			echo '<h1>System Error</h1>
			<p class="error">You could not be registered due to a system error.</p>'; 
			
			// Debugging message:
			echo '<p>' . mysqli_error($dbc) . '<br /><br /></p>';
						
		} // End of if ($r) IF.
		
		// mysqli_close($dbc); // Close the database connection.

        //quit the script:
		exit();
		
	} else { // Report the errors.
	
		echo '<h1>Error!</h1>
		<p class="error">The following error(s) occurred:<br />';
		foreach ($errors as $msg) { // Print each error.
			echo " - $msg<br />\n";
		}
		echo '</p><p>Please try registering again.</p><p><br /></p>';
		
	} // End of if (empty($errors)) IF.
	
	mysqli_close($dbc); // Close the database connection.
}
?>


<h1>Register</h1>
<form action="register.php" method="post">
	<p>Email Address: <input type="text" name="email" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  /> </p>
	<p>Confirm Email Address: <input type="text" name="email2" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  /> </p>
	<p>Password: <input type="password" name="pass1" size="10" maxlength="20" value="<?php if (isset($_POST['pass1'])) echo $_POST['pass1']; ?>"  /></p>
	<p>Confirm Password: <input type="password" name="pass2" size="10" maxlength="20" value="<?php if (isset($_POST['pass2'])) echo $_POST['pass2']; ?>"  /></p>
	<p>First Name: <input type="text" name="first_name" size="15" maxlength="20" value="<?php if (isset($_POST['first_name'])) echo $_POST['first_name']; ?>" /></p>
	<p>Last Name: <input type="text" name="last_name" size="15" maxlength="40" value="<?php if (isset($_POST['last_name'])) echo $_POST['last_name']; ?>" /></p>
	<p>Street Address: <input type="text" name="address" size="25" maxlength="50" value="<?php if (isset($_POST['address'])) echo $_POST['address']; ?>" /></p>
	<p>City: <input type="text" name="city" size="15" maxlength="40" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>" /></p>
	<p>State: <input type="text" name="state" size="15" maxlength="40" value="<?php if (isset($_POST['state'])) echo $_POST['state']; ?>" /></p>
	<p>Zip: <input type="text" name="zip" size="15" maxlength="40" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>" /></p>
	<p>Phone Number: <input type="text" name="phone" size="15" maxlength="40" value="<?php if (isset($_POST['phone'])) echo $_POST['phone']; ?>" /></p>
	<p>Member Code: <input type="text" name="code" size="15" maxlength="40" value="<?php if (isset($_POST['code'])) echo $_POST['code']; ?>" /></p>
	<p>Professional Association: <input type="text" name="association" size="25" maxlength="60" value="<?php if (isset($_POST['association'])) echo $_POST['association']; ?>" /></p>
	<p><input type="submit" name="submit" value="Register" /></p>
</form>
