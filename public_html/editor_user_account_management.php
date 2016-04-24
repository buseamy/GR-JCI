<?php $page_title = 'Editor User Account Management';
/*
* @File Name:		editor_user_account_management.php
* @Description: 	editor page that displays all users with links to update or disable those users
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/
 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./includes/subnav.php'); // Include subnav
 require('./include_utils/procedures.php'); // complete_procedure()
 
?>
<script type="text/javascript"> $( "#editor" ).addClass( "active" ); </script>

<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
        <!--Page main body-->
		 <h1>Editor User Account Management</h1>
            <div class="User List">
                <?php

                //$q = "Call spGetUsersAuthorsList();"; // Call to stored procedure
				$q = "Call spGetUsersList();";
				
                $result = $dbc->query($q); // Run procedure

                //if something is returned
                if ($result->num_rows > 0) { ?>
                    <table class="usersTable">
                        <tr>
                            <th class="fullName">Full Name (Last, First)</th>
							<th class="email">Email</th>
							<th class="roles">Roles</th>
							<th class="update">Update?</th>
							<th class="deactivate">Deactivate?</th>							
							<!--<th class="span2">Active</th> <td class="span2">' . $row["isActive"]. '</td> -->
                        </tr>
                    <?php
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        echo '<td class="fullName">' . $row["FullName"]. '</td> 
						<td class="email">' . $row["EmailAddress"]. '</td> 
						<td class="roles">' . $row["Roles"]. '</td> 
						'. '<td class="update"><a href="editor_update_user.php?UserID=' . $row["UserID"] .'">Update</a></td>
						'. '<td class="deactivate"><a href="deactivate_user.php?UserID=' . $row["UserID"] .'">Deactivate</a></td>
						</tr>';
					}
                    echo "</table>";
                } else {
                    //if no results found
                    echo "<tr><td>No results</td></tr>";
                }
                complete_procedure($dbc);?>
            </div>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
	<?php include ('includes/footer.php'); ?>
</div>


