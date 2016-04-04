<?php // This page allows the Editor to create user acounts. written by Jamal Ahmed and adapted by Jonathan Sankey code referred to was from Isys288 register.php

$page_title = 'Update E-mail Address';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database
	require ('../mysqli_connect.php');
	require('./include_utils/procedures.php');
    require ('./include_utils/email_functions.php');
		
	$errors = array(); // Initialize an error array.
	

	// checks if email matches
	if (isset($_POST['email'])) {
		if ($_POST['email'] != $_POST['email2']) {
			$errors[] = 'The E-mail addresses do not match.';
		} elseif (preg_match('/^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+(?:[a-zA-Z]{2}|aero|biz|com|coop|edu|gov|info|jobs|mil|mobi|museum|name|net|org|travel)$/i', $_POST['email'])) {
			$email = mysqli_real_escape_string($dbc, trim($_POST['email']));
		} else {
			$errors[] = 'The E-mail address must be in the format "someone@host.com".';
		}
	} else {
		$errors[] = 'You forgot to enter a new E-mail address.';
	}
	
	if (isset($_SESSION['id'])) {
        $uid = $_SESSION['id'];
	
	if (empty($errors)) { // If everything's OK.
	
		// Add the user in the database...
		
		// Make the query:
		$q_email = "Call spUpdateUserEmailAddress($uid, '$email');";
				
		// Run the query.
		if ($r_users = mysqli_query ($dbc, $q_email)) { // If it ran OK.
		
			// Finish sending data to database and print a success message:
			
			$row_everify = mysqli_fetch_array($r_users, MYSQLI_ASSOC);
			complete_procedure($dbc);
            
            // Send welcome E-mail for verification
            sendVerificationEmail($dbc, $uid, 2);
			
			echo '<p>The E-mail address has been successfully updated, please check your inbox for a verification message.</p><p><br /></p>';

		} else { // If it did not run OK.
			
			// Public message:
			echo '<h1>System Error</h1>
			<p class="error">user could not be created due to a system error.</p>'; 
			
			// Debugging message:
			echo '<p>' . mysqli_error($dbc) . '</p>';
						
		} // End of if ($r) IF.
		
		mysqli_close($dbc); // Close the database connection.

        //quit the script:
		exit();
	
	} else { // Report the errors.
	
		echo '<h1>Error!</h1>
		<p class="error">The following error(s) occurred:<br />';
		foreach ($errors as $msg) { // Print each error.
			echo " - $msg<br />\n";
		}
		echo '<p>Please try again.</p><p><br /></p>';
		
	} // End of if (empty($errors)) IF.
	
	mysqli_close($dbc); // Close the database connection.
}else {
	echo '<p>You must be logged in to change your E-mail. Please login and try again.</p><p><br /></p>';
}
}
?>

<!-- create the form-->
<h1>Create User</h1>
<form action="user_update_email.php" method="post">
	<p>New Email Address: <input type="text" name="email" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  /> </p>
	<p>Confirm New Email Address: <input type="text" name="email2" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  /> </p>
	<p><input type="submit" name="submit" value="Create User" /></p>
</form>
<a href="index.php" class="button">Cancel</a>