<?php
/*
* @File Name:       sidebar.php
* @Description:     Side bar for JCI website
* @PHP version:     Currently Unknown
* @Author(s):		Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/08/2016
*/

/*
 * The purpose of this file is to acts as a single sidebar to be included on
 * pages throughout the site. The sidebar will hold important links and
 * information based on the user type logged in.
 */
?>
<!--Begin Sidebar-->
<aside class="col s3 side white" style="height:900px;">
	<div class="alert corner">
		<h3 class="title">Information</h3>
	</div>
	<h2>Important Dates:</h2>
	<p>Submission Deadline: September 1st</p>
	<p>Journal Publication: October 31st</p>
	<h2>Important Information</h2>
	<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
	<ul>
		<?php
		if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1) {
			echo '<h3 class="title editor">Editor</h3><br>';
			echo '<li><a href="editor_create_user.php">Create User</a></li>';
			echo '<li><a href="editor_find_users.php">Find User</a></li>';
			echo '<li><a href="editor_user_account_management.php">User Account Management</a></li>';
			echo '<li><a href="editor_incident_management.php">Critical Incident Management</a></li>';
			echo '<li><a href="editor_system_settings.php">System Settings</a></li><br>';
		}

		if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
			echo '<h3 class="title reviewer">Reviewer</h3><br>';
			echo '<li><a href="reviewer_incident_management.php">Review Critical Incidents</a></li>';
			echo '<li><a href="review_submission.php">Submit Review</a></li><br>';
		}

		if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1) {
			echo '<h3 class="title author">Author</h3><br>';
			echo '<li><a href="#">Review Feedback</a></li>';
			echo '<li><a href="submit_critical_incident.php">Submit Critical Incident</a></li><br>';
		}
		?>

    </ul>
</aside>
