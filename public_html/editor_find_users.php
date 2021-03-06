
<?php  

/*
* @File Name:		editor_find_users.php
* @Description: 	The find users page for the editor. The editor can search for users by email or
					first/last name.
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/
	$page_title = 'Editor Find Users';
	require ('./includes/header.php');
	require ('./includes/subnav.php'); // Include subnav
	
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
                        echo '<tr>
						<td class="span3">' . $row["FullName"]. '</td> 
						<td class="span3">' . $row["EmailAddress"]. '</td> 
						<td class="span2">' . $row["MemberCode"]. '</td> 
						<td class="span2">' . $row["InstitutionAffiliation"]. '</td> 
						'. '<td class="span1"><a href="editor_update_user.php?UserID=' . $row["UserID"] .'">Update</a></td>
						'. '<td class="span1"><a href="deactivate_user.php?UserID=' . $row["UserID"] .'">Deactivate</a></td>
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
                        echo '<tr>
						<td class="span2">' . $row["FullName"]. '</td> 
						<td class="span2">' . $row["EmailAddress"]. '</td> 
						<td class="span2">' . $row["MemberCode"]. '</td> 
						<td class="span2">' . $row["InstitutionAffiliation"]. '</td> 
						'. '<td class="span1"><a href="editor_update_user.php?UserID=' . $row["UserID"] .'">Update</a></td>
						'. '<td class="span1"><a href="deactivate_user.php?UserID=' . $row["UserID"] .'">Deactivate</a></td>
						</tr>';
					}
                    echo "</table>";
                } else {
                    //if no results found
                    echo "<tr><td>No results</td></tr>";
                }
                complete_procedure($dbc);
			} 
		
		} else { // print out errors
	
			echo '<h1>Error!</h1>
			<p class="error">The following error(s) occurred:<br />';
			foreach ($errors as $msg) { // Print each error.
				echo " - $msg<br />\n";
			}
			echo '</p><p>Please try Searching again.</p>';
		
		}
	
}
?>
<script type="text/javascript"> $( "#editor" ).addClass( "active" ); </script>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
				<div class="editor roundcorner">
                    <h3 class="title">Find Users</h3>
                </div>
				<div class="box editor_alt">
				<form action="editor_find_users.php" method="post" name="name">
					<h2>Search by first and/or last name</h2>
					<input type="text" class="regular inputForm" placeholder="First Name" name="firstname" width="75%"  value="<?php if (isset($_POST['firstname'])) echo $_POST['firstname']; ?>">
					<input type="text" class="regular inputForm" placeholder="Last Name" name="lastname" width="75%"  value="<?php if (isset($_POST['lastname'])) echo $_POST['lastname']; ?>">
					<p><button class="editor" type="submit"  name="submit" onClick="#" >Search by name</button></p>
				</form>
				<form action="editor_find_users.php" method="post" name="email">
					<h2>Search by email</h2>
					<input type="text" class="regular inputForm" placeholder="Email" name="email" width="75%"  value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>">
					<p><button class="editor" type="submit"  name="submit" onClick="#" >Search by email</button></p>
				</form>
				</div>

		</div>
	<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>



