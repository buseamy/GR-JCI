 <?php
/*
* @File Name:		teaching_notes.php
* @Description: 	Displays information on teaching notes. All user can access this page
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/



$page_title = 'Teaching Notes'; //Page title
include ('includes/header.php'); // Include the heade
?>

<div class="content">
    <img class="responsive" src="images/glasses.jpg" alt="reading glasses and book">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
			<h1>Purchasing Information for Teaching Notes</h1>
			<!--Page main body-->
			<div id="home_about">

			<p>
			Please contact Joanne Tokle <b>(tokljoan@isu.edu)</b> to purchase Teaching Notes.
			</p>

			</div>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>
<?php include ('includes/footer.php'); ?>
