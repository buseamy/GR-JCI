<?php $page_title = 'User deactivated';

require ('./includes/header.php'); // Include the site header
$display = true;
		
if (isset($_GET["UserID"])) {
	
    // $dbc defined and initialized
    require('../mysqli_connect.php');
    // functions complete_procedure and ignore_remaining_output defined
    require('./include_utils/procedures.php');
    
    $UserID = mysqli_real_escape_string($dbc, $_GET["UserID"]);
	$defaultString = "Deactivated"; //Generic message for NonActiveNote
 
    $q = "CALL spDisableUser('$UserID', '$defaultString');";		
	$r = $dbc->query($q); //Runs the stored procedure

    complete_procedure($dbc);

}

if ($display) {
    
    // displays the message with a link to get back to the previous page
    echo "<div><h1>The account has been has been deactivated</h1>\n";
    echo "<p><a href='editor_user_account_management.php'>Back to user account management</a></div>";

}

?>