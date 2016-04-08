<?php 
// This page allows the user to change their email address
// written by Jon Sankey

$page_title = 'Update E-mail Address';

require ('./includes/header.php'); // Include the site header
require ('./includes/subnav.php'); // Dashboard navigation

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
	
        
	
	if (empty($errors)) { // If everything's OK.
	
		// Add the user in the database...
		$uid = $_SESSION['USERID'];
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
			echo '<h1 class="swatch alert_text">System Error</h1>
			<p class="swatch alert_text">user could not be created due to a system error.</p>'; 
			
			// Debugging message:
			echo '<p>' . mysqli_error($dbc) . '</p>';
						
		} // End of if ($r) IF.
		
		mysqli_close($dbc); // Close the database connection.

        //quit the script:
		exit();

}
?>

<!-- create the form-->
<?php if (isset($_SESSION['UserID'])) { // only display if logged in ?>
	<div class="contentwidth">
		<div class="row flush">
			<div class="col s7">
				<?php
				if (!empty($errors)) { // Report the errors.
					echo '<div>';
					echo '<h1 class="swatch alert_text">Error!</h1>
					<p><br><br>The following error(s) occurred:<br />';
					foreach ($errors as $msg) { // Print each error.
						echo " - $msg<br />\n";
					}
					echo '</p><p>Please try again.</p><p><br /></p>';
					echo '</div>';
				} // End of if (!empty($errors)).
				?>
				<div class="author roundcorner">
					<h3 class="title">Change E-mail</h3>
				</div>
				<div>
					<form action="user_update_email.php" method="post">
						<label for="email">New Email Address:  <span class="required"></span></label>
						<input type="text" name="email" class="regular" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  />
						<br>
						<label for="email2">Confirm New Email Address:  <span class="required"></span></label>
						<input type="text" name="email2" class="regular" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  />
						<br>
						<input type="submit" class="author" name="submit" value="Change E-mail" />
						<input class="alert" type="button" onclick="window.location.replace('index.php')" value="Cancel" />
					</form>
				</div>
			</div>
			<?php require ('./includes/sidebar.php'); // Include the site sidebar
		echo '</div>';
	echo '</div>';
} else { echo '<p class="swatch alert_text">Please login and try again</p>'; }
require ('./includes/footer.php'); ?>