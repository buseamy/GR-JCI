<?php $page_title = 'New Address - SFCI - Journal for Critical Indicents';

/* Created By: Jeff Ballard
 * On: 9-Apr-2016
 * The purpose of this file is to update an address
 */

require ('../mysqli_connect.php'); // Connect to the database
require ('./include_utils/login_functions.php');
require ('./include_utils/procedures.php');
require ('./includes/header.php');

if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}

$errors = array(); // Initialize an error array.

//Default values
$UserID = -1;
$AddressType = 0;
$Address1 = '';
$Address2 = '';
$City = '';
$State = 0;
$PostCode = '';
$Primary = 1;

if (isset($_SESSION['UserID']) && ($_SESSION['UserID'] > -1)) {
    $UserID = $_SESSION['UserID'];
    
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        //Verify inputs
        
        if (!empty($_POST['Address1'])) {
            $Address1 = $_POST['Address1'];
        }
        
        if (!empty($_POST['Address2'])) {
            $Address2 = $_POST['Address2'];
        }
        
        if ((strlen($Address1) == 0) && (strlen($Address2) == 0) ) {
            $errors[] = 'Please provide an address';
        } else if ((strlen($Address1) == 0) && (strlen($Address2) > 0)) {
            //Move the Address2 line into Address1
            $Address1 = $Address2;
            $Address2 = '';
        }
        
        if (!empty($_POST['City'])) {
            $City = $_POST['City'];
        } else {
            $errors[] = 'Please provide a city name';
        }
        
        if (!empty($_POST['State'])) {
            $State = $_POST['State'];
        } else if ($_POST['State'] == 0) {
            $errors[] = 'Please select a state';
        }
        
        if (!empty($_POST['PostCode'])) {
            $PostCode = $_POST['PostCode'];
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
        
        if (isset($_POST['Primary'])) {
            $Primary = 1;
        }
        
        if (empty($errors)) {
            //Update the address in the database
            mysqli_query($dbc, "Call spCreateAddress($UserID, $AddressType, '$Address1', '$Address2', '$City', $State, '$PostCode', $Primary);");
            complete_procedure($dbc);
            
            //Redirect user back to the account settings page
            redirect_user('account_settings.php');
        }
    }
}
?>
<div class="content">
    <img class="responsive" src="images/wood_image.jpg" alt="wood">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <div class="author roundcorner">
                <h3 class="title">New Address</h3>
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
                    <label for="Address1"><span class="required">*</span> Address Line 1:</label>
                    <input type="text" name="Address1" class="regular" maxlength="100" value="<?php echo $Address1; ?>" />
                    <br />
                    <label for="Address2">Address Line 2:</label>
                    <input type="text" name="Address2" class="regular" maxlength="100" value="<?php echo $Address2; ?>" />
                    <br />
                    <label for="City"><span class="required">*</span> City:</label>
                    <input type="text" name="City" class="regular" maxlength="30" value="<?php echo $City; ?>" />
                    <br />
                    <label for="State"><span class="required">*</span> State:</label>
                    <select name="State" class="regular">
                    <?php
                        $States = mysqli_query($dbc, "Call spGetStates();");
                        complete_procedure($dbc);
                        
                        //Dispay the list of states
                        echo '<option value="0"'.($State == 0 ? ' selected' : '').'>Select..</option>';
                        while($row = $States->fetch_assoc()) {
                            echo '<option value="'.$row["StateID"].'"'.($row["StateID"] == $State ? ' selected' : '').'>'.$row["FullStateName"].'</option>';
                        }
                    ?>
                    </select>
                    <br /><br />
                    <label for="PostCode"><span class="required">*</span> Postal Code (zip):</label>
                    <input type="text" name="PostCode" class="regular" maxlength="5" placeholder="#####" value="<?php echo $PostCode; ?>" />
                    <br />
                    <label for="AddressType"><span class="required">*</span> Address Type:</label>
                    <select name="AddressType" class="regular">
                    <?php
                        $ATypes = mysqli_query($dbc, "Call spGetAddressTypes();");
                        complete_procedure($dbc);
                        
                        //Display the list of Address Types
                        echo '<option value="0"'.($AddressType == 0 ? ' selected' : '').'>Select..</option>';
                        while($row = $ATypes->fetch_assoc()) {
                            echo '<option value="'.$row["AddressTypeID"].'"'.($row["AddressTypeID"] == $AddressType ? ' selected' : '').'>'.$row["AddressType"].'</option>';
                        }
                    ?>
                    </select>
                    <br /><br />
                    <label for="Primary">Primary Address:</label>
                    <input type="checkbox" name="Primary[]" value="1"<?php if ($Primary == 1) { echo ' checked'; } ?>>
                    <br />
                    <p>* indicates a required field</p>
                    <button class="author buttonform" type="submit" onclick="window.location.replace('account_settings.php'); return false;">Cancel</button>
                    <button class="author buttonform" type="submit">Save Address</button>
                </form>
            </div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer

mysqli_close($dbc);