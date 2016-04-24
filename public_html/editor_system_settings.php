<?php 
/*
* @File Name:		editor_system_settings.php
* @Description: 	The system settings page for the editor. Contains the links for changing dates
* @PHP version: 	Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:	Ferris State University
* @Last updated:	
*/


$page_title = 'Editor System Settings'; // The page title
include ('includes/header.php'); //Includes the header
require ('./includes/subnav.php'); // Include subnav
?>

<script type="text/javascript"> $( "#editor" ).addClass( "active" ); </script>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
			<h1>Editor System Settings</h1>
				<ul>
					<li><button class="editor" type="button" onClick="#" >Change Date Allowed for Critical Incident Submission</button></li>
					<p><li><button class="editor" type="button" onClick="location.href='editor_configure_submission_dates.php'" >Configure Review Open and Closing Dates</button></li></p>
					<li><button class="editor" type="button" onClick="#" >Configure Reminder Email Intervals</button></li>
				</ul>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>
<?php include ('includes/footer.php'); ?>

