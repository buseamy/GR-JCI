<?php $page_title = 'Update Email Address - SFCI - Journal for Critical Indicents';
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
$Email1 = '';
$Email2 = '';

if (isset($_SESSION['UserID']) && ($_SESSION['UserID'] > -1)) {
    $UserID = $_SESSION['UserID'];
    
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        //Verify inputs
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
        
        if (empty($errors)) {
            $Email1 = mysqli_real_escape_string($dbc, $Email1);
            
            //Update the email address
            mysqli_query($dbc, "Call spUpdateUserEmailAddress($UserID,'$Email1');");
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
                <h3 class="title">Change Email Address</h3>
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
                    <label for="Email1"><span class="required">*</span> Email Address:</label>
                    <input type="text" class="regular" name="Email1" maxlength="200" value="<?php echo $Email1; ?>" />
                    <br />
                    <label for="Email2"><span class="required">*</span> Confirm Email:</label>
                    <input type="text" class="regular" name="Email2" maxlength="200" autocomplete="off" value="<?php echo $Email2; ?>" />
                    <br />
                    <p>* indicates a required field</p>
                    <button class="author buttonform" type="submit" onclick="window.location.replace('account_settings.php'); return false;">Cancel</button>
                    <button class="author buttonform" type="submit">Change Email Address</button>
                </form>
            </div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer

mysqli_close($dbc);?>