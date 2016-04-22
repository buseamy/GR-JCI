<?php $page_title = 'Configure Reminder Emails';


// Writen by: Jonathan Sankey on 4/21/2016
// This page allows the editor to update the email settings for naging authors and reviewers.



 require ('./includes/header.php'); // Include the site header
 require ('../mysqli_connect.php'); // Connect to the database
 require ('./include_utils/procedures.php'); // complete_procedure() and ignore_remaining_output()
 
 if (session_status() == PHP_SESSION_NONE) {
    // start a session if one doesn't exist
    session_start();
}
 
 $errors = array(); // Initialize an error array.

 
 if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      require('./include_utils/login_functions.php'); //redirect
	  require ('./include_utils/date_conversion.php');
	  
      // validate the input before sending data to the database.
	  
      if (empty($SettingName)) {
          $errors[] = 'Please provide a name';
      }
	  
	  if  (is_string($AuthorNagEmailDays) || empty($AuthorNagEmailDays)) {
          $errors[] = 'Please provide the author reminder interval in days';
      }
      
	   if (empty($AuthorSubjectTemplate)) {
          $errors[] = 'Please provide a subject for the author';
      }
	  
      if (empty($AuthorBodyTemplate)) {
          $errors[] = 'Please provide a message to the author';
      }
	  
	  if  (is_string($ReviewerNagEmailDays) || empty($ReviewerNagEmailDays)) {
          $errors[] = 'Please provide the author reminder interval in days';
      }
      
	   if (empty($ReviewerSubjectTemplate)) {
          $errors[] = 'Please provide a subject for the author';
      }
	  
      if (empty($ReviewerBodyTemplate)) {
          $errors[] = 'Please provide a message to the author';
      }
	  
	  if (empty ($errors)) { //if everything ran ok update the settings
		  $q_update = "CALL spUpdateEmailSettings('$SettingID', '$SettingName', '$AuthorNagEmailDays', '$AuthorSubjectTemplate', '$AuthorBodyTemplate', '$ReviewerNagEmailDays', '$ReviewerSubjectTemplate', '$ReviewerBodyTemplate')";
		  mysqli_query ($dbc, $q_update);
		  complete_procedure($dbc);
	  }
     
      mysqli_close($dbc); // Close the database connection.
 }
 
 
if (isset($_SESSION['isEditor'])) { // Only run if logged in role is editor 

$q_settings = "Call spGetEmailSettings;";
				
// Run the query.
if ($r_settings = mysqli_query ($dbc, $q_settings)) { // If it ran OK.

	// Fetch the results and set variables from the array.
	
	$row_display = mysqli_fetch_array($r_settings, MYSQLI_ASSOC);
	$SettingID = $row_display["SettingID"];
	$SettingName = $row_display["SettingName"];
	$AuthorNagEmailDays = $row_display["AuthorNagEmailDays"];
	$AuthorSubjectTemplate = $row_display["AuthorSubjectTemplate"];
	$AuthorBodyTemplate = $row_display["AuthorBodyTemplate"];
	$ReviewerNagEmailDays = $row_display["ReviewerNagEmailDays"];
	$ReviewerSubjectTemplate = $row_display["ReviewerSubjectTemplate"];
	$ReviewerBodyTemplate = $row_display["ReviewerBodyTemplate"];
	
	// end the query and free the connection - expected one line
	
    ignore_remaining_output($r_settings);
	complete_procedure($dbc);
	
}

?>
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
                    <h3 class="title">Configure Reminder Emails</h3>
                </div>
                <div class="box editor_alt">
                    <form method="post">
                        Setting Name: <input type="text" class="regular" name="name" maxlength="200" width="100%" value="<?php echo $SettingName; ?>">
						<h3> Author: </h3>
						Author Reminder Interval (days): <input type="text" class="regular" name="authordays" width="100%" value="<?php echo $AuthorNagEmailDays; ?>">
						<br>
						Subject: <input type="text" class="regular" name="authorsubject" maxlength="50" width="100%" value="<?php echo $AuthorSubjectTemplate; ?>">
						<br>
						Message: <textarea rows="10" maxlength="10000" class="regular" name="authorbody"><?php echo $AuthorBodyTemplate; ?></textarea>
						<h3> Reviewer: </h3>
						Reviewer Reminder Interval (days): <input type="text" class="regular" name="reviewerdays" width="100%" value="<?php echo $ReviewerNagEmailDays; ?>">
						<br>
						Subject: <input type="text" class="regular" name="reviewersubject" maxlength="50" width="100%" value="<?php echo $ReviewerSubjectTemplate; ?>">
						<br>
						Message: <textarea rows="10" maxlength="10000" class="regular" name="reviewerbody"><?php echo $ReviewerBodyTemplate; ?></textarea>
						<br>
						<br>
						<button class="alert buttonform" onclick="location.href='editor_system_settings.php'">Cancel</button>
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