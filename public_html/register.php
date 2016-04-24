<?php 

/* Created By: Jeff Ballard
 * On: 9-Apr-2016
 * The purpose of this file is allow a guest to the site create an account
 * Originally written by Jamal Ahmed but Rewritten by Jeff Ballard
 * On: 4/23/16 Jamal Ahmed fixed bugs found by QA
 */

$page_title = 'Register - SFCI - Journal for Critical Indicents';

// database connection is required for queries to be inserted in database
require ('../mysqli_connect.php');
require ('./includes/header.php'); // Include the site header
require ('./include_utils/procedures.php');
require ('./include_utils/email_functions.php');

$errors = array(); // Initialize an error array.

// Set variables to defaults
$FirstName = '';
$LastName = '';
$Email1 = '';
$Email2 = '';
$Password1 = '';
$Password2 = '';
$Address1 = '';
$Address2 = '';
$City = '';
$State = 0;
$PostCode = '';
$AddressType = 0;
$PhoneNumber = '';
$PhoneType = 0;
$MemberCode = '';
$Association = '';

$UserID = -1;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    //Verify inputs
	/*
    if (!empty($_POST['FirstName'])) {
        $FirstName = mysqli_real_escape_string($dbc, trim($_POST['FirstName']));
    } else if (Is_numeric($_POST['FirstName'])) {
		$errors[] = 'Your name should not contain numbers.';
	} else {
        $errors[] = 'Please provide a first name';
    }
	*/
	
	if (empty(trim($_POST['FirstName']))) {
		$errors[] = 'Please provide a First Name';
	} else if (Is_numeric($_POST['FirstName'])) {
		$errors[] = 'Please provide a First Name';
	}  else {
		$FirstName = mysqli_real_escape_string($dbc, trim($_POST['FirstName']));
	}
	
	if (empty(trim($_POST['LastName']))) {
		$errors[] = 'Please provide a Last Name';
	} else if (Is_numeric($_POST['LastName'])) {
		$errors[] = 'Please provide a Last Name';
	}  else {
		$LastName = mysqli_real_escape_string($dbc, trim($_POST['LastName']));
	}
    
    
    if (!empty($_POST['Email1'])) {
        $Email1 = strtolower($_POST['Email1']);
        if (!filter_var($Email1, FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'Please provide a valid email address';
        }
    } else {
        $errors[] = 'Please provide an email address';
    }
    
    if (!empty($_POST['Email2'])) {
        $Email2 = strtolower($_POST['Email2']);
        if (!filter_var($Email2, FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'Please provide a valid email address';
        }
    } else {
        $errors[] = 'Please provide an email confirmation';
    }
    
    // Make sure both emails were typed in and see if they do not match
    if ((strlen($Email1) > 0) && (strlen($Email2) > 0) && ($Email1 != $Email2)) {
        $errors[] = 'Emails do not match';
    }
    
    if (!empty($_POST['Password1'])) {
        $Password1 = $_POST['Password1'];
    } else {
        $errors[] = 'Please provide a password';
    }
    
    if (!empty($_POST['Password2'])) {
        $Password2 = $_POST['Password2'];
    } else {
        $errors[] = 'Please provide a password confirmation';
    }
    
    // Make sure both passwords were typed in and see if they are less than 6 chars or do not match
    if ((strlen($Password1) > 0) && (strlen($Password2) > 0) && strlen($Password1) < 6) {
        $errors[] = 'Password needs to be at least 6 characters long';
    } else if ((strlen($Password1) > 0) && (strlen($Password2) > 0) && ($Password1 != $Password2)) {
        $errors[] = 'Passwords do not match';
    }
    
    if (!empty($_POST['Address1'])) {
        $Address1 = mysqli_real_escape_string($dbc, trim($_POST['Address1']));
    }
    
    if (!empty($_POST['Address2'])) {
        $Address2 = mysqli_real_escape_string($dbc, trim($_POST['Address2']));
    }
    
    if ((strlen($Address1) == 0) && (strlen($Address2) == 0) ) {
        $errors[] = 'Please provide an address';
    } else if ((strlen($Address1) == 0) && (strlen($Address2) > 0)) {
        //Move the Address2 line into Address1
        $Address1 = $Address2;
        $Address2 = '';
    }
	
	if (empty(trim($_POST['City']))) {
		$errors[] = 'Please provide a City';
	} else if (Is_numeric($_POST['City'])) {
		$errors[] = 'Please provide a City';
	}  else {
		$City = mysqli_real_escape_string($dbc, trim($_POST['City']));
	}
    
    if (!empty($_POST['State'])) {
        $State = $_POST['State'];
    } else if ($_POST['State'] == 0) {
        $errors[] = 'Please select a state';
    }
    
    if (!empty($_POST['PostCode'])) {
        $PostCode = mysqli_real_escape_string($dbc, trim($_POST['PostCode']));
        if (!Is_numeric($PostCode) || (strlen($PostCode) < 5)) {
           $errors[] = 'Please provide a 5 digit postal (zip) code'; 
        }
    } else {
        $errors[] = 'Please provide a 5 digit postal (zip) code';
    }
    
    if (!empty($_POST['AddressType'])) {
        $AddressType = $_POST['AddressType'];
    } else if ($_POST['AddressType'] == 0) {
        $errors[] = 'Please select an address type';
    }
    
    if (!empty($_POST['PhoneNumber'])) {
        $PhoneNumber = mysqli_real_escape_string($dbc, trim($_POST['PhoneNumber']));
        if (!Is_numeric($PhoneNumber) || (strlen($PhoneNumber) < 10)) {
           $errors[] = 'Please provide a 10 digit phone number'; 
        }
    } else {
        $errors[] = 'Please provide a 10 digit phone number';
    }
    
    if (!empty($_POST['PhoneType'])) {
        $PhoneType = $_POST['PhoneType'];
    } else if ($_POST['PhoneType'] == 0) {
        $errors[] = 'Please select a phone type';
    }
    
    if (!empty($_POST['MemberCode'])) {
        $MemberCode = mysqli_real_escape_string($dbc, trim($_POST['MemberCode']));
    }
    
    if (!empty($_POST['Association'])) {
        $Association = mysqli_real_escape_string($dbc, trim($_POST['Association']));
    }
    
    if (empty($errors)) { // If everything's OK.
        //Escape all the strings for database insertion
		
        $FirstName = mysqli_real_escape_string($dbc, $FirstName);
        $LastName = mysqli_real_escape_string($dbc, $LastName);
        $Email1 = mysqli_real_escape_string($dbc, $Email1);
        $Password1 = mysqli_real_escape_string($dbc, $Password1);
        $Address1 = mysqli_real_escape_string($dbc, $Address1);
        $Address2 = mysqli_real_escape_string($dbc, $Address2);
        $City = mysqli_real_escape_string($dbc, $City);
        $MemberCode = mysqli_real_escape_string($dbc, $MemberCode);
        $Association = mysqli_real_escape_string($dbc, $Association);
		
        
        // Add the user in the database...
        $r = mysqli_query($dbc, "Call spCreateUser('$Email1', '$Password1', '$FirstName', '$LastName');");
        complete_procedure($dbc);
        
        if ($r) {
            $r = mysqli_fetch_array($r, MYSQLI_ASSOC);
            if (isset($r['UserID'])) {
                //Get the UserID from the query
                $UserID = $r["UserID"];
                
                //Update user record with member code and association
                mysqli_query($dbc, "Call spUpdateUserInfo($UserID, '$FirstName', '$LastName', '$MemberCode', '$Association');");
                complete_procedure($dbc);
                
                //Create the address record
                mysqli_query($dbc, "Call spCreateAddress($UserID, $AddressType, '$Address1', '$Address2', '$City', $State, '$PostCode', 1);");
                complete_procedure($dbc);
                
                //Create the phone record
                mysqli_query($dbc, "Call spCreatePhoneNumber($UserID, $PhoneType, '$PhoneNumber', 1);");
                complete_procedure($dbc);
                
                // Send welcome E-mail for verification
                sendVerificationEmail($dbc, $UserID, 1);
                
                $Registered = 1;
            }
            else {
                array_push($errors, $r['Error']);
            }
        } else {
            $errors[] = 'System error, failed to create account: '.mysqli_error($dbc); 
        }
        mysqli_close($dbc);
    }
}
?>
<div class="content">
    <img class="responsive" src="images/glasses.jpg" alt="reading glasses and book">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <?php
            if (!empty($errors)) {
                echo '<div>';
                echo '<h1>Error!</h1><p class="error">The following error(s) occurred:<br />';
                foreach ($errors as $msg) { // Print each error.
                    echo " - $msg<br />";
                }
                echo '</p><p>Please try again.</p>';
                echo '</div>';
            } else if ($UserID > -1) {
                echo '<div style="color: #008000; font-weight: bold; padding-bottom: 10px;">You have successfully registered, please check your email for a verification message.</div>';
            }
            ?>
            <div class="guest roundcorner">
                <h3 class="title">Create an Account</h3>
            </div>
            <div class="box_guest guest_alt account">
                <form method="post">
                    <label for="FirstName"><span class="required">*</span> First Name:</label>
                    <input type="text" class="regular" name="FirstName" maxlength="15" value="<?php if ($UserID == -1) { echo $FirstName; }?>" />
                    <br />
                    <label for="LastName"><span class="required">*</span> Last Name:</label>
                    <input type="text" class="regular" name="LastName" maxlength="30" value="<?php if ($UserID == -1) { echo $LastName; } ?>" />
                    <br />
					<label for="Association">Professional Association: (university, firm, etc.)</label>
                    <input type="text" name="Association" class="regular" maxlength="100" value="<?php if ($UserID == -1) { echo $Association; } ?>" />
                    <br />
                    <label for="Email1"><span class="required">*</span> Email Address:</label>
                    <input type="text" class="regular" name="Email1" maxlength="200" value="<?php if ($UserID == -1) { echo $Email1; } ?>" />
                    <br />
                    <label for="Email2"><span class="required">*</span> Confirm Email:</label>
                    <input type="text" class="regular" name="Email2" maxlength="200" autocomplete="off" value="<?php if ($UserID == -1) { echo $Email2; } ?>" />
                    <br />
                    <label for="Password1"><span class="required">*</span> Password:</label>
                    <input type="password" class="regular" name="Password1" maxlength="50" value="<?php if ($UserID == -1) { echo $Password1; } ?>" />
                    <br />
                    <label for="Password2"><span class="required">*</span> Confirm Password:</label>
                    <input type="password" class="regular" name="Password2" maxlength="50" value="<?php if ($UserID == -1) { echo $Password2; } ?>" />
                    <br />
                    <label for="Address1"><span class="required">*</span> Address Line 1:</label>
                    <input type="text" name="Address1" class="regular" maxlength="100" value="<?php if ($UserID == -1) { echo $Address1; } ?>" />
                    <br />
                    <label for="Address2">Address Line 2:</label>
                    <input type="text" name="Address2" class="regular" maxlength="100" value="<?php if ($UserID == -1) { echo $Address2; } ?>" />
                    <br />
                    <label for="City"><span class="required">*</span> City:</label>
                    <input type="text" name="City" class="regular" maxlength="30" value="<?php if ($UserID == -1) { echo $City; } ?>" />
                    <br />
                    <label for="State"><span class="required">*</span> State:</label>
                    <select name="State" class="regular">
                    <?php
                        $States = mysqli_query($dbc, "Call spGetStates();");
                        complete_procedure($dbc);
                        
                        //Dispay the list of states
                        echo '<option value="0"'.($State == 0 || $UserID == -1 ? ' selected' : '').'>Select..</option>';
                        while($row = $States->fetch_assoc()) {
                            echo '<option value="'.$row["StateID"].'"'.($row["StateID"] == $State && $UserID == -1 ? ' selected' : '').'>'.$row["FullStateName"].'</option>';
                        }
                    ?>
                    </select>
                    <br /><br />
                    <label for="PostCode"><span class="required">*</span> Postal Code (zip):</label>
                    <input type="text" name="PostCode" class="regular" maxlength="5" placeholder="#####" value="<?php if ($UserID == -1) { echo $PostCode; } ?>" />
                    <br />
                    <label for="AddressType"><span class="required">*</span> Address Type:</label>
                    <select name="AddressType" class="regular">
                    <?php
                        $ATypes = mysqli_query($dbc, "Call spGetAddressTypes();");
                        complete_procedure($dbc);
                        
                        //Display the list of Address Types
                        echo '<option value="0"'.($AddressType == 0 || $UserID == -1 ? ' selected' : '').'>Select..</option>';
                        while($row = $ATypes->fetch_assoc()) {
                            echo '<option value="'.$row["AddressTypeID"].'"'.($row["AddressTypeID"] == $AddressType && $UserID == -1 ? ' selected' : '').'>'.$row["AddressType"].'</option>';
                        }
                    ?>
                    </select>
                    <br /><br />
                    <label for="PhoneNumber"><span class="required">*</span> Phone Number:</label>
                    <input type="text" name="PhoneNumber" class="regular" maxlength="10" placeholder="##########" value="<?php if ($UserID == -1) { echo $PhoneNumber; } ?>" />
                    <br />
                    <label for="PhoneType"><span class="required">*</span> Phone Type:</label>
                    <select name="PhoneType" class="regular">
                    <?php
                        $PTypes = mysqli_query($dbc, "Call spGetPhoneTypes();");
                        complete_procedure($dbc);
                        
                        //Display the list of Phone Types
                        echo '<option value="0"'.($PhoneType == 0 || $UserID == -1 ? ' selected' : '').'>Select..</option>';
                        while($row = $PTypes->fetch_assoc()) {
                            echo '<option value="'.$row["PhoneTypeID"].'"'.($row["PhoneTypeID"] == $PhoneType && $UserID == -1 ? ' selected' : '').'>'.$row["PhoneType"].'</option>';
                        }
                    ?>
                    </select>
                    <br /><br />
                    <label for="MemberCode">SCR Member ID:</label>
                    <input type="text" name="MemberCode" class="regular" maxlength="20" value="<?php if ($UserID == -1) { echo $MemberCode; } ?>" />
                    <br />
                    
                    <p>* indicates a required field</p>
                    <button class="guest" type="submit">Register</button>
                </form>
            </div>
        </div>
        <?php require ('./includes/sidebar.php'); // Include the site sidebar
    echo '</div>';
echo '</div>';
require ('./includes/footer.php'); ?>