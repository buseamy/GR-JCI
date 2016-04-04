<?php $page_title = 'JCI Website - Contact Us';

/*
 * The purpose of this file is to allow user and visitors of the site to email comments to the editors.
 */


 require ('./includes/header.php'); // Include the site header
 
 if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      require ('../mysqli_connect.php'); // Connect to the database
      require ('./include_utils/procedures.php'); // complete_procedure()
      require ('./include_utils/email_functions.php');
      
      $errors = array(); // Initialize an error array.
      
      if (!empty($_POST['Name'])) {
          $Name = $_POST['Name'];
      } else {
          $errors[] = 'Please provide a name';
      }
      
      if (!empty($_POST['Email'])) {
          $Email = $_POST['Email'];
      } else {
          $errors[] = 'Please provide an email address';
      }
      
      if (!empty($_POST['Phone'])) {
          $Phone = $_POST['Phone'];
      } else {
          $Phone = '';
      }
      
      if (!empty($_POST['Comment'])) {
          $Comments = $_POST['Comment'];
      } else {
          $errors[] = 'Please provide a comment';
      }
      
      if (empty($errors)) { // If everything's OK.
        $Message = '<html><body>Editors,<br />&nbsp;&nbsp;A user made a comment on the JCI website.<br /><br />&nbsp;&nbsp;Name: '.$Name.'<br />&nbsp;&nbsp;Email: '.$Email.'<br />Phone: '.$Phone.'<br />&nbsp;&nbsp;Comment:<br />'.$Comment.'</body></html>';
        
        //Send the email
        sendCommentEmail($dbc,$Message);
        
        mysqli_close($dbc); // Close the database connection.
        
        // Redirect:
        redirect_user('index.php');
      } else {
        echo '<h1>Error!</h1><p class="error">The following error(s) occurred:<br />';
		foreach ($errors as $msg) { // Print each error.
			echo " - $msg<br />\n";
		}
		echo '</p><p>Please try again.</p><p><br /></p>';
        
        mysqli_close($dbc); // Close the database connection.
      }
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
                <div class="editor roundcorner">
                    <h3 class="title">Contact</h3>
                </div>
                <div class="box editor_alt">
                    <input type="text" class="regular inputForm" placeholder="Name" name="Name" width="100%" value="">
                    <input type="text" class="regular inputForm" placeholder="Email" name="Email" width="100%" value="">
                    <input type="text" class="regular inputForm" placeholder="Phone" name="Phone" width="100%" value="">
                    <textarea placeholder="Comments" rows="10" name="Comment" ></textarea>
					<button class="editor buttonform" type="button">Send</button>
                </div>
            </div>
    	</div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer ?>