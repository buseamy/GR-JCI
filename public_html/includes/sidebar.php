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
<aside class="col s3 side white">
	<h2>Resources</h2>
    <ul>
		<?php
		if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1) {
			echo '<li><a href="submit_critical_incident.php">Submit a Critical Incident</a></li>';
		} else {
			echo '<li><a href="login.php">Submit a Critical Incident</a></li>';
		}
		if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1) {
			echo '<li><a href="editor_incident_management.php">Manage Critical Incidents</a></li> <!--Case Management-->';
		} else if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
			echo '<li><a href="reviewer_incident_management.php">Manage Critical Incidents</a></li> <!--Case Management-->';
		} else if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1) {
			echo '<li><a href="author_incident_management.php">Manage Critical Incidents</a></li> <!--Case Management-->';
		} else {
			echo '<li><a href="login.php">Manage Critical Incidents</a></li> <!--Case Management-->';
		}
		?>
        <li><a href="#">Resource 3</a></li>
        <li><a href="#">Resource 4</a></li>
        <li><a href="#">Resource 5</a></li>
    </ul>
    <br>
    <h2>Important Dates:</h2>
    <p>Submission Deadline: September 1st</p>
    <p>Journal Publication: October 31st</p>
    <br>
    <h2>Important Information</h2>
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
</aside>
