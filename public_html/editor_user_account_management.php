<?php $page_title = 'Editor User Account Management';
 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require('./include_utils/procedures.php'); // complete_procedure()
 
?>

<div class="contentwidth">
    <div class="row flush">
        <div class="col s8">
        <!--Page main body-->
		 <h1>Editor User Account Management</h1>
            <div class="User List">
                <?php

                //$q = "Call spGetUsersAuthorsList();"; // Call to stored procedure
				$q = "Call spGetUsersList();";
				
                $result = $dbc->query($q); // Run procedure

                //if something is returned
                if ($result->num_rows > 0) { ?>
                    <table class="span12">
                        <tr>
                            <th class="span2">User ID</th>
                            <th class="span2">Full Name (Last, First)</th>
							<th class="span2">Email</th>
							<th class="span2">Roles</th>
							<!--<th class="span2">Active</th> <td class="span2">' . $row["isActive"]. '</td> -->
                        </tr>
                    <?php
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        echo '<tr><td class="span2">' . $row["UserID"]. '</td>
						<td class="span2">' . $row["FullName"]. '</td> 
						<td class="span2">' . $row["EmailAddress"]. '</td> 
						<td class="span2">' . $row["Roles"]. '</td> 
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
				?>
            </div>
        </div>
	
	<!-- Sidebar -->
	<div class="row">
		<div class="col s2 side guest_light">	
			<div class="editor corner"></div>
				<ul class="side_nav">
					<li><a href="../editor_create_user.php">Create User</a></li>
					<li><a href="../editor_find_users.php">Find User</a></li>
					<li><a href="../editor_user_account_management.php">User Account Management</a></li>
					<li><a href="../editor_incident_management.php">Critical Incident Management</a></li>
					<li><a href="../editor_systems_settings.php">System Settings</a></li>
				</ul>
			
		</div>
	</div>
	
	</div>
</div>

