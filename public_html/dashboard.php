<?php $page_title = 'JCI Website - Submit a Critical Incident';

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

        </div>
        <?php require 'includes/sidebar.php'; // Include sidebar ?>
    </div>
</div>
<?php require 'includes/footer.php'; // Include footer ?>
