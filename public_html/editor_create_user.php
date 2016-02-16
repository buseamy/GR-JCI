<? // This page allows the Editor to create user acounts. written by Jamal Ahmed and adapted by Jonathan Sankey code referred to was from Isys288 register.php

/* TO-DO
- fix db query
- check if email exists
- conect/disconect from db
- send E-mail? welcome email
*/


$page_title = 'Create User';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database
	require ('../../mysqli_connect.php');
		
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
		$errors[] = 'The E-mail addresses did not match.';
	} else {
		$email = mysqli_real_escape_string($dbc, trim($_POST['email']));
		}
	} else {
		$errors[] = 'You forgot to enter an E-mail address.';
	}
	// checks if email already exists
	$checkquery1=("SELECT EmailAddress FROM Users WHERE EmailAddress = $_POST[email]");
	$result1=mysqli_query($checkquery1);
	if (!$result1) {
		$errors[] = 'username or E-mail already exists.';
	}
	
	
	// check for first name
	if (empty($_POST['first_name'])) {
		$errors[] = 'You forgot to enter a first name.';
	} else if (Is_numeric($_POST['first_name'])) {
		$errors[] = 'First names should not contain numbers.';
	}  else {
		$firstname = mysqli_real_escape_string($dbc, trim($_POST['first_name']));
	}
	
	// Check for a last name:
	if (empty($_POST['last_name'])) {
		$errors[] = 'You forgot to enter a last name.';
	} else if (Is_numeric($_POST['last_name'])) {
		$errors[] = 'Last names should not contain numbers.';
	}  else {
		$lastname = mysqli_real_escape_string($dbc, trim($_POST['last_name']));
	}
	
	// if no value is entered into box null value is inserted
	if (empty($_POST['address1'])) {
		$address2 = null;
	} else {
		$address1 = mysqli_real_escape_string($dbc, trim($_POST['address1']));
	}	
	
	// if no value is entered into box null value is inserted
	if (empty($_POST['address2'])) {
		$address2 = null;
	} else {
		$address2 = mysqli_real_escape_string($dbc, trim($_POST['address2']));
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
	
		// Add the user in the database...
		
		// Make the query:
		$q = "INSERT INTO Users (EmailAddress, PasswordHash, FirstName, Lastname, MemberCode, Phone, InstitutionAffiliation, AddressLn1, AddressLn2, City, StateID, PostCode, CreateDate) 
		VALUES ('$email', SHA1('$pass1'), '$firstname', '$lastname', '$code', '$phone', '$association', '$address1', '$address2', '$city', '$state', '$zip', NOW() )";		
		$r = @mysqli_query ($dbc, $q); // Run the query.
		if ($r) { // If it ran OK.
		
			// Print a message:
			echo '
		<p>You have successfully created the user.</p><p><br /></p>';	
		
		} else { // If it did not run OK.
			
			// Public message:
			echo '<h1>System Error</h1>
			<p class="error">user could not be created due to a system error.</p>'; 
			
			// Debugging message:
			echo '<p>' . mysqli_error($dbc) . '<br /><br />Query: ' . $q . '</p>';
						
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

<!-- create the form-->
<h1>Create User</h1>
<form action="editor_create_user.php" method="post">
	<p>Email Address: <input type="text" name="email" size="20" maxlength="60" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>"  /> </p>
	<p>Confirm Email Address: <input type="text" name="email2" size="20" maxlength="60" value="<?php if (isset($_POST['email2'])) echo $_POST['email2']; ?>"  /> </p>
	<p>Password: <input type="password" name="pass1" size="10" maxlength="20"  /></p>
	<p>Confirm Password: <input type="password" name="pass2" size="10" maxlength="20"  /></p>
	<p>First Name: <input type="text" name="first_name" size="15" maxlength="40" value="<?php if (isset($_POST['first_name'])) echo $_POST['first_name']; ?>" /></p>
	<p>Last Name: <input type="text" name="last_name" size="15" maxlength="40" value="<?php if (isset($_POST['last_name'])) echo $_POST['last_name']; ?>" /></p>
	<p>Street Address Line 1: <input type="text" name="address1" size="25" maxlength="50" value="<?php if (isset($_POST['address1'])) echo $_POST['address1']; ?>" /></p>
	<p>Street Address Line 2: <input type="text" name="address2" size="25" maxlength="50" value="<?php if (isset($_POST['address2'])) echo $_POST['address2']; ?>" /></p>
	<p>City: <input type="text" name="city" size="15" maxlength="40" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>" /></p>
	<p>State/province: <input type="text" name="state" size="15" maxlength="40" value="<?php if (isset($_POST['state'])) echo $_POST['state']; ?>" /></p>
	<p>Country: <select name="country"> 
		<option value="--">none</option>
		<option value="AF">Afghanistan</option>
		<option value="AL">Albania</option>
		<option value="DZ">Algeria</option>
		<option value="AS">American Samoa</option>
		<option value="AD">Andorra</option>
		<option value="AO">Angola</option>
		<option value="AI">Anguilla</option>
		<option value="AQ">Antarctica</option>
		<option value="AG">Antigua and Barbuda</option>
		<option value="AR">Argentina</option>
		<option value="AM">Armenia</option>
		<option value="AW">Aruba</option>
		<option value="AU">Australia</option>
		<option value="AT">Austria</option>
		<option value="AZ">Azerbaijan</option>
		<option value="BS">Bahamas</option>
		<option value="BH">Bahrain</option>
		<option value="BD">Bangladesh</option>
		<option value="BB">Barbados</option>
		<option value="BY">Belarus</option>
		<option value="BE">Belgium</option>
		<option value="BZ">Belize</option>
		<option value="BJ">Benin</option>
		<option value="BM">Bermuda</option>
		<option value="BT">Bhutan</option>
		<option value="BO">Bolivia</option>
		<option value="BA">Bosnia and Herzegowina</option>
		<option value="BW">Botswana</option>
		<option value="BV">Bouvet Island</option>
		<option value="BR">Brazil</option>
		<option value="IO">British Indian Ocean Territory</option>
		<option value="BN">Brunei Darussalam</option>
		<option value="BG">Bulgaria</option>
		<option value="BF">Burkina Faso</option>
		<option value="BI">Burundi</option>
		<option value="KH">Cambodia</option>
		<option value="CM">Cameroon</option>
		<option value="CA">Canada</option>
		<option value="CV">Cape Verde</option>
		<option value="KY">Cayman Islands</option>
		<option value="CF">Central African Republic</option>
		<option value="TD">Chad</option>
		<option value="CL">Chile</option>
		<option value="CN">China</option>
		<option value="CX">Christmas Island</option>
		<option value="CC">Cocos (Keeling) Islands</option>
		<option value="CO">Colombia</option>
		<option value="KM">Comoros</option>
		<option value="CG">Congo</option>
		<option value="CD">Congo, the Democratic Republic of the</option>
		<option value="CK">Cook Islands</option>
		<option value="CR">Costa Rica</option>
		<option value="CI">Cote d'Ivoire</option>
		<option value="HR">Croatia (Hrvatska)</option>
		<option value="CU">Cuba</option>
		<option value="CY">Cyprus</option>
		<option value="CZ">Czech Republic</option>
		<option value="DK">Denmark</option>
		<option value="DJ">Djibouti</option>
		<option value="DM">Dominica</option>
		<option value="DO">Dominican Republic</option>
		<option value="TP">East Timor</option>
		<option value="EC">Ecuador</option>
		<option value="EG">Egypt</option>
		<option value="SV">El Salvador</option>
		<option value="GQ">Equatorial Guinea</option>
		<option value="ER">Eritrea</option>
		<option value="EE">Estonia</option>
		<option value="ET">Ethiopia</option>
		<option value="FK">Falkland Islands (Malvinas)</option>
		<option value="FO">Faroe Islands</option>
		<option value="FJ">Fiji</option>
		<option value="FI">Finland</option>
		<option value="FR">France</option>
		<option value="FX">France, Metropolitan</option>
		<option value="GF">French Guiana</option>
		<option value="PF">French Polynesia</option>
		<option value="TF">French Southern Territories</option>
		<option value="GA">Gabon</option>
		<option value="GM">Gambia</option>
		<option value="GE">Georgia</option>
		<option value="DE">Germany</option>
		<option value="GH">Ghana</option>
		<option value="GI">Gibraltar</option>
		<option value="GR">Greece</option>
		<option value="GL">Greenland</option>
		<option value="GD">Grenada</option>
		<option value="GP">Guadeloupe</option>
		<option value="GU">Guam</option>
		<option value="GT">Guatemala</option>
		<option value="GN">Guinea</option>
		<option value="GW">Guinea-Bissau</option>
		<option value="GY">Guyana</option>
		<option value="HT">Haiti</option>
		<option value="HM">Heard and Mc Donald Islands</option>
		<option value="VA">Holy See (Vatican City State)</option>
		<option value="HN">Honduras</option>
		<option value="HK">Hong Kong</option>
		<option value="HU">Hungary</option>
		<option value="IS">Iceland</option>
		<option value="IN">India</option>
		<option value="ID">Indonesia</option>
		<option value="IR">Iran (Islamic Republic of)</option>
		<option value="IQ">Iraq</option>
		<option value="IE">Ireland</option>
		<option value="IL">Israel</option>
		<option value="IT">Italy</option>
		<option value="JM">Jamaica</option>
		<option value="JP">Japan</option>
		<option value="JO">Jordan</option>
		<option value="KZ">Kazakhstan</option>
		<option value="KE">Kenya</option>
		<option value="KI">Kiribati</option>
		<option value="KP">Korea, Democratic People's Republic of</option>
		<option value="KR">Korea, Republic of</option>
		<option value="KW">Kuwait</option>
		<option value="KG">Kyrgyzstan</option>
		<option value="LA">Lao People's Democratic Republic</option>
		<option value="LV">Latvia</option>
		<option value="LB">Lebanon</option>
		<option value="LS">Lesotho</option>
		<option value="LR">Liberia</option>
		<option value="LY">Libyan Arab Jamahiriya</option>
		<option value="LI">Liechtenstein</option>
		<option value="LT">Lithuania</option>
		<option value="LU">Luxembourg</option>
		<option value="MO">Macau</option>
		<option value="MK">Macedonia, The Former Yugoslav Republic of</option>
		<option value="MG">Madagascar</option>
		<option value="MW">Malawi</option>
		<option value="MY">Malaysia</option>
		<option value="MV">Maldives</option>
		<option value="ML">Mali</option>
		<option value="MT">Malta</option>
		<option value="MH">Marshall Islands</option>
		<option value="MQ">Martinique</option>
		<option value="MR">Mauritania</option>
		<option value="MU">Mauritius</option>
		<option value="YT">Mayotte</option>
		<option value="MX">Mexico</option>
		<option value="FM">Micronesia, Federated States of</option>
		<option value="MD">Moldova, Republic of</option>
		<option value="MC">Monaco</option>
		<option value="MN">Mongolia</option>
		<option value="MS">Montserrat</option>
		<option value="MA">Morocco</option>
		<option value="MZ">Mozambique</option>
		<option value="MM">Myanmar</option>
		<option value="NA">Namibia</option>
		<option value="NR">Nauru</option>
		<option value="NP">Nepal</option>
		<option value="NL">Netherlands</option>
		<option value="AN">Netherlands Antilles</option>
		<option value="NC">New Caledonia</option>
		<option value="NZ">New Zealand</option>
		<option value="NI">Nicaragua</option>
		<option value="NE">Niger</option>
		<option value="NG">Nigeria</option>
		<option value="NU">Niue</option>
		<option value="NF">Norfolk Island</option>
		<option value="MP">Northern Mariana Islands</option>
		<option value="NO">Norway</option>
		<option value="OM">Oman</option>
		<option value="PK">Pakistan</option>
		<option value="PW">Palau</option>
		<option value="PA">Panama</option>
		<option value="PG">Papua New Guinea</option>
		<option value="PY">Paraguay</option>
		<option value="PE">Peru</option>
		<option value="PH">Philippines</option>
		<option value="PN">Pitcairn</option>
		<option value="PL">Poland</option>
		<option value="PT">Portugal</option>
		<option value="PR">Puerto Rico</option>
		<option value="QA">Qatar</option>
		<option value="RE">Reunion</option>
		<option value="RO">Romania</option>
		<option value="RU">Russian Federation</option>
		<option value="RW">Rwanda</option>
		<option value="KN">Saint Kitts and Nevis</option> 
		<option value="LC">Saint LUCIA</option>
		<option value="VC">Saint Vincent and the Grenadines</option>
		<option value="WS">Samoa</option>
		<option value="SM">San Marino</option>
		<option value="ST">Sao Tome and Principe</option> 
		<option value="SA">Saudi Arabia</option>
		<option value="SN">Senegal</option>
		<option value="SC">Seychelles</option>
		<option value="SL">Sierra Leone</option>
		<option value="SG">Singapore</option>
		<option value="SK">Slovakia (Slovak Republic)</option>
		<option value="SI">Slovenia</option>
		<option value="SB">Solomon Islands</option>
		<option value="SO">Somalia</option>
		<option value="ZA">South Africa</option>
		<option value="GS">South Georgia and the South Sandwich Islands</option>
		<option value="ES">Spain</option>
		<option value="LK">Sri Lanka</option>
		<option value="SH">St. Helena</option>
		<option value="PM">St. Pierre and Miquelon</option>
		<option value="SD">Sudan</option>
		<option value="SR">Suriname</option>
		<option value="SJ">Svalbard and Jan Mayen Islands</option>
		<option value="SZ">Swaziland</option>
		<option value="SE">Sweden</option>
		<option value="CH">Switzerland</option>
		<option value="SY">Syrian Arab Republic</option>
		<option value="TW">Taiwan, Province of China</option>
		<option value="TJ">Tajikistan</option>
		<option value="TZ">Tanzania, United Republic of</option>
		<option value="TH">Thailand</option>
		<option value="TG">Togo</option>
		<option value="TK">Tokelau</option>
		<option value="TO">Tonga</option>
		<option value="TT">Trinidad and Tobago</option>
		<option value="TN">Tunisia</option>
		<option value="TR">Turkey</option>
		<option value="TM">Turkmenistan</option>
		<option value="TC">Turks and Caicos Islands</option>
		<option value="TV">Tuvalu</option>
		<option value="UG">Uganda</option>
		<option value="UA">Ukraine</option>
		<option value="AE">United Arab Emirates</option>
		<option value="GB">United Kingdom</option>
		<option value="US"selected>United States</option>
		<option value="UM">United States Minor Outlying Islands</option>
		<option value="UY">Uruguay</option>
		<option value="UZ">Uzbekistan</option>
		<option value="VU">Vanuatu</option>
		<option value="VE">Venezuela</option>
		<option value="VN">Viet Nam</option>
		<option value="VG">Virgin Islands (British)</option>
		<option value="VI">Virgin Islands (U.S.)</option>
		<option value="WF">Wallis and Futuna Islands</option>
		<option value="EH">Western Sahara</option>
		<option value="YE">Yemen</option>
		<option value="YU">Yugoslavia</option>
		<option value="ZM">Zambia</option>
		<option value="ZW">Zimbabwe</option>
	</select>
	<p>Postal code (zip) : <input type="text" name="zip" size="15" maxlength="40" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>" /></p>
	<p>Address Type:<select name="atype">
		<option value="Home">Home</option>
		<option value="Work">Work</option>
		<option value="School">School</option>
	</select> </p>
	<p>Phone Number: <input type="text" name="phone" size="15" maxlength="40" value="<?php if (isset($_POST['phone'])) echo $_POST['phone']; ?>" /></p>
	<p>Phone Type:<select name="ptype">
		<option value="Home">Home</option>
		<option value="Work">Work</option>
		<option value="Cell">Cell</option>
	</select> </p>
	<p>SCR Member ID: <input type="text" name="code" size="15" maxlength="40" value="<?php if (isset($_POST['code'])) echo $_POST['code']; ?>" /></p>
	<p>Professional Association (Univercity/Firm): <input type="association" name="last_name" size="25" maxlength="60" value="<?php if (isset($_POST['association'])) echo $_POST['association']; ?>" /></p>
	<p><input type="submit" name="submit" value="Create User" /></p>
</form>
<a href="editor_index.php" class="button">Return</a>