<?php $page_title = 'JCI Website - Reviewer Critical Incident Management';

/*
 * The purpose of this file is to allow the reviewers
 * to view submitted Critical Incidents.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 include ('./includes/header.php'); // Include the site header
 include ('./includes/subnav.php'); // Include subnav
 include ('./include_utils/procedures.php'); // complete_procedure()
?>
<script type="text/javascript"> $( "#reviewer" ).addClass( "active" ); </script>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <?php if (isset($_SESSION['isReviewer'])) { // Only display if logged in role is reviewer

                //temporary until log-in is complete
                $UserID = $_SESSION['UserID'];
                $Year = date("Y");

                $q_ReviewerViewSubmissions = "Call spReviewerViewSubmissions($UserID, $Year);"; // Call to stored procedure
                $result = $dbc->query($q_ReviewerViewSubmissions); // Run procedure

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
                
                // 
                $link_text = 'View';
                if ($row['ReviewStatus'] == 'Reviewing') { $link_text = 'New Review'; }
                else { $link_text = 'Update Review'; }
                
                echo '<tr><td class="span3">' . $row["IncidentTitle"]. '</td>';
                echo '<td class="span3">' . $row["EditorName"]. '</td>';
                echo '<td class="span2">' . $row["SubmissionStatus"]. '</td>';
                echo '<td class="span2">' . $row["SubmissionDate"]. '</td>';
                echo '<td class="span2"><a href="review_submission.php?sid=' . $row["SubmissionID"] .'">' . $link_text . '</a></td></tr>';
            } echo "</table>";
                } else {
                    //if no results found
                    echo "<tr><td>No results</td></tr>";
                }
                complete_procedure($dbc);?>
            </div>
            <?php include 'includes/sidebar.php'; // Include sidebar
    } else { echo "<p>You do not have permission</p>"; } ?>
</div>
</div>
</div>
<?php include 'includes/footer.php'; // Include footer ?>
