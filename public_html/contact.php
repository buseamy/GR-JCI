<?php $page_title = 'JCI Website - Contact Us';

/*
 * The purpose of this file is to allow the authors
 * to submit a case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./include_utils/procedures.php'); // complete_procedure()

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
                    <input type="text" class="regular inputForm" placeholder="Email" width="100%" value="">
                    <textarea placeholder="Comments" rows="10"></textarea>
					<button class="editor buttonform" type="button">Send</button>
                </div>
            </div>
    	</div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer ?>
