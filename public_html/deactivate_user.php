<?php $page_title = 'User deactivated';
/*
* @File Name:		deactivate_user.php
* @Description: 	This is the script for deactivating a user that'y only accessable by the editor.
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/
require ('./includes/header.php'); // Include the site header
require ('./includes/subnav.php'); // Include subnav
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
	echo "
		<script type=\"text/javascript\"> $(\"#editor\" ).addClass(\"active\" ); </script>
			<div class=\"contentwidth\">
				<div class=\"row flush\">
					<div class=\"col s7\">
						<h1>The account has been has been deactivated</h1>
						<p><button class=\"editor\" type=\"submit\"  name=\"back\" onClick=\"history.go(-1);return true;\" >Back to user account management</button></p>
					</div>
			</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>
<?php include ('includes/footer.php'); ?>";

}

?>