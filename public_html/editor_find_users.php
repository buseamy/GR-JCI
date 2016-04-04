
<?php  
	$page_title = 'Editor Find Users';
	require ('./includes/header.php');
	if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	require ('../mysqli_connect.php');
	require('./include_utils/procedures.php');
	$errors = array(); // Initialize an error array.
	
	$status = 0;
	
	// if nothing is entered give an error message
	if ((empty($_POST['firstname'])) && (empty($_POST['lastname'])) && (empty($_POST['email']))) {
			$errors[] = 'You forgot to enter a name or email address';
	}

	if (((!empty($_POST['firstname'])) && (!empty($_POST['email']))) || ((!empty($_POST['lastname'])) && (!empty($_POST['email']))) ){
		$errors[] = 'Please search using first name and last name or email';
	}
	
	if (((!empty($_POST['firstname'])) && (!empty($_POST['lastname'])) && (empty($_POST['email'])))
		|| ((empty($_POST['firstname'])) && (!empty($_POST['lastname'])) && (empty($_POST['email'])))
		|| ((!empty($_POST['firstname'])) && (empty($_POST['lastname'])) && (empty($_POST['email'])))) {
			$firstname = mysqli_real_escape_string($dbc, trim($_POST['firstname']));
			$lastname = mysqli_real_escape_string($dbc, trim($_POST['lastname']));
			$status = 1;
	}
	
	if ((empty($_POST['firstname'])) &&  (empty($_POST['lastname'])) && (!empty($_POST['email']))) {
			$email = mysqli_real_escape_string($dbc, trim($_POST['email']));
			$status = 2;
	}
	

	// run only if one or more fields has been entered
	if (empty($errors)) {
		if(((!empty($_POST['firstname'])) && (!empty($_POST['lastname'])) && (empty($_POST['email'])))
			||((!empty($_POST['firstname'])) && (empty($_POST['lastname'])) && (empty($_POST['email'])))
			||((empty($_POST['firstname'])) && (!empty($_POST['lastname'])) && (empty($_POST['email'])))){
				
				if(empty($_POST['firstname'])){
					$firstname = ' ';
				}
				if(empty($_POST['lastname'])){
					$lastname = ' ';
				}
				
				$q = "Call spSearchGetUsersNames('$lastname', '$firstname');"; // Call to stored procedure
                $result = $dbc->query($q); // Run procedure

                //if something is returned
                if ($result->num_rows > 0) { ?>
                    <table class="span2">
                        <tr>
                            <th class="span3">User ID</th>
                            <th class="span3">Full Name (Last, First)</th>
							<th class="span3">Email</th>
							<th class="span2">Member Code</th>
							<th class="span2">Institution Affiliation</th>
                            <th class="span2">Update</th>
							<th class="span2">Deactivate</th>
                        </tr>
                    <?php
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        echo '<tr><td class="span3">' . $row["UserID"]. '</td>
						<td class="span3">' . $row["FullName"]. '</td> 
						<td class="span3">' . $row["EmailAddress"]. '</td> 
						<td class="span2">' . $row["MemberCode"]. '</td> 
						<td class="span2">' . $row["InstitutionAffiliation"]. '</td> 
						<td class="span2">'. '<td class="span1"><a href="editor_update_user.php?UserID=' . $row["UserID"] .'">Update</a></td>
						<td class="span2">'. '<td class="span1"><a href="deactivate_user.php?UserID=' . $row["UserID"] .'">Deactivate</a></td>
						</tr>';
					}
                    echo "</table>";
                } else {
                    //if no results found
                    echo "<tr><td>No users found</td></tr>";
                }
                complete_procedure($dbc);
			
		}
		if(((empty($_POST['firstname'])) && (empty($_POST['lastname'])) && (!empty($_POST['email'])))){
			$q = "Call spSearchGetUsersEmail('$email');"; // Call to stored procedure
            $result = $dbc->query($q); // Run procedure

            //if something is returned
            if ($result->num_rows > 0) { ?>
                <table class="span12">
                    <tr>
                        <th class="span1">User ID</th>
                        <th class="span1">Full Name (Last, First)</th>
						<th class="span1">Email</th>
						<th class="span1">Member Code</th>
						<th class="span1">Institution Affiliation</th>
                        <th class="span1">Update</th>
						<th class="span1">Deactivate</th>
                        </tr>
                    <?php
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        echo '<tr><td class="span1">' . $row["UserID"]. '</td>
						<td class="span2">' . $row["FullName"]. '</td> 
						<td class="span2">' . $row["EmailAddress"]. '</td> 
						<td class="span2">' . $row["MemberCode"]. '</td> 
						<td class="span2">' . $row["InstitutionAffiliation"]. '</td> 
						<td class="span2">'. '<td class="span1"><a href="editor_update_user.php?UserID=' . $row["UserID"] .'">Update</a></td>
						<td class="span2">'. '<td class="span1"><a href="deactivate_user.php?UserID=' . $row["UserID"] .'">Deactivate</a></td>
						</tr>';
					}
                    echo "</table>";
                } else {
                    //if no results found
                    echo "<tr><td>No results</td></tr>";
                }
                complete_procedure($dbc);
			} 
		
		} else { // Report the errors.
	
			echo '<h1>Error!</h1>
			<p class="error">The following error(s) occurred:<br />';
			foreach ($errors as $msg) { // Print each error.
				echo " - $msg<br />\n";
			}
			echo '</p><p>Please try Searching again.</p>';
		
		}
	
}
?>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
<h1>Find Users</h1>
<form action="editor_find_users.php" method="post">
	<p>First name: <input type="text" name="firstname" size="20" maxlength="30" value="<?php if (isset($_POST['firstname'])) echo $_POST['firstname']; ?>" /></p>
	<p>Last name: <input type="text" name="lastname" size="20" maxlength="30" value="<?php if (isset($_POST['lastname'])) echo $_POST['lastname']; ?>" /></p>
	<p>Email: <input type="text" name="email" size="20" maxlength="20" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>" /></p>
	<p>
	<!--<input class="inputFileLabel" type="submit" name="submit" value="Search" />-->
	<p><button class="editor" type="submit"  name="submit" onClick="#" >Search</button></p>
	</p>
</form>
</div>
<?php require 'includes/sidebar.php'; // Include sidebar ?>
</div>
</div>


