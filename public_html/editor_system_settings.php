<?php 

// Include the header:
$page_title = 'Editor System Settings';
include ('includes/header.php');

?>

<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
			<h1>Editor System Settings</h1>
				<ul>
					<li><button class="editor" type="button" onClick="#" >Change Date Allowed for Critical Incident Submission</button></li>
					<p><li><button class="editor" type="button" onClick="location.href='editor_configure_submission_dates.php'" >Configure Review Open and Closing Dates</button></li></p>
					<li><button class="editor" type="button" onClick="#" >Configure Reminder Email Intervals</button></li>
					<li><p><button class="editor" type="button" onClick="#" >Run Reports</button></p></li>
				</ul>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>
<?php include ('includes/footer.php'); ?>

