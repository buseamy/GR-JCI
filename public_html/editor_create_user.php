<?php 
// This page allows the Editor to create user acounts. written by Jamal Ahmed and adapted by Jonathan Sankey code referred to was from Isys288 register.php
// This page uses preg_match to verify feilds. Documentation can be found at http://php.net/manual/en/function.preg-match.php

$page_title = 'Create User';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database
	require ('../mysqli_connect.php');
	require('./include_utils/procedures.php');
	require('./include_utils/email_functions.php');
		
	$errors = array(); // Initialize an error array.
	
	// checks that password is at least 6 characters long.
	if (strlen($_POST['pass1']) < 6 ) {
		$errors[] = 'The password must be at least 6 characters long.';
	}
	// checks if password matches
	if (isset($_POST['pass1'])) {
	if ($_POST['pass1'] != $_POST['pass2']) {
		$errors[] = 'Your password did not match the confirmed password.';
	} else {
		$password = mysqli_real_escape_string($dbc, trim($_POST['pass1']));
	}
	} else {
		$errors[] = 'You forgot to enter a password.';
	}
	
	// checks if email matches
	if (isset($_POST['email']) {
		if ($_POST['email'] != $_POST['email2']) {
			$errors[] = 'The E-mail addresses do not match.';
		} elseif (preg_match('/^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+(?:[a-zA-Z]{2}|aero|biz|com|coop|edu|gov|info|jobs|mil|mobi|museum|name|net|org|travel)$/i', $_POST['email'])) {
			$email = mysqli_real_escape_string($dbc, trim($_POST['email']));
		} else {
			$errors[] = 'The E-mail address must be in the format "someone@host.com".'
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
	} elseif (Is_numeric($_POST['zip'])){
		$zip = mysqli_real_escape_string($dbc, trim($_POST['zip']));
	}	
	  elseif(!Is_numeric($_POST['zip'])){
		$errors[] = 'Zip codes should only contain numbers.';
	  }

	if (isset($_POST['iphone')) {
		$phone = mysqli_real_escape_string($dbc, trim($_POST['phone']));
	} elseif (preg_match('\(?[2-9][0-8][0-9]\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}', $_POST['phone'])) {
		$phone = preg_replace('\(?[2-9][0-8][0-9]\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}', $_POST['phone']);
		$phone = mysqli_real_escape_string($dbc, trim($phone));
	} else {
		$errors[] = 'Phone numbers should be formated "(000) 000-0000".';
	}

	
	if (empty($_POST['code'])) {
		$code = null;
	} elseif (preg_match('/^[0-9]{5,5}([- ]?[0-9]{4,4})?$/', $_POST['code'])) {
		$code = mysqli_real_escape_string($dbc, trim($_POST['code']));
	} else {
		$errors[] = 'Zip/postal codes should be formated as "00000" or "00000-0000".'
	}
	
	if (empty($_POST['association'])) {
		$association = null;
	} else {
		$association = mysqli_real_escape_string($dbc, trim($_POST['association']));
	}
	$atype = $_POST['atype'];
	$ptype = $_POST['ptype'];
	// check to see if address or phone number are primary.
	if ($_POST['atype'] = 2){
		$aprime = 1;
	}
	if ($_POST['ptype'] = 2){
		$pprime = 1;
	}
	
	if (empty($errors)) { // If everything's OK.
	
		// Add the user in the database...
		
		// Make the query:
		$q_users = "Call spEditorCreateUser('$email', '$password', '$firstname', '$lastname');";
				
		// Run the query.
		if ($r_users = mysqli_query ($dbc, $q_users)) { // If it ran OK.
		
			// Finish sending data to database and print a success message:
			
			$row_verify = mysqli_fetch_array($r_users, MYSQLI_ASSOC);
			$r_userID = $row_verify["UserID"];
			$r_everify = $row_verify["EmailVerificationGUID"];
			complete_procedure($dbc);
			
			// Send the users address information to the database
			if ((isset($_post['address1'])) || (isset($_post['address2']))) {
				$q_address = "CALL spCreateAddress('$r_userID', '$atype', '$address1', '$address2', '$city', '$stateID', '$zip', '$aprime')";
				mysqli_query ($dbc, $q_address);
				complete_procedure($dbc);
			}
			
			// Send the users phone information to the database.
			if (isset($_post['phone'])){
				$q_phone = "CALL spCreatePhoneNumber('$r_userID', '$ptype', '$phone', '$pprime')";
				mysqli_query ($dbc, $q_phone);
				complete_procedure($dbc);
			}
			
            //No need to add the author role, the CreateUser SP does that automatically
			// Send user role information to database.
			//$q_role = "Call spUserAddRole ($r_userID, 1);";
			//mysqli_query ($dbc, $q_role);
			//complete_procedure($dbc);
			if (isset($_POST['checkeditor'])){
				$q_role = "Call spUserAddRole ($r_userID, 3);";
				mysqli_query ($dbc, $q_role);
				complete_procedure($dbc);
			}
			if (isset($_POST['checkreviewer'])){
				$q_role = "Call spUserAddRole ($r_userID, 2);";
				mysqli_query ($dbc, $q_role);
				complete_procedure($dbc);
			}
            
            // Send welcome E-mail for verification
            sendNotificationEmail($dbc, $r_userID, $password);
		
			echo '<p>You have successfully created the user.</p><p><br /></p>';
			/*if (isset($_POST['submit']))
			{
				header( "Location: 5; editor_create_user.php");
			}
		*/
		} else { // If it did not run OK.
			
			// Public message:
			echo '<h1>System Error</h1>
			<p class="error">user could not be created due to a system error.</p>'; 
			
			// Debugging message:
			echo '<p>' . mysqli_error($dbc) . '</p>';
						
		} // End of if ($r) IF.
		
		mysqli_close($dbc); // Close the database connection.

		
		// Send welcome E-mail for verification
		/*$to = '$email';
		$subject = 'Welcome to JCI';
		$body = "Welcome to the Journal for Critical Incidents! \nWe greatly apreciate you'r interest in joining us, but there is one more step before you are registered. Please follow the link below to verify you'r E-mail and we will finish the registration. \n
		{$r_everify}";
		$body = wordwrap($body,70);
		
		mail($to, $subject, $body);
*/
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

<!-- create the form-->
<h1>Create User</h1>
<form action="editor_create_user.php" method="post">
	<p>Email Address*: <input type="text" name="email" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  /> </p>
	<p>Confirm Email Address*: <input type="text" name="email2" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  /> </p>
	<p>Password*: <input type="password" name="pass1" size="10" maxlength="20"  /></p>
	<p>Confirm Password*: <input type="password" name="pass2" size="10" maxlength="20"  /></p>
	<p>First Name*: <input type="text" name="first_name" size="15" maxlength="40" value="<?php if (isset($_POST['first_name'])) echo $_POST['first_name']; ?>" /></p>
	<p>Last Name*: <input type="text" name="last_name" size="15" maxlength="40" value="<?php if (isset($_POST['last_name'])) echo $_POST['last_name']; ?>" /></p>
	<p>Professional Association (Univercity, Firm, etc.): <input type="text" name="association" size="25" maxlength="60" value="<?php if (isset($_POST['association'])) echo $_POST['association']; ?>" /></p>
	<p>Street Address Line 1: <input type="text" name="address1" size="25" maxlength="50" value="<?php if (isset($_POST['address1'])) echo $_POST['address1']; ?>" /></p>
	<p>Street Address Line 2: <input type="text" name="address2" size="25" maxlength="50" value="<?php if (isset($_POST['address2'])) echo $_POST['address2']; ?>" /></p>
	<p>City: <input type="text" name="city" size="15" maxlength="40" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>" /></p>
	<p>State/province: <select name="state"> 
		<option value="<?php if (isset($_POST['state'])) echo $_POST['state']; ?>">
		<option value="NULL">Empty</option>
		<option value="AL">Alabama</option>
		<option value="AK">Alaska</option>
		<option value="AZ">Arizona</option>
		<option value="AR">Arkansas</option>
		<option value="CA">California</option>
		<option value="CO">Colorado</option>
		<option value="CT">Connecticut</option>
		<option value="DE">Delaware</option>
		<option value="FL">Florida</option>
		<option value="GA">Georgia</option>
		<option value="HI">Hawaii</option>
		<option value="ID">Idaho</option>
		<option value="IL">Illinois</option>
		<option value="IN">Indiana</option>
		<option value="IA">Iowa</option>
		<option value="KS">Kansas</option>
		<option value="KY">Kentucky</option>
		<option value="LA">Louisiana</option>
		<option value="ME">Maine</option>
		<option value="MD">Maryland</option>
		<option value="MA">Massachusetts</option>
		<option value="MI">Michigan</option>
		<option value="MN">Minnesota</option>
		<option value="MS">Mississippi</option>
		<option value="MO">Missouri</option>
		<option value="MT">Montana</option>
		<option value="NE">Nebraska</option>
		<option value="NV">Nevada</option>
		<option value="NH">New Hampshire</option>
		<option value="NJ">New Jersey</option>
		<option value="NM">New Mexico</option>
		<option value="NY">New York</option>
		<option value="NC">North Carolina</option>
		<option value="ND">North Dakota</option>
		<option value="OH">Ohio</option>
		<option value="OK">Oklahoma</option>
		<option value="OR">Oregon</option>
		<option value="PA">Pennsylvania</option>
		<option value="RI">Rhode Island</option>
		<option value="SC">South Carolina</option>
		<option value="SD">South Dakota</option>
		<option value="TN">Tennessee</option>
		<option value="TX">Texas</option>
		<option value="UT">Utah</option>
		<option value="VT">Vermont</option>
		<option value="VA">Virginia</option>
		<option value="WA">Washington</option>
		<option value="WV">West Virginia</option>
		<option value="WI">Wisconsin</option>
		<option value="WY">Wyoming</option>
		
	</select>
	<p>Country: <select name="country"> 
		<option value="<?php if (isset($_POST['country'])) echo $_POST['country']; ?>">
		<option value="NULL">none</option>
		<option value="Afghanistan">Afghanistan</option>
		<option value="Albania">Albania</option>
		<option value="Algeria">Algeria</option>
		<option value="American Samoa">American Samoa</option>
		<option value="Andorra">Andorra</option>
		<option value="Angola">Angola</option>
		<option value="Anguilla">Anguilla</option>
		<option value="Antarctica">Antarctica</option>
		<option value="Antigua and Barbuda">Antigua and Barbuda</option>
		<option value="Argentina">Argentina</option>
		<option value="Armenia">Armenia</option>
		<option value="Aruba">Aruba</option>
		<option value="Australia">Australia</option>
		<option value="Austria">Austria</option>
		<option value="Azerbaijan">Azerbaijan</option>
		<option value="Bahamas">Bahamas</option>
		<option value="Bahrain">Bahrain</option>
		<option value="Bangladesh">Bangladesh</option>
		<option value="Barbados">Barbados</option>
		<option value="Belarus">Belarus</option>
		<option value="Belgium">Belgium</option>
		<option value="Belize">Belize</option>
		<option value="Benin">Benin</option>
		<option value="Bermuda">Bermuda</option>
		<option value="Bhutan">Bhutan</option>
		<option value="Bolivia">Bolivia</option>
		<option value="Bosnia and Herzegowina">Bosnia and Herzegowina</option>
		<option value="Botswana">Botswana</option>
		<option value="Bouvet Island">Bouvet Island</option>
		<option value="Brazil">Brazil</option>
		<option value="British Indian Ocean Territory">British Indian Ocean Territory</option>
		<option value="Brunei Darussalam">Brunei Darussalam</option>
		<option value="Bulgaria">Bulgaria</option>
		<option value="Burkina Faso">Burkina Faso</option>
		<option value="Burundi">Burundi</option>
		<option value="Cambodia">Cambodia</option>
		<option value="Cameroon">Cameroon</option>
		<option value="Canada">Canada</option>
		<option value="Cape Verde">Cape Verde</option>
		<option value="Cayman Islands">Cayman Islands</option>
		<option value="Central African Republic">Central African Republic</option>
		<option value="Chad">Chad</option>
		<option value="Chile">Chile</option>
		<option value="China">China</option>
		<option value="Christmas Island">Christmas Island</option>
		<option value="Cocos (Keeling) Islands">Cocos (Keeling) Islands</option>
		<option value="Colombia">Colombia</option>
		<option value="Comoros">Comoros</option>
		<option value="Congo">Congo</option>
		<option value="Congo, the Democratic Republic of the">Congo, the Democratic Republic of the</option>
		<option value="Cook Islands">Cook Islands</option>
		<option value="Costa Rica">Costa Rica</option>
		<option value="Cote d'Ivoire">Cote d'Ivoire</option>
		<option value="Croatia">Croatia (Hrvatska)</option>
		<option value="Cuba">Cuba</option>
		<option value="Cyprus">Cyprus</option>
		<option value="Czech Republic">Czech Republic</option>
		<option value="Denmark">Denmark</option>
		<option value="Djibouti">Djibouti</option>
		<option value="Dominica">Dominica</option>
		<option value="Dominican Republic">Dominican Republic</option>
		<option value="East Timor">East Timor</option>
		<option value="Ecuador">Ecuador</option>
		<option value="Egypt">Egypt</option>
		<option value="El Salvador">El Salvador</option>
		<option value="Equatorial Guinea">Equatorial Guinea</option>
		<option value="Eritrea">Eritrea</option>
		<option value="Estonia">Estonia</option>
		<option value="Ethiopia">Ethiopia</option>
		<option value="Falkland Islands">Falkland Islands (Malvinas)</option>
		<option value="Faroe Islands">Faroe Islands</option>
		<option value="Fiji">Fiji</option>
		<option value="Finland">Finland</option>
		<option value="France">France</option>
		<option value="France, Metropolitan">France, Metropolitan</option>
		<option value="French Guiana">French Guiana</option>
		<option value="French Polynesia">French Polynesia</option>
		<option value="French Southern Territories">French Southern Territories</option>
		<option value="Gabon">Gabon</option>
		<option value="Gambia">Gambia</option>
		<option value="Georgia">Georgia</option>
		<option value="Germany">Germany</option>
		<option value="Ghana">Ghana</option>
		<option value="Gibraltar">Gibraltar</option>
		<option value="Greece">Greece</option>
		<option value="Greenland">Greenland</option>
		<option value="Grenada">Grenada</option>
		<option value="Guadeloupe">Guadeloupe</option>
		<option value="Guam">Guam</option>
		<option value="Guatemala">Guatemala</option>
		<option value="Guinea">Guinea</option>
		<option value="Guinea-Bissau">Guinea-Bissau</option>
		<option value="Guyana">Guyana</option>
		<option value="Haiti">Haiti</option>
		<option value="Heard and Mc Donald Islands">Heard and Mc Donald Islands</option>
		<option value="Holy See">Holy See (Vatican City State)</option>
		<option value="Honduras">Honduras</option>
		<option value="Hong Kong">Hong Kong</option>
		<option value="Hungary">Hungary</option>
		<option value="Iceland">Iceland</option>
		<option value="India">India</option>
		<option value="Indonesia">Indonesia</option>
		<option value="Iran">Iran (Islamic Republic of)</option>
		<option value="Iraq">Iraq</option>
		<option value="Ireland">Ireland</option>
		<option value="Israel">Israel</option>
		<option value="Italy">Italy</option>
		<option value="Jamaica">Jamaica</option>
		<option value="Japan">Japan</option>
		<option value="Jordan">Jordan</option>
		<option value="Kazakhstan">Kazakhstan</option>
		<option value="Kenya">Kenya</option>
		<option value="Kiribati">Kiribati</option>
		<option value="Korea, Democratic People's Republic of">Korea, Democratic People's Republic of</option>
		<option value="Korea, Republic of">Korea, Republic of</option>
		<option value="Kuwait">Kuwait</option>
		<option value="Kyrgyzstan">Kyrgyzstan</option>
		<option value="Lao People's Democratic Republic">Lao People's Democratic Republic</option>
		<option value="Latvia">Latvia</option>
		<option value="Lebanon">Lebanon</option>
		<option value="Lesotho">Lesotho</option>
		<option value="Liberia">Liberia</option>
		<option value="Libyan Arab Jamahiriya">Libyan Arab Jamahiriya</option>
		<option value="Liechtenstein">Liechtenstein</option>
		<option value="Lithuania">Lithuania</option>
		<option value="Luxembourg">Luxembourg</option>
		<option value="Macau">Macau</option>
		<option value="Macedonia">Macedonia, The Former Yugoslav Republic of</option>
		<option value="Madagascar">Madagascar</option>
		<option value="Malawi">Malawi</option>
		<option value="Malaysia">Malaysia</option>
		<option value="Maldives">Maldives</option>
		<option value="Mali">Mali</option>
		<option value="Malta">Malta</option>
		<option value="Marshall Islands">Marshall Islands</option>
		<option value="Martinique">Martinique</option>
		<option value="Mauritania">Mauritania</option>
		<option value="Mauritius">Mauritius</option>
		<option value="Mayotte">Mayotte</option>
		<option value="Mexico">Mexico</option>
		<option value="Micronesia">Micronesia, Federated States of</option>
		<option value="Moldova, Republic of">Moldova, Republic of</option>
		<option value="Monaco">Monaco</option>
		<option value="Mongolia">Mongolia</option>
		<option value="Montserrat">Montserrat</option>
		<option value="Morocco">Morocco</option>
		<option value="Mozambique">Mozambique</option>
		<option value="Myanmar">Myanmar</option>
		<option value="Namibia">Namibia</option>
		<option value="Nauru">Nauru</option>
		<option value="Nepal">Nepal</option>
		<option value="Netherlands">Netherlands</option>
		<option value="Netherlands Antilles">Netherlands Antilles</option>
		<option value="New Caledonia">New Caledonia</option>
		<option value="New Zealand">New Zealand</option>
		<option value="Nicaragua">Nicaragua</option>
		<option value="Niger">Niger</option>
		<option value="Nigeria">Nigeria</option>
		<option value="Niue">Niue</option>
		<option value="Norfolk Island">Norfolk Island</option>
		<option value="Northern Mariana Islands">Northern Mariana Islands</option>
		<option value="Norway">Norway</option>
		<option value="Oman">Oman</option>
		<option value="Pakistan">Pakistan</option>
		<option value="Palau">Palau</option>
		<option value="Panama">Panama</option>
		<option value="Papua New Guinea">Papua New Guinea</option>
		<option value="Paraguay">Paraguay</option>
		<option value="Peru">Peru</option>
		<option value="Philippines">Philippines</option>
		<option value="Pitcairn">Pitcairn</option>
		<option value="Poland">Poland</option>
		<option value="Portugal">Portugal</option>
		<option value="Puerto Rico">Puerto Rico</option>
		<option value="Qatar">Qatar</option>
		<option value="Reunion">Reunion</option>
		<option value="Romania">Romania</option>
		<option value="Russian Federation">Russian Federation</option>
		<option value="Rwanda">Rwanda</option>
		<option value="Saint Kitts and Nevis">Saint Kitts and Nevis</option> 
		<option value="aint LUCIA">Saint LUCIA</option>
		<option value="Saint Vincent and the Grenadines">Saint Vincent and the Grenadines</option>
		<option value="Samoa">Samoa</option>
		<option value="San Marino">San Marino</option>
		<option value="Sao Tome and Principe">Sao Tome and Principe</option> 
		<option value="Saudi Arabia">Saudi Arabia</option>
		<option value="Senegal">Senegal</option>
		<option value="Seychelles">Seychelles</option>
		<option value="Sierra Leone">Sierra Leone</option>
		<option value="Singapore">Singapore</option>
		<option value="Slovakia">Slovakia (Slovak Republic)</option>
		<option value="Slovenia">Slovenia</option>
		<option value="Solomon Islands">Solomon Islands</option>
		<option value="Somalia">Somalia</option>
		<option value="South Africa">South Africa</option>
		<option value="South Georgia and the South Sandwich Islands">South Georgia and the South Sandwich Islands</option>
		<option value="Spain">Spain</option>
		<option value="Sri Lanka">Sri Lanka</option>
		<option value="St. Helena">St. Helena</option>
		<option value="St. Pierre and Miquelon">St. Pierre and Miquelon</option>
		<option value="Sudan">Sudan</option>
		<option value="Suriname">Suriname</option>
		<option value="Svalbard and Jan Mayen Islands">Svalbard and Jan Mayen Islands</option>
		<option value="Swaziland">Swaziland</option>
		<option value="Sweden">Sweden</option>
		<option value="Switzerland">Switzerland</option>
		<option value="Syrian Arab Republic">Syrian Arab Republic</option>
		<option value="Taiwan">Taiwan, Province of China</option>
		<option value="Tajikistan">Tajikistan</option>
		<option value="Tanzania">Tanzania, United Republic of</option>
		<option value="Thailand">Thailand</option>
		<option value="Togo">Togo</option>
		<option value="Tokelau">Tokelau</option>
		<option value="Tonga">Tonga</option>
		<option value="Trinidad and Tobago">Trinidad and Tobago</option>
		<option value="Tunisia">Tunisia</option>
		<option value="Turkey">Turkey</option>
		<option value="Turkmenistan">Turkmenistan</option>
		<option value="Turks and Caicos Islands">Turks and Caicos Islands</option>
		<option value="Tuvalu">Tuvalu</option>
		<option value="Uganda">Uganda</option>
		<option value="Ukraine">Ukraine</option>
		<option value="United Arab Emirates">United Arab Emirates</option>
		<option value="United Kingdom">United Kingdom</option>
		<option value="United States"selected>United States</option>
		<option value="United States Minor Outlying Islands">United States Minor Outlying Islands</option>
		<option value="Uruguay">Uruguay</option>
		<option value="Uzbekistan">Uzbekistan</option>
		<option value="Vanuatu">Vanuatu</option>
		<option value="Venezuela">Venezuela</option>
		<option value="Viet Nam">Viet Nam</option>
		<option value="Virgin Islands (British)">Virgin Islands (British)</option>
		<option value="Virgin Islands (U.S.)">Virgin Islands (U.S.)</option>
		<option value="Wallis and Futuna Islands">Wallis and Futuna Islands</option>
		<option value="Western Sahara">Western Sahara</option>
		<option value="Yemen">Yemen</option>
		<option value="Yugoslavia">Yugoslavia</option>
		<option value="Zambia">Zambia</option>
		<option value="Zimbabwe">Zimbabwe</option>
	</select>
	<p>Postal code (zip) : <input type="text" name="zip" size="15" maxlength="40" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>" /></p>
	<p>Address Type:<select name="atype">
		<option value="<?php if (isset($_POST['atype'])) echo $_POST['atype']; ?>">
		<option value="2">Main</option>
		<option value="1">Home</option>
		<option value="3">Work</option>
	</select> </p>
	<p>Phone Number: <input type="text" name="phone" size="15" maxlength="40" value="<?php if (isset($_POST['phone'])){ echo $_POST['phone']; } else {echo '000-000-0000'} ?>" /></p>
	<p><input type="checkbox" name="iphone" /> This Number is international. (The format "000-000-0000" will no longer apply)</p>
	<p>Phone Type:<select name="ptype">
		<option value="<?php if (isset($_POST['ptype'])) echo $_POST['ptype']; ?>">
		<option value="2">Main</option>
		<option value="1">Home</option>
		<option value="3">Mobile</option>
		<option value="4">Work</option>
	</select> </p>
	<p>SCR Member ID: <input type="text" name="code" size="15" maxlength="40" value="<?php if (isset($_POST['code'])) echo $_POST['code']; ?>" /></p>
	<p></p>
	<p>Roles:
	<div class="form-checkbox"><input type="checkbox" name="checkeditor"> Editor</div>
	<div class="form-checkbox"><input type="checkbox" name="checkreviewer"> Reviewer</div></p>
	<p>*asterisk indicates a required field </p>
	<p><input type="submit" name="submit" value="Create User" /></p>
</form>
<a href="editor_index.php" class="button">Return</a>