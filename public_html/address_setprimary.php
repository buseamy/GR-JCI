<?php

/* Created By: Jeff Ballard
 * On: 9-Apr-2016
 * The purpose of this file is to make an address as primary
 */

require ('../mysqli_connect.php'); // Connect to the database
require ('./include_utils/login_functions.php');
require ('./include_utils/procedures.php');

if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}

if (isset($_GET["a"])) {
    if (isset($_SESSION['UserID']) && ($_SESSION['UserID'] > -1)) {

        //Get the ID of the address record
        $AddressID = mysqli_real_escape_string($dbc, $_GET["a"]);
        
        if ($AddressID > 0) {
            mysqli_query($dbc, "Call spUpdateAddressMakePrimary($AddressID);");
            complete_procedure($dbc);
            
            mysqli_close($dbc);
        }
    }
}

//Redirect user back to the account settings page
redirect_user('account_settings.php');
?>