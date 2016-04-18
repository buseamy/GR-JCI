<?php $page_title = 'JCI Website - Contact Us';

/* Created By: Jeff Ballard
 * On: 2-Apr-2016
 * The purpose of this file is to allow user and visitors of the site to email comments to the editors.
 */


 require ('./includes/header.php'); // Include the site header
 $errors = array(); // Initialize an error array.
 $Name = '';
 $Email = '';
 $Phone = '';
 $Comment = '';
 
 if ($_SERVER['REQUEST_METHOD'] == 'POST') {
     require('./include_utils/login_functions.php');
     require ('../mysqli_connect.php'); // Connect to the database
     require ('./include_utils/procedures.php'); // complete_procedure()
     require ('./include_utils/email_functions.php');
     
     $Name = trim($_POST['Name']);
     $Email = trim($_POST['Email']);
     $Phone = trim($_POST['Phone']);
     $Comment = trim($_POST['Comment']);
     
     if (empty($Name)) {
         $errors[] = 'Please provide a name';
     }
     
     if (!empty($Email)) {
        if (!filter_var($Email, FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'Please provide a valid email address';
        }
     } else {
         $errors[] = 'Please provide an email address';
     }
     
     if (!empty($Phone)) {
         if (strlen($Phone) < 14) {
             $errors[] = 'Please provide a full phone number';
         } else {
             $PhoneTmp = str_replace('(', '', str_replace(')', '', str_replace(' ', '', str_replace('-', '', $Phone))));
             if ((strlen($PhoneTmp) != 10) || (!is_numeric($PhoneTmp))) {
                 $errors[] = 'Please provide a valid phone number';
             }
         }
     }
     
     if (empty($Comment)) {
         $errors[] = 'Please provide a comment';
     }
     
     if (empty($errors)) { // If everything's OK.
       $Message = '<html><body>Editors,<br />&nbsp;&nbsp;A user made a comment on the JCI website.<br /><br />&nbsp;&nbsp;Name: '.$Name.'<br />&nbsp;&nbsp;Email: '.$Email.'<br />&nbsp;&nbsp;Phone: '.$Phone.'<br />&nbsp;&nbsp;Comment:<br />'.$Comment.'</body></html>';
       
       //Send the email
       sendCommentEmail($dbc,$Message);
       
       mysqli_close($dbc); // Close the database connection.
       
       // Redirect:
       redirect_user('index.php');
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
                    <h3 class="title">Contact</h3>
                </div>
                <div class="box editor_alt">
                    <form method="post">
                        <input type="text" class="regular inputForm" placeholder="Name" name="Name" maxlength="50" width="100%" value="<?php echo $Name; ?>">
                        <input type="text" class="regular inputForm" placeholder="Email" name="Email" maxlength="200" width="100%" value="<?php echo $Email; ?>">
                        <input type="text" class="regular inputForm" placeholder="Phone: (###) ###-####" name="Phone" maxlength="14" width="100%" value="<?php echo $Phone; ?>">
                        <textarea placeholder="Comments" rows="10" name="Comment"><?php echo $Comment; ?></textarea>
                        <button class="editor buttonform" type="submit">Send</button>
                    </form>
                </div>
            </div>
    	</div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer ?>