<?php
/*
* @File Name:       sidebar.php
* @Description:     Side bar for JCI website
* @PHP version:     Currently Unknown
* @Author(s):		Jacob Cole <colej28@ferris.edu>, Rui Takagi
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
<aside class="col s3 side white">
    <div class="alert corner">
        <h3 class="title">Resources</h3>
    </div>
    <ul>
        <h2>Important Dates:</h2>
        <p>Submission Deadline: September 1st</p>
        <p>Journal Publication: October 31st</p>
        <h2>Important Information</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
		<?php
        if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1) {
            echo '<h3 class="editor title">Editor</h3>';
            echo '<li><a href="editor_create_user.php">Create User</a></li>';
            echo '<li><a href="editor_find_users.php">Find User</a></li>';
            echo '<li><a href="editor_user_account_management.php">User Account Management</a></li>';
            echo '<li><a href="editor_incident_management.php">Incident Management</a></li>';
            echo '<li><a href="editor_system_settings.php">System Settings</a></li><br>';
        }

		if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1) {
            echo '<h3 class="author title">Author</h3>';
			echo '<li><a href="author_view_feedback.php">Review Feedback</a></li>';
            echo '<li><a href="submit_critical_incident.php">Submit Critical Incident</a></li>';
			echo '<li><a href="teaching_notes.php">Get Purchasing Information for Teaching Notes</a></li>';
			echo '<li><a href="https://www.sfcr.org/.">Visit SCR Site</a></li><br>';
		}



        if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
            echo '<h3 class="reviewer title">Reviewer</h3>';
            echo '<li><a href="reviewer_incident_management.php">Review Critical Incident</a></li>';
            echo '<li><a href="review_submission.php">Submit Review</a></li>';
		}
		?>
    </ul>
    <br>
</aside>
