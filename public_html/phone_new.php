<?php $page_title = 'New Address - SFCI - Journal for Critical Indicents';

/*
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
$PhoneType = 0;
$PhoneNumber = '';
$Primary = 1;

if (isset($_SESSION['UserID']) && ($_SESSION['UserID'] > -1)) {
    $UserID = $_SESSION['UserID'];
    
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        //Verify inputs

            if (!empty($_POST['PhoneNumber'])) {
                $PhoneNumber = $_POST['PhoneNumber'];
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
            
            if (isset($_POST['Primary'])) {
                $Primary = 1;
            }
        
        if (empty($errors)) {
            //Update the address in the database
            mysqli_query($dbc, "Call spCreatePhoneNumber($UserID, $PhoneType, '$PhoneNumber',$Primary);");
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
                <h3 class="title">New Phone Number</h3>
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
                    <label for="PhoneNumber"><span class="required">*</span> Phone Number:</label>
                    <input type="text" name="PhoneNumber" class="regular" maxlength="10" placeholder="##########" value="<?php echo $PhoneNumber; ?>" />
                    <br />
                    <label for="PhoneType">Phone Type:</label>
                    <select name="PhoneType" class="regular">
                    <?php
                        $PTypes = mysqli_query($dbc, "Call spGetPhoneTypes();");
                        complete_procedure($dbc);
                        
                        //Display the list of Phone Types
                        echo '<option value="0"'.($PhoneType == 0 ? ' selected' : '').'>Select..</option>';
                        while($row = $PTypes->fetch_assoc()) {
                            echo '<option value="'.$row["PhoneTypeID"].'"'.($row["PhoneTypeID"] == $PhoneType ? ' selected' : '').'>'.$row["PhoneType"].'</option>';
                        }
                    ?>
                    </select>
                    <br /><br />
                    <label for="Primary">Primary Phone:</label>
                    <input type="checkbox" name="Primary[]" value="1"<?php if ($Primary == 1) { echo ' checked'; } ?>>
                    <br />
                    <p>* indicates a required field</p>
                    <button class="author buttonform" type="submit" onclick="window.location.replace('account_settings.php'); return false;">Cancel</button>
                    <button class="author buttonform" type="submit">Save Phone Number</button>
                </form>
            </div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer

mysqli_close($dbc);