<?php // Registration for all users written by Jamal Ahmed code referred to was from Isys288 register.php

$page_title = 'Register User - SFCI - Journal for Critical Indicents';
	
// database connection is required for queries to be inserted in database
require ('../mysqli_connect.php');
require('./include_utils/procedures.php');

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
<h1>Register</h1>

<form action="register.php" method="post">
	<p>Email Address*: <input type="text" name="email" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  /> </p>
	<p>Confirm Email Address*: <input type="text" name="email2" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  /> </p>
	<p>Password*: <input type="password" name="pass1" size="10" maxlength="20"  /></p>
	<p>Confirm Password*: <input type="password" name="pass2" size="10" maxlength="20"  /></p>
	<p>First Name*: <input type="text" name="first_name" size="15" maxlength="40" value="<?php if (isset($_POST['first_name'])) echo $_POST['first_name']; ?>" /></p>
	<p>Last Name*: <input type="text" name="last_name" size="15" maxlength="40" value="<?php if (isset($_POST['last_name'])) echo $_POST['last_name']; ?>" /></p>
	<p>Street Address Line 1: <input type="text" name="address1" size="25" maxlength="50" value="<?php if (isset($_POST['address1'])) echo $_POST['address1']; ?>" /></p>
	<p>Street Address Line 2: <input type="text" name="address2" size="25" maxlength="50" value="<?php if (isset($_POST['address2'])) echo $_POST['address2']; ?>" /></p>
	<p>City: <input type="text" name="city" size="15" maxlength="40" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>" /></p>
	<p>State/province: 
    <?php
      //$States = mysqli_fetch_array(mysqli_query($dbc, "Call spGetStates();"), MYSQLI_ASSOC);
      $States = mysqli_query($dbc, "Call spGetStates();");
      complete_procedure($dbc);
      
      echo '<select name="state">';
        while($row = $States->fetch_assoc()) {
          echo '<option value="' . $row["StateID"]. '">' . $row["FullStateName"]. '</option>';
        }
      echo '</select>';
    ?>
    </p>
	
	<p>Postal code (zip) : <input type="text" name="zip" size="15" maxlength="40" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>" /></p>
	<p>Address Type: 
    <?php
      $ATypes = mysqli_query($dbc, "Call spGetAddressTypes();");
      complete_procedure($dbc);
      
      echo '<select name="atype">';
        while($row = $ATypes->fetch_assoc()) {
          echo '<option value="' . $row["AddressTypeID"]. '">' . $row["AddressType"]. '</option>';
        }
      echo '</select>';
    ?>
    </p>
	<p>Phone Number: <input type="text" name="phone" size="15" maxlength="40" value="<?php if (isset($_POST['phone'])) echo $_POST['phone']; ?>" /></p>
	<p>Phone Type: <?php
      $PTypes = mysqli_query($dbc, "Call spGetPhoneTypes();");
      complete_procedure($dbc);
      
      echo '<select name="ptype">';
        while($row = $PTypes->fetch_assoc()) {
          echo '<option value="' . $row["PhoneTypeID"]. '">' . $row["PhoneType"]. '</option>';
        }
      echo '</select>';
    ?>
    </p>
	<p>SCR Member ID: <input type="text" name="code" size="15" maxlength="40" value="<?php if (isset($_POST['code'])) echo $_POST['code']; ?>" /></p>
	<p>Professional Association: (university, firm, etc.) <input type="text" name="association" size="25" maxlength="60" value="<?php if (isset($_POST['association'])) echo $_POST['association']; ?>" /></p>
	<p>*asterisk indicates a required field </p>
	<p><input type="submit" name="submit" value="Register" /></p>
</form>
<a href="index.php" class="button">Return</a>