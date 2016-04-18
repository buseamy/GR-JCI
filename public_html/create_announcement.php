<?php $page_title = 'Create Announcement';


// Writen by: Jonathan Sankey on 4/15/2016
// This page allows the editor to create an announcment and store it in the database.
// The idea of using an array to store all role options chosen was taken from http://stackoverflow.com/questions/18421988/getting-checkbox-values-on-submit



 require ('./includes/header.php'); // Include the site header
 require ('../mysqli_connect.php'); // Connect to the database
 require ('./include_utils/procedures.php'); // complete_procedure()
 
 if (session_status() == PHP_SESSION_NONE) {
    // start a session if one doesn't exist
    session_start();
}
 
 $errors = array(); // Initialize an error array.
 $title = '';
 $announcement = '';
 $expiration = '';
 $success = 'no';

 
 if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      require('./include_utils/login_functions.php'); //redirect
	  require ('./include_utils/date_conversion.php');
	  
	  $role = $_POST['role'];
      
      if (!empty($_POST['title'])) {
          $title = $_POST['title'];
      } else {
          $errors[] = 'Please provide a title for the announcement';
      }
	  
	  if (!empty($_POST['announcement'])) {
          $announcement = $_POST['announcement'];
      } else {
          $errors[] = 'Please provide an announcement';
      }
      
      if (!empty($_POST['expiration'])) {
		 $tempdate = $_POST['expiration'];
			if (vardate($tempdate)) {
				$expiration = convert_to($tempdate);
			} else {
				$errors[] = 'The expiration date provided was in the wrong format.';
			}
	  } else {
          $errors[] = 'Please provide an expiration date';
      }
	  
	  if ((empty ($errors)) && ($success = 'no')) { //if everything ran ok
		  $q_announce = "CALL spCreateAnnouncement('$title', '$announcement', '$expiration')";
		  $announcementID = mysqli_query ($dbc, $q_announce);
		  complete_procedure($dbc);
		  $success = 'yes'; // make sure the announcement is not created again if the user forgets to select a role
		  
		  $announcementID = mysqli_fetch_array($announcementID, MYSQLI_ASSOC);
		  $announcementID = $announcementID["AnnouncementID"];
	  }
      
	  if (!empty($role)) {
		  foreach ($role as $option) {
			  $q_role = "CALL spAnnouncementAddRole($announcementID, $option)";
			  mysqli_query ($dbc, $q_role);
			  complete_procedure($dbc);
		  }
	  } else {
		  $errors[] = 'Please select at least one role.';
	  }
     
      mysqli_close($dbc); // Close the database connection.
        
	  if (empty($errors)) {
      // Redirect:
      redirect_user('index.php'); //-------------------------------------------------------------------------------------------------------------------------------
	  }
 }
?>
<?php if (isset($_SESSION['isEditor'])) { // Only display if logged in role is editor ?>
<div class="content">
    <img class="responsive" src="images/wood_image.jpg" alt="wood">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <div class="row">
             <div class="col s10 frames">
                <?php 
                if (!empty($errors)) {
                    echo '<div>';
                    echo '<h1>Error!</h1><p class="error">The following error(s) occurred:<br />';
                    foreach ($errors as $msg) { // Print each error.
                        echo " - $msg<br />\n";
                    }
                    echo '</p><p>Please try again.</p><p><br /></p>';
                    echo '</div>';
                }
                ?>
                <div class="editor roundcorner">
                    <h3 class="title">Create Announcement</h3>
                </div>
                <div class="box editor_alt">
                    <form method="post">
                        <input type="text" class="regular inputForm" placeholder="Title" name="title" width="100%" value="<?php echo $title; ?>">
						<textarea placeholder="Announcement Limit: 500 Characters" rows="10" maxlength="500" name="announcement"><?php echo $announcement; ?></textarea>
						<br>
                        <input type="text" class="regular inputForm" placeholder="Expiration date: mm/dd/yyyy" name="expiration" width="100%" value="<?php echo $expiration; ?>">
						<div class="form-checkbox">
							<?php
							$Roles = mysqli_query($dbc, "Call spGetRoles();"); // get a list of roles from DB
							complete_procedure($dbc);
							
							echo '<span style="margin-left: 3em;"><b> Visible to role(s): </b></span><br>';
							while($row = $Roles->fetch_assoc()) { // while there is still a role to display
								echo '<span style="margin-left: 4em;">' . $row["RoleTitle"] . '<input type="checkbox" name="role[]" value="'. $row["RoleID"].'" ></span>';
								}
							?>
						</div>
						<br>
						<br>
						<button class="alert buttonform" onclick="location.href=' '">Cancel</button>
                        <button class="editor buttonform" type="submit">Create</button>
						<br>
                    </form>
                </div>
            </div>
    	</div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php } else { echo '<p class="swatch alert_text">Please login and try again</p>'; }
require 'includes/footer.php'; // Include footer ?>