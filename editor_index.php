<?php
/*
* @File Name:       Editor_index.php
* @Description:     Editor homepage for JCI website
* @PHP version:     Currently Unknown
* @Author(s):		Jonathan Sankey copyed from Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/11/2016
*/

/*
 * The purpose of this file is to acts as a placeholder for the Editor's page.
 * The Editor_index file will contain an includes for the header and footer.
 */

//Title to be displayed for the page
$page_title = 'JCI Website - Editor Home';

// Call to the site header
include ('./includes/header.php');
?>

<div id="mainhead" class="span8">
    <h1>Welcome Editor</h1>
    <!--Page main body-->
    <a href="editor_create_user.php" class="button">Create User</a>
</div>

<!-- will the side bar be needed for this page?-->
<!--Sidebar-->
<?php  include 'includes/sidebar.php';?>
<!--Footer-->
<?php include 'includes/footer.php'; ?>

