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
require_once ('../mysqli_connect.php');
require_once ('./include_utils/procedures.php'); // complete_procedure()
?>
<!--Begin Sidebar-->
<aside class="col s3 side white">
    <?php
    if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1) {
        echo '<div class="editor corner"><h3 class="title corner">Editor</h3></div>';
        echo '<ul><li><a href="editor_create_user.php">Create User</a></li>';
        echo '<li><a href="editor_find_users.php">Find User</a></li>';
        echo '<li><a href="editor_user_account_management.php">User Account Management</a></li>';
        echo '<li><a href="editor_incident_management.php">Incident Management</a></li>';
        echo '<li><a href="editor_system_settings.php">System Settings</a></li></ul><br>';
    }

	if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1) {
        echo '<div class="author corner"><h3 class="title">Author</h3></div>';
		echo '<ul><li><a href="submit_critical_incident.php">Submit Critical Incident</a></li>';
        echo '<li><a href="author_view_feedback.php">Review Feedback</a></li></ul><br>';
	}

    if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
        echo '<div class="reviewer corner"><h3 class="title">Reviewer</h3></div>';
        echo '<ul><li><a href="reviewer_incident_management.php">Review Critical Incident</a></li></ul><br>';
	}
	?>
    <div class="alert corner">
        <h3 class="title">Resources</h3>
    </div>
    <ul>
        <div>
            <li><a href="#">Learn how to submit a Critical Incident</a></li>
            <li><a href="teaching_notes.php">Get Purchasing Information for Teaching Notes</a></li>
            <li><a target="_blank" href="https://www.sfcr.org/.">Visit SCR Site</a></li>
            <hr>
        </div>
        <div>
            <h2>Important Dates:</h2>
            <?php
                //Check if users exist
                $results = $dbc->query("Call spGetNextDates('3');"); // Run procedure
                complete_procedure($dbc);

                if ($results->num_rows > 0) {
                    // output data of each row
                    while($row = $results->fetch_assoc()) {
                        echo "<p>" . $row["Description"] . ": " . $row["Date"] . "</p>";
                    }
                } else {
                    echo "There are no upcoming important dates";
                }
            ?>
            <!--<p>Submission Deadline: September 1st</p>
            <p>Journal Publication: October 31st</p>-->
            <hr>
        <div class="scrollable">
            <div>
                <h2>Announcement Title</h2>
                <h4>00/00/0000 Time:Posted PM</h4>
                <p>The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!</p>
            </div>
            <div>
                <h2>Announcement Title</h2>
                <h4>00/00/0000 Time:Posted PM</h4>
                <p>The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!</p>
            </div>
            <div>
                <h2>Announcement Title</h2>
                <h4>00/00/0000 Time:Posted PM</h4>
                <p>The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!The new site is now live! Don't forget to register here for an account if you do not have one already!</p>
            </div>
        </div>
    </ul>
    <br>
</aside>
