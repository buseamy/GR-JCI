<?php 
// This page allows the Editor to create user acounts. written by Jamal Ahmed and adapted by Jonathan Sankey code referred to was from Isys288 register.php
// This page uses preg_match to verify feilds. Documentation can be found at http://php.net/manual/en/function.preg-match.php

$page_title = 'Create User';
require ('./includes/header.php'); // Header
require ('./includes/subnav.php'); // Dashboard navigation
require ('../mysqli_connect.php'); // conect to database
require ('./include_utils/procedures.php'); // complete_procedure function

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database
	require ('./include_utils/email_functions.php');
		
	$errors = array(); // Initialize an error array.
	
	// checks that password is at least 6 characters long.
	if (strlen($_POST['pass1']) < 6 ) {
		$errors[] = 'The password must be at least 6 characters long.';
	}
	// checks if password matches
	if (!empty($_POST['pass1'])) {
		if ($_POST['pass1'] != $_POST['pass2']) {
			$errors[] = 'Your password did not match the confirmed password.';
		} else {
			$password = mysqli_real_escape_string($dbc, trim($_POST['pass1']));
		}
	} else {
		$errors[] = 'You forgot to enter a password.';
	}
	
	// checks if email matches
	if (!empty($_POST['email'])) {
		if ($_POST['email'] != $_POST['email2']) {
			$errors[] = 'The E-mail addresses do not match.';
		} elseif (preg_match('/^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+(?:[a-zA-Z]{2}|aero|biz|com|coop|edu|gov|info|jobs|mil|mobi|museum|name|net|org|travel)$/i', $_POST['email'])) {
			$email = mysqli_real_escape_string($dbc, trim($_POST['email']));
		} else {
			$errors[] = 'The E-mail address must be in the format "someone@host.com".';
		}
	} else {
		$errors[] = 'You forgot to enter an E-mail address.';
	}
	
	// check for first name
	if (empty($_POST['first_name'])) {
		$errors[] = 'You forgot to enter a first name.';
	} elseif (Is_numeric($_POST['first_name'])) {
		$errors[] = 'First names should not contain numbers.';
	}  else {
		$firstname = mysqli_real_escape_string($dbc, trim($_POST['first_name']));
	}
	
	// Check for a last name:
	if (empty($_POST['last_name'])) {
		$errors[] = 'You forgot to enter a last name.';
	} elseif (Is_numeric($_POST['last_name'])) {
		$errors[] = 'Last names should not contain numbers.';
	}  else {
		$lastname = mysqli_real_escape_string($dbc, trim($_POST['last_name']));
	}
	
	$stateID = mysqli_real_escape_string($dbc, trim($_POST['state']));
		
	// if no value is entered into box null value is inserted
	if (empty($_POST['address1'])) {
		$address1 = null;
	} else {
		$address1 = mysqli_real_escape_string($dbc, trim($_POST['address1']));
	}	
	
	if (empty($_POST['address2'])) {
		$address2 = null;
	} else {
		$address2 = mysqli_real_escape_string($dbc, trim($_POST['address2']));
	}	

	if (empty($_POST['city'])) {
		$city = null;
	} elseif (Is_numeric($_POST['city'])) {
		$errors[] = 'The city name should not contain numbers.';
	}  else {
		$city = mysqli_real_escape_string($dbc, trim($_POST['city']));
	}
	
	if (empty($_POST['zip'])) {
		$zip = null;
	}elseif (preg_match('/^[0-9]{5,5}([- ]?[0-9]{4,4})?$/', $_POST['zip'])) {
		$zip = mysqli_real_escape_string($dbc, trim($_POST['zip']));
	}else {
		$errors[] = 'Zip/postal codes should be formated as "#####".';
	}	

	if (($_POST['phone']) == '##########') {
		$phone = null;
	}elseif ((Is_numeric($_POST['phone'])) && (strlen($_POST['phone']) == 10 )) {
		$phone = mysqli_real_escape_string($dbc, trim($_POST['phone']));
	} else {
		$errors[] = 'Phone numbers should be formated "##########" and should ten digits long.';
	}

	
	if (!empty($_POST['code'])) {
		$code = mysqli_real_escape_string($dbc, trim($_POST['code']));
	} else {
		$code = null;
	}
	
	if (!empty($_POST['association'])) {
		if (Is_numeric($_POST['association'])) {
			$errors[] = 'Professional associations should not contain numbers.';
		} else {
			$association = mysqli_real_escape_string($dbc, trim($_POST['association']));
		}
	} else {
		$association = null;
	}
	
	$atype = $_POST['atype'];
	$ptype = $_POST['ptype'];
	
	if (empty($errors)) { // If everything's OK.
	
		// Add the user in the database...
		
		// Make the query:
		$q_users = "Call spEditorCreateUser('$email', '$password', '$firstname', '$lastname', '$association', '$code');";
				
		// Run the query.
		if ($r_users = mysqli_query ($dbc, $q_users)) { // If it ran OK.
		
			// Finish sending data to database and print a success message:
			
			$row_verify = mysqli_fetch_array($r_users, MYSQLI_ASSOC);
			$r_userID = $row_verify["UserID"];
		//	$r_everify = $row_verify["EmailVerificationGUID"];
			complete_procedure($dbc);
			
			// Send the users address information to the database
			if ((!empty($_post['address1'])) || (!empty($_post['address2']))) {
				$q_address = "CALL spCreateAddress('$r_userID', '$atype', '$address1', '$address2', '$city', '$stateID', '$zip', 1 )";
				mysqli_query ($dbc, $q_address);
				complete_procedure($dbc);
			}
			
			// Send the users phone information to the database.
			if (($_POST['phone']) != '##########'){
				$q_phone = "CALL spCreatePhoneNumber('$r_userID', '$ptype', '$phone', 1 )";
				mysqli_query ($dbc, $q_phone);
				complete_procedure($dbc);
			}
			
           
			if (!empty($_POST['checkeditor'])){
				$q_role = "Call spUserAddRole ($r_userID, 3);";
				mysqli_query ($dbc, $q_role);
				complete_procedure($dbc);
			}
			if (!empty($_POST['checkreviewer'])){
				$q_role = "Call spUserAddRole ($r_userID, 2);";
				mysqli_query ($dbc, $q_role);
				complete_procedure($dbc);
			}
            
            // Send welcome E-mail for verification
            sendNotificationEmail($dbc, $r_userID, $password);
		
			echo '<p>You have successfully created the user.</p><p><br /></p>';
			
		} else { // If it did not run OK.
			
			// DB error message:
			$errors[] = 'System error, failed to create account: '.mysqli_error($dbc);
						
		} // End of if ($r) IF.
		
		mysqli_close($dbc); // Close the database connection.
		
        //quit the script:
		exit();
	
	} 
	
}

?>
<!-- create the form-->
<?php if (isset($_SESSION['isEditor'])) { // Only display if logged in role is editor ?>
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
				<div class="editor roundcorner">
					<h3 class="title">Create User</h3>
				</div>
				<div>
					<form action="editor_create_user.php" method="post">
						<br>
						<label for="email">Email Address: <span class="required">*</span></label>
						<input type="text" name="email" class="regular" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  />
						<br>
						<label for="email2">Confirm Email Address: <span class="required">*</span></label>
						<input type="text" name="email2" class="regular" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  />
						<br>
						<label for="pass1">Password: (At least 6 characters long) <span class="required">*</span></label>
						<input type="password" name="pass1" class="regular" size="10" maxlength="20"  />
						<br>
						<label for="pass2">Confirm Password: <span class="required">*</span></label>
						<input type="password" name="pass2" class="regular" size="10" maxlength="20"  />
						<br>
						<label for="first_name">First Name: <span class="required">*</span></label>
						<input type="text" name="first_name" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['first_name'])) echo $_POST['first_name']; ?>" />
						<br>
						<label for="last_name">Last Name: <span class="required">*</span></label>
						<input type="text" name="last_name" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['last_name'])) echo $_POST['last_name']; ?>" />
						<br>
						<label for="association">Professional Association (Univercity, Firm, etc.): </label>
						<input type="text" name="association" class="regular" size="25" maxlength="60" value="<?php if (isset($_POST['association'])) echo $_POST['association']; ?>" />
						<br>
						<label for="address1">Street Address Line 1: </label>
						<input type="text" name="address1" class="regular" size="25" maxlength="50" value="<?php if (isset($_POST['address1'])) echo $_POST['address1']; ?>" />
						<br>
						<label for="address2">Street Address Line 2: </label>
						<input type="text" name="address2" class="regular" size="25" maxlength="50" value="<?php if (isset($_POST['address2'])) echo $_POST['address2']; ?>" />
						<br>
						<label for="city">City: </label>
						<input type="text" name="city" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>" />
						<br>
						<label for="state">State/province: </label>
						<?php
							//$States = mysqli_fetch_array(mysqli_query($dbc, "Call spGetStates();"), MYSQLI_ASSOC);
							$States = mysqli_query($dbc, "Call spGetStates();");
							complete_procedure($dbc);

							echo '<select name="state" class="regular">';
								while($row = $States->fetch_assoc()) {
									echo '<option value="' . $row["StateID"]. '">' . $row["FullStateName"]. '</option>';
								}
							echo '</select>';
						?>
						<br>
						<label for="zip">Postal code (zip): </label>
						<input type="text" name="zip" class="regular" size="5" maxlength="5" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>" />
						<br>
						<label for="atype">Address Type: </label>
						<?php
							$ATypes = mysqli_query($dbc, "Call spGetAddressTypes();");
							complete_procedure($dbc);

							echo '<select name="atype" class="regular">';
							while($row = $ATypes->fetch_assoc()) {
								echo '<option value="' . $row["AddressTypeID"]. '">' . $row["AddressType"]. '</option>';
							}
							echo '</select>';
						?>
						<br>
						<label for="phone">Phone Number: </label>
						<input type="text" name="phone" class="regular" size="10" maxlength="10" placeholder="##########" value="<?php if (isset($_POST['phone'])){ echo $_POST['phone']; } ?>" />
						<br>
						<label for="ptype">Phone Type:</label>
						<?php
						$PTypes = mysqli_query($dbc, "Call spGetPhoneTypes();");
						complete_procedure($dbc);

						echo '<select name="ptype" class="regular">';
							while($row = $PTypes->fetch_assoc()) {
								echo '<option value="' . $row["PhoneTypeID"]. '">' . $row["PhoneType"]. '</option>';
							}
						echo '</select>';
						?>
						<br>
						<label for="code">SCR Member ID: </label>
						<input type="text" name="code" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['code'])) echo $_POST['code']; ?>" />
						<br>
						<h5> Roles: </h5>
		<!--				<span class="jcf-checkbox jcf-unchecked">
						<span></span>
						<input id="checkeditor" style="margin: 0px; width: 100%; height: 100%; position: absolute; opacity: 0;" type="checkbox"></span>
						<label for="checkeditor" class="">Editor</label>
						<br>
						<span class="jcf-checkbox jcf-unchecked">
						<span></span>
						<input id="checkreviewer" style="margin: 0px; width: 100%; height: 100%; position: absolute; opacity: 0;" type="checkbox"></span>
						<label for="checkreviewer" class="">Reviewer</label>
						<br>
		-->				<div class="form-checkbox"><input type="checkbox" name="checkeditor"> Editor</div>
						<div class="form-checkbox"><input type="checkbox" name="checkreviewer"> Reviewer</div></p>
						<h5>*asterisk indicates a required field </h5>
						<input type="submit" class="editor" name="submit" value="Submit" />
					</form>
				</div>
			</div>
			<?php require ('./includes/sidebar.php'); // Include the site sidebar
		echo '</div>';
	echo '</div>';
} else { echo '<p class="swatch alert_text">Please login and try again</p>'; }
require ('./includes/footer.php'); ?>