<?php $page_title = 'JCI Website - Dashboard';

/*
 * The purpose of this file is to allow the authors
 * to submit a case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./includes/subnav.php'); // Dashboard navigation
 require ('./include_utils/procedures.php'); // complete_procedure()

?>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <div class="contentwidth">
                <br><br>
                <div class="row">
                    <div class="col s10 frames">
                        <div class="author roundcorner">
                            <h3 class="title">Author</h3>
                        </div>
                        <div class="boxsmall author_alt">
                            <progress max="100" value="50"></progress>
                            <p class="authordash percent">50%</p>
                            <p class="authordash">of publishing<br>process complete</p>
                        </div>
                    </div>
                </div>
                <br>
                <br>
                <div class="row">
                    <div class="col s5 frames">
                        <div class="editor roundcorner">
                            <h3 class="title">Editor</h3>
                        </div>
                        <div class="box editor_alt">
        					<div class="editorlinks">
        	                    <p class="editordash">3 Papers Ready for Proofreading</p>
        	                    <p class="editordash">5 Papers Need Reviewing</p>
        	                    <p class="editordash">2 Users Need to be Assigned</p>
        					</div>
                        </div>
                    </div>
                     <div class="col s5 frames">
                        <div class="reviewer roundcorner">
                            <h3 class="title">Review</h3>
                        </div>
                        <div class="box reviewer_alt">
        					<div class="editorlinks">
        	                    <p class="reviewdashnum">2</p>
        						<p class="reviewdash">Papers to Review</p>
        					</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer ?>
