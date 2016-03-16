<?php $page_title = 'JCI Website - Author Critical Incident Management';

/*
 * The purpose of this file is to allow the authors
 * to view submitted Critical Incidents.
 */

require ('../mysqli_connect.php'); // Connect to the database
require ('./includes/header.php'); // Include the site header
require ('./includes/subnav.php'); // Include subnav
require ('./include_utils/procedures.php'); // complete_procedure()
?>
<!-- temporary style -->
<style>.subnav .author {height:30px;} th {text-align: left;}</style>
<div id="home-body" class="span9">
    <?php // if (isset($_SESSION['user_id'])) { // Only display if logged in ?>
        <!--Page main body-->
        <div class="span12">
            <div class="revisions">
                <?php

                //temporary until log-in is complete
                $UserID = 1;
                $Year = date("Y");

                $q_AuthorViewSubmissions = "Call spAuthorViewSubmissions($UserID, $Year);"; // Call to stored procedure
                $result = $dbc->query($q_AuthorViewSubmissions); // Run procedure

                //if something is returned
                if ($result->num_rows > 0) { ?>
                    <table class="span12">
                        <tr>
                            <th class="span3">Incident Title</th>
                            <th class="span3">Editor Name</th>
                            <th class="span3">Submission Status</th>
                            <th class="span2">Submission Date</th>
                            <th class="span1">Action</th>
                        </tr>
                    <?php
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        //Checks for null EditorName
                        if ($row["EditorName"] == "") { $row["EditorName"] = "Unassigned"; }
                        echo '<tr><td class="span3">' . $row["IncidentTitle"]. '</td> <td class="span3">' . $row["EditorName"]. '</td> <td class="span3">' . $row["SubmissionStatus"]. '</td> <td class="span2">' . $row["SubmissionDate"]. '<td class="span1"><a href="author_view_incident.php?SubmissionID=' . $row["SubmissionID"] .'">View</a></td></tr>';
                    }
                    echo "</table>";
                } else {
                    //if no results found
                    echo "<tr><td>No results</td></tr>";
                }
                complete_procedure($dbc);?>
            </div>
        </div>
    <?php // } else { echo "<p>You do not have permission</p>"; }?>
</div>
<?php
require 'includes/sidebar.php'; // Include sidebar
require 'includes/footer.php'; // Include footer
?>
