<?php // Registration for all users written by Jamal Ahmed code referred to was from Isys288 register.php

$page_title = 'Register - SFCI - Journal for Critical Indicents';

// database connection is required for queries to be inserted in database
require ('../mysqli_connect.php');
require('./include_utils/procedures.php');
require ('./includes/header.php'); // Include the site header

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    require ('./include_utils/email_functions.php');

	$errors = array(); // Initialize an error array.

		// taken from jon's editor_create_user page
	if (strlen($_POST['pass1']) < 6 ) {
		$errors[] = 'The password must be at least 6 characters long.';
	}
	// if passwords not empty checks if password matches
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
	} else if (Is_numeric($_POST['city'])) {
		$errors[] = 'Your city should not contain numbers.';
	}  else {
		$city = mysqli_real_escape_string($dbc, trim($_POST['city']));
	}
	/*
	if (empty($_POST['state'])) {
		$state = null;
	} else if (Is_numeric($_POST['state'])) {
		$errors[] = 'Your state should not contain numbers.';
	} else {
		$state = mysqli_real_escape_string($dbc, trim($_POST['state']));
	}
	*/

	// only accepts numbers for input displays an error if anything else is entered
	if (empty($_POST['zip'])) {
		$zip = null;
	} else if (Is_numeric($_POST['zip'])){
		$zip = mysqli_real_escape_string($dbc, trim($_POST['zip']));
	}
	  else if(!Is_numeric($_POST['zip'])){
		$errors[] = 'Your zip code should only contain numbers.';
	  }

	if (empty($_POST['phone'])) {
		$phone = null;
	} else if (Is_numeric($_POST['phone'])) {
		$phone = mysqli_real_escape_string($dbc, trim($_POST['phone']));
	}
	  else if(!Is_numeric($_POST['phone'])){
		$errors[] = 'Your phone number should only contain numbers.';
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

		// check to see if address or phone number are primary.

		// if main is selected change the primary field to active in database

	if ($_POST['atype'] = 2){
		$aprime = 1;
	}
	if ($_POST['ptype'] = 2){
		$pprime = 1;
	}

	if (!empty($_POST['atype'])){
		$atypeID = mysqli_real_escape_string($dbc, trim($_POST['atype']));
	}
	if (!empty($_POST['ptype'])){
		$ptypeID = mysqli_real_escape_string($dbc, trim($_POST['ptype']));
	}

	/*
	$stateID = mysqli_real_escape_string($dbc, trim($_POST['state']));

	$countryID = mysqli_real_escape_string($dbc, trim($_POST['country']));
	*/
	if (empty($errors)) { // If everything's OK.

		// Add the user in the database...

		// Make the query:
		$q_users = "CALL spCreateUser('$email', '$password', '$firstname', '$lastname')";

		// Run the query.
		if ($r_users = mysqli_query ($dbc, $q_users)) { // If it ran OK.

			// Finish sending data to database and print a success message:

			$row_verify = mysqli_fetch_array($r_users, MYSQLI_ASSOC);
			$r_userID = $row_verify["UserID"];
			complete_procedure($dbc);
			if ((!empty($_post['address1'])) || (!empty($_post['address2']))) {
				$q_address = "CALL spCreateAddress('$r_userID', '$atypeID', '$address1', '$address2', '$city', '$stateID', '$zip', '$aprime')";
				mysqli_query ($dbc, $q_address);
			}
			complete_procedure($dbc);
			if (!empty($_post['phone'])){
				$q_phone = "CALL spCreatePhoneNumber('$r_userID', '$ptypeID', '$phone', '$pprime')";
				mysqli_query ($dbc, $q_phone);
			}

            // Send welcome E-mail for verification
            sendVerificationEmail($dbc, $r_userID, 1);

			echo '<p>You have successfully registered, please check your email for a verification message.</p><p><br /></p>';

		} else { // If it did not run OK.

			// Public message:
			echo '<h1>System Error</h1>
			<p class="error">You could not be registered due to a system error.</p>';

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
		echo '</p><p>Please try again.</p><p><br /></p>';

	} // End of if (empty($errors)) IF.

	mysqli_close($dbc); // Close the database connection.
}
?>


<!-- creating the form taken from Jonn Sankey -->
<div class="content">
	<img class="responsive" src="images/glasses.jpg" alt="reading glasses and book">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
			<div class="guest roundcorner">
            	<h3 class="title">Create an Account</h3>
            </div>
			<div class="box_guest guest_alt account">
                 <label for="first_name">First Name: <span class="required">*</span></label>
				 <input type="text" name="first_name" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['first_name'])) echo $_POST['first_name']; ?>" />
                 <br>
                 <label for="last_name">Last Name: <span class="required">*</span></label>
				 <input type="text" name="last_name" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['last_name'])) echo $_POST['last_name']; ?>" />
                 <br>
                 <label for="email">Email Address: <span class="required">*</span></label>
				 <input type="text" name="email" class="regular" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  />
                 <br>
				 <label for="email2">Confirm Email Address:<span class="required">*</span></label>
				 <input type="text" name="email2" class="regular" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  />
				 <br>
                <label for="pass1">Password: <span class="required">*</span></label>
				<input type="password" name="pass1" class="regular" size="10" maxlength="20"  />
				<br>
				<label for="pass2">Confirm Password: <span class="required">*</span></label>
				<input type="password" name="pass1" class="regular" size="10" maxlength="20"  />
				<br>
				<label for="address1">Street Address Line 1:</label>
				<input type="text" name="address1" class="regular" size="25" maxlength="50" value="<?php if (isset($_POST['address1'])) echo $_POST['address1']; ?>" />
				<br>
				<label for="address2">Street Address Line 2:</label>
				<input type="text" name="address2" class="regular" size="25" maxlength="50" value="<?php if (isset($_POST['address2'])) echo $_POST['address1']; ?>" />
				<br>
				<label for="city">City:</label>
				<input type="text" name="city" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>" />
				<br>
				<label for="state">State/province:</label>
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
				<br><br>
				<label for="zip">Postal code (zip):</label>
				<input type="text" name="zip" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>" />
				<br>
				<label for="atype">Address Type:</label>
				<?php
			    	$ATypes = mysqli_query($dbc, "Call spGetAddressTypes();");
			    	complete_procedure($dbc);

			    	echo '<select name="atype" class="regular">';
			        while($row = $ATypes->fetch_assoc()) {
			        	echo '<option value="' . $row["AddressTypeID"]. '">' . $row["AddressType"]. '</option>';
			        }
			    	echo '</select>';
			    ?>
				<br><br>
				<label for="phone">Phone Number:</label>
				<input type="text" name="phone" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['phone'])) echo $_POST['phone']; ?>" />
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
				<br><br>
				<label for="code">SCR Member ID:</label>
				<input type="text" name="code" class="regular" size="15" maxlength="40" value="<?php if (isset($_POST['code'])) echo $_POST['code']; ?>" />
				<br>
				<label for="association">Professional Association: (university, firm, etc.)</label>
				<input type="text" name="association" class="regular" size="25" maxlength="60" value="<?php if (isset($_POST['association'])) echo $_POST['association']; ?>" />
				<br>
				<p>*asterisk indicates a required field </p>
				<input type="submit" class="guest" name="submit" value="Register" />
            </div>
		</div>
		<?php require ('./includes/sidebar.php'); // Include the site sidebar ?>
	</div>
</div>
