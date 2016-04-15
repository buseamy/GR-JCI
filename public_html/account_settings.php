<?php
$page_title = 'Account Settings - JCI Website';

/* Created By: Jeff Ballard
 * On: 9-Apr-2016
 * The purpose of this file is to allow a user to update their account info:
 * Email Address
 * Password
 * Personal information: Name, MemberCode, Institution Affiliation
 * Add/Remove addresses
 * Add/Remove phone numbers
 */

require ('./includes/header.php'); // Include the site header
require ('../mysqli_connect.php'); // Connect to the database
require ('./include_utils/procedures.php'); // complete_procedure()
require('./include_utils/login_functions.php');
require ('./include_utils/email_functions.php');

$errors = array(); // Initialize an error array.
$EmailAddress = '';
$FirstName = '';
$LastName = '';
$MemberCode = '';
$Affiliation = '';

if (!isset($_SESSION['UserID']) || ($_SESSION['UserID'] < 1)) {
    //Not logged in
    redirect_user('index.php');
} else {
    $UserID = $_SESSION['UserID'];

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        //Verify inputs
        if (!empty($_POST['FirstName'])) {
            $FirstName = $_POST['FirstName'];
        } else {
            $errors[] = 'Please provide a first name';
        }
        
        if (!empty($_POST['LastName'])) {
            $LastName = $_POST['LastName'];
        } else {
            $errors[] = 'Please provide a last name';
        }
        
        if (!empty($_POST['MemberCode'])) {
            $MemberCode = $_POST['MemberCode'];
        }
        
        if (!empty($_POST['Affiliation'])) {
            $Affiliation = $_POST['Affiliation'];
        }
        
        if (empty($errors)) {
            $FirstName = mysqli_real_escape_string($dbc, $FirstName);
            $LastName = mysqli_real_escape_string($dbc, $LastName);
            $MemberCode = mysqli_real_escape_string($dbc, $MemberCode);
            $Affiliation = mysqli_real_escape_string($dbc, $Affiliation);
            
            // Update the user info in the database...
            mysqli_query($dbc, "Call spUpdateUserInfo($UserID, '$FirstName', '$LastName', '$MemberCode', '$Affiliation');");
            complete_procedure($dbc);
        }
    } else {
        //Get the user's account info
        $r = mysqli_fetch_array(mysqli_query($dbc, "Call spGetUserInfo($UserID);"), MYSQLI_ASSOC);
        complete_procedure($dbc);
        
        $EmailAddress = $r["EmailAddress"];
        $FirstName = $r["FirstName"];
        $LastName = $r["LastName"];
        $MemberCode = $r["MemberCode"];
        $Affiliation = $r["InstitutionAffiliation"];
    }
    ?>
    <div class="content">
        <img class="responsive" src="images/wood_image.jpg" alt="wood">
    </div>
    <div class="contentwidth">
        <div class="row flush">
            <div class="col s7">
                <div class="author roundcorner">
                    <h3 class="title">Change Email or Password</h3>
                </div>
                <div class="box_guest author_alt">
                    <form method="post">
                        <button class="author buttonform" type="button" onclick="window.location.replace('user_update_password.php')">Change Password</button>
                        <button class="author buttonform" type="button" onclick="window.location.replace('user_update_email.php')">Change Email Address</button>
                    </form>
                </div>
                <div>
                    <br />
                </div>
                <div class="author roundcorner">
                    <h3 class="title">Personal Info</h3>
                </div>
                <div class="box_guest author_alt">
                    <?php
                    if (!empty($errors)) {
                        echo '<h1>Error!</h1><p class="error">The following error(s) occurred:<br />';
                        foreach ($errors as $msg) { // Print each error.
                            echo " - $msg<br />";
                        }
                        echo '</p><p>Please try again.</p><br />';
                    }
                    ?>
                    <form method="post">
                        <label for="EmailAddress">Email Address:</label>
                        <input type="text" class="regular" name="EmailAddress" maxlength="200" value="<?php echo $EmailAddress; ?>" readonly style="background: #C0C0C0;" />
                        <br />
                        <label for="FirstName"><span class="required">*</span> First Name:</label>
                        <input type="text" class="regular" name="FirstName" maxlength="15" value="<?php echo $FirstName; ?>" />
                        <br />
                        <label for="LastName"><span class="required">*</span> Last Name:</label>
                        <input type="text" class="regular" name="LastName" maxlength="30" value="<?php echo $LastName; ?>" />
                        <br />
                        <label for="MemberCode">SCR Member ID:</label>
                        <input type="text" class="regular" name="MemberCode" maxlength="20" value="<?php echo $MemberCode; ?>" />
                        <br />
                        <label for="Affiliation">Professional Association:</label>
                        <input type="text" class="regular" name="Affiliation" maxlength="100" value="<?php echo $Affiliation; ?>" />
                        <br />
                        <p>* indicates a required field</p>
                        <button class="author buttonform" type="submit">Update</button>
                    </form>
                </div>
                <div>
                    <br />
                </div>
                <div class="author roundcorner">
                    <h3 class="title">Addresses</h3>
                </div>
                <div class="box_guest author_alt">
                    <table border="0">
                      <tr><th>Primary</th><th>Type</th><th>Address Ln1</th><th>Address Ln2</th><th>City</th><th>State</th><th>PostCode</th><th></th></tr>
                    <?php
                    $addresses = mysqli_query($dbc, "Call spGetUserAddressList($UserID);");
                    complete_procedure($dbc);
                    
                    while ($row = $addresses->fetch_assoc()) {
                        echo '<tr>';
                        echo '<td align="center">'.($row["PrimaryAddress"] == 1 ? '✔' : '').'</td>';
                        echo '<td align="left">'.$row["AddressType"].'</td>';
                        echo '<td align="left">'.$row["AddressLn1"].'</td>';
                        echo '<td align="left">'.$row["AddressLn2"].'</td>';
                        echo '<td align="left">'.$row["City"].'</td>';
                        echo '<td align="left">'.$row["State"].'</td>';
                        echo '<td align="left">'.$row["PostCode"].'</td>';
                        echo '<td align="left">'.($row["PrimaryAddress"] == 1 ? '' : '<a href="address_setprimary.php?a='.$row["AddressID"].'">Make Primary</a><br />').'<a href="address_update.php?a='.$row["AddressID"].'">Update</a><br /><br /><a href="address_delete.php?a='.$row["AddressID"].'">Delete</a></td>';
                        echo '</tr>';
                    }
                    ?>
                    </table>
                    <br />
                    <button class="author buttonform" type="submit" onclick="window.location.replace('address_new.php')">Add Address</button>
                </div>
                <div>
                    <br />
                </div>
                <div class="author roundcorner">
                    <h3 class="title">Phone Numbers</h3>
                </div>
                <div class="box_guest author_alt">
                    <table border="0">
                      <tr><th>Primary</th><th>Type</th><th>Phone Number</th><th></th></tr>
                    <?php
                    $phones = mysqli_query($dbc, "Call spGetUserPhoneList($UserID);");
                    complete_procedure($dbc);
                    
                    while ($row = $phones->fetch_assoc()) {
                        echo '<tr>';
                        echo '<td align="center">'.($row["PrimaryPhone"] == 1 ? '✔' : '').'</td>';
                        echo '<td align="left">'.$row["PhoneType"].'</td>';
                        echo '<td align="left">'.$row["PhoneNumber"].'</td>';
                        echo '<td align="left">'.($row["PrimaryPhone"] == 1 ? '' : '<a href="phone_setprimary.php?p='.$row["PhoneNumberID"].'">Make Primary</a><br />').'<a href="phone_update.php?p='.$row["PhoneNumberID"].'">Update</a><br /><br /><a href="phone_delete.php?p='.$row["PhoneNumberID"].'">Delete</a></td>';
                        echo '</tr>';
                    }
                    ?>
                    </table>
                    <br />
                    <button class="author buttonform" type="submit" onclick="window.location.replace('phone_new.php')">Add Phone Number</button>
                </div>
            </div>
            <?php require 'includes/sidebar.php'; // Include sidebar ?>
        </div>
    </div>
    <?php require 'includes/footer.php'; // Include footer
}
mysqli_close($dbc);?>