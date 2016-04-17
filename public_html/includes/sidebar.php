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
include_once ('./include_utils/date_conversion.php'); // convert_from($date) for display

$sb_uid = -1;
if (isset($_SESSION['UserID'])) {
    $sb_uid = $_SESSION['UserID'];
}
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
	}

    if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1) {
        echo '<div class="reviewer corner"><h3 class="title">Reviewer</h3></div>';
        echo '<ul><li><a href="reviewer_incident_management.php">Review Critical Incident</a></li></ul><br>';
	}
	?>
    <div class="alert corner">
        <h3 class="title">Resources</h3>
    </div>
        <div>
            <ul>
                <li><a href="#">Learn how to submit a Critical Incident</a></li>
                <li><a href="teaching_notes.php">Get Purchasing Information for Teaching Notes</a></li>
                <li><a target="_blank" href="https://www.sfcr.org/.">Visit SCR Site</a></li>
            </ul>
            <hr>
        </div>
        <div>
            <h2>Important Dates:</h2>
            <?php
                //Check if users exist
                $nextDates = $dbc->query("Call spGetNextDates('3');"); // Run procedure
                complete_procedure($dbc);

                if ($nextDates->num_rows > 0) {
                    // output data of each row
                    while($row_dates = $nextDates->fetch_assoc()) {
                        echo "<p>" . $row_dates["Description"] . ": " . $row_dates["Date"] . "</p>";
                    }
                } else {
                    echo "There are no upcoming important dates";
                }
            ?>
            <!--<p>Submission Deadline: September 1st</p>
            <p>Journal Publication: October 31st</p>-->
        </div>
        <?php // ANNOUNCEMENTS
        // class to denote level, ordered by role level
        // TODO: confirm whether announcements section coloring should change based on role
        $sb_role = 'guest';
        if (isset($_SESSION['isAuthor']) && $_SESSION['isAuthor'] == 1) { $sb_role = 'author'; }
        if (isset($_SESSION['isReviewer']) && $_SESSION['isReviewer'] == 1) { $sb_role = 'reviewer'; }
        if (isset($_SESSION['isEditor']) && $_SESSION['isEditor'] == 1) { $sb_role = 'editor'; }

        // escape-characters to match formatting in surrounding HTML
        echo "\r\n\t\t<div class=\"$sb_role corner\"><h3 class=\"title\">Announcements</h3></div>\r\n";

        // can be echoed more readily in case debugging is needed
        $q_announcements = "CALL spGetAnnouncements($sb_uid);";
        if ($r_announcements = mysqli_query($dbc, $q_announcements)) {
            if ($r_announcements->num_rows > 0) {
                echo "\t\t<div class=\"";
                if ($r_announcements->num_rows > 1) { echo "scrollable"; }
                echo "\">\r\n";
                echo "\t\t\t<ul>\r\n";
                while ($row_announcements = mysqli_fetch_array($r_announcements, MYSQLI_ASSOC)) {
                    $sb_title = $row_announcements['Title'];
                    $sb_msg = $row_announcements['Message'];
                    $sb_postdate = convert_from($row_announcements['CreateDate']);
                    $sb_expiredate = $row_announcements['ExpireDate'];
                    if ($sb_expiredate != '') { $sb_expiredate = convert_from($sb_expiredate); }

                    // TODO: handle expired announcements - here or stored-procedure

                    echo "\t\t\t<li><div>\r\n";
                    echo "\t\t\t\t<h2>$sb_title</h2>\r\n";
                    echo "\t\t\t\t<h4>$sb_postdate</h4>\r\n";
                    echo "\t\t\t\t<p>$sb_msg</p>\r\n";
                    echo "\t\t\t</div></li>\r\n";
                }
                echo "\t\t\t</ul>\r\n";
            }
            else {
                echo "\t\t<div>\r\n";
                echo "\t\t\t<h2>No Announcements</h2>\r\n";
            }
            complete_procedure($dbc);
        }
        else {
            echo "\t\t<div>\r\n";
            echo "\t\t\t<h2>Announcement Retrieval Failed</h2>\r\n";
        }
        echo "\t\t</div>\r\n";
        ?>
    <br />
</aside>
