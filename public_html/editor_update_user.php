<?php 

$page_title = 'Update User';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	require ('../mysqli_connect.php');
	require('./include_utils/procedures.php');
	
	$errors = array(); // Initialize an error array.
	
	if (!empty($_POST['email'])) {
		$email2 = mysqli_real_escape_string($dbc, trim($_POST['email']));
	} else {
		$errors[] = 'You forgot to enter an E-mail address.';
	}
	
	if (!empty($_POST['firstname'])) {
		$firstname2 = mysqli_real_escape_string($dbc, trim($_POST['firstname']));
	} else {
		$errors[] = 'You forgot to enter a first name.';
	}
	
	if (!empty($_POST['lastname'])) {
		$lastname2 = mysqli_real_escape_string($dbc, trim($_POST['lastname']));
	} else {
		$errors[] = 'You forgot to enter a last name.';
	}
	
	if (!isset($_POST['membercode'])) {
		$membercode2 = ' ';
	} else {
		$membercode2 = mysqli_real_escape_string($dbc, trim($_POST['membercode']));
	}
	
	if (!empty($_POST['institution'])) {
		$institution2 = mysqli_real_escape_string($dbc, trim($_POST['institution']));
	} else {
		$institution2 = ' ';
	}
	
	
	if (!empty($_POST['userid'])) {
		$userid2 = (int)mysqli_real_escape_string($dbc, trim($_POST['userid']));
	} else {
		$errors[] = 'There was an error.';
	}
	//if (isset( $_GET['UserID'])) {
	//	$userid2 =(int)$_GET['UserID'];
	//}
	
	//$userid2 = 8;
	
	
	if (empty($errors)) { // If there are no errors
	
		
		// Create the query 
		$q = "Call spUpdateUserInfo($userid2, '$firstname2', '$lastname2', '$membercode2', '$institution2');";
				
		// Run the query.
		if ($r = mysqli_query ($dbc, $q)) { // If it ran OK.
		
			// Finish updating user
			$row_everify = mysqli_fetch_array($r);
			complete_procedure($dbc);
			
			echo "<script type='text/javascript'>alert('User account has been updated')</script>";
			echo "<script>window.location = 'editor_user_account_management.php'</script>";

		} else { // If it did not run OK.
			
			// Public message:
			echo '<h1>System Error</h1>
			<p class="error">User information could not be updated.</p>'; 
			
			// Debugging message:
			echo '<p>' . mysqli_error($dbc) . '</p>';
						
		} // End of if ($r) IF.
		
		mysqli_close($dbc); // Close the database connection.

        //quit the script:
		//exit();
	
	} else { // Report the errors.
		echo "<script type='text/javascript'>alert('Error, please make sure first and last name are not empty.')</script>";
		echo "<script>window.location = 'editor_user_account_management.php'</script>";
	} 
	
	mysqli_close($dbc); // Close the database connection.

}

?>

<?php
	require ('./includes/header.php');
	require ('../mysqli_connect.php');
	require('./include_utils/procedures.php');
	$userid = $_GET['UserID'];

	$q_userinfo = "CALL spGetUserInfo($userid);";
    $r_userinfo = @mysqli_query ($dbc, $q_userinfo); // Run stored procedure

	while($userid_row = mysqli_fetch_array($r_userinfo)) { 
		$email = $userid_row["EmailAddress"];
		$firstname = $userid_row["FirstName"];
		$lastname = $userid_row["LastName"];
		$membercode = $userid_row["MemberCode"];
		$institution = $userid_row["InstitutionAffiliation"];
	}
	complete_procedure($dbc);

	
?>

<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
		<!-- create the form-->
			<div class="editor roundcorner">
                <h3 class="title">Update User</h3>
            </div>
			<div class="box editor_alt">
				<form action="editor_update_user.php" method="post">
					<p>UserID: <input readonly type="text" name="userid" size="10" maxlength="5" value="<?php echo $userid; ?>" /></p>
					<p>Email: <input readonly type="text" name="email" size="30" maxlength="30" value="<?php echo $email; ?>" /></p>
					<p>First Name: <input type="text" name="firstname" size="30" maxlength="30" value="<?php  echo $firstname; ?>" /></p>
					<p>Last Name: <input type="text" name="lastname" size="30" maxlength="30" value="<?php echo $lastname; ?>" /></p>
					<p>Member Code: <input type="text" name="membercode" size="30" maxlength="20"value="<?php echo $membercode; ?>" /></p>
					<p>Institution Affiliation: <input type="text" name="institution" size="30" maxlength="100" value="<?php echo $institution; ?>"/></p>
					<p><button class="editor" type="submit"  name="submit" onClick="#" >Update User</button></p>
					<p><button class="editor" type="button"  name="back" value="back" onClick="history.go(-1);return true;">Back</button></p>
				</form>
			</div>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>
<?php include ('includes/footer.php'); ?>