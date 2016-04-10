<?php $page_title = 'Update Password - SFCI - Journal for Critical Indicents';
/*
 * The purpose of this file is to update the user's email address
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
$Password1 = '';
$Password2 = '';

if (isset($_SESSION['UserID']) && ($_SESSION['UserID'] > -1)) {
    $UserID = $_SESSION['UserID'];
    
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        //Verify inputs
        
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
        
        if (empty($errors)) {
            $Email1 = mysqli_real_escape_string($dbc, $Email1);
            
            //Update the email address
            mysqli_query($dbc, "Call spUpdateUserPassword($UserID,'$Password1');");
            complete_procedure($dbc);
            
            //Redirect user back to the account settings page
            redirect_user('account_settings.php');
        }
    }
} else {
    //Redirect user back to the account settings page
    redirect_user('account_settings.php');
}
?>
<div class="content">
    <img class="responsive" src="images/wood_image.jpg" alt="wood">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <div class="author roundcorner">
                <h3 class="title">Change Password</h3>
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
                    <label for="Password1"><span class="required">*</span> Password:</label>
                    <input type="password" class="regular" name="Password1" maxlength="50" value="<?php if ($UserID == -1) { echo $Password1; } ?>" />
                    <br />
                    <label for="Password2"><span class="required">*</span> Confirm Password:</label>
                    <input type="password" class="regular" name="Password2" maxlength="50" value="<?php if ($UserID == -1) { echo $Password2; } ?>" />
                    <br />
                    <p>* indicates a required field</p>
                    <button class="author buttonform" type="submit" onclick="window.location.replace('account_settings.php'); return false;">Cancel</button>
                    <button class="author buttonform" type="submit">Change Password</button>
                </form>
            </div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer

mysqli_close($dbc);?>