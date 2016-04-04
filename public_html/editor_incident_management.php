<?php $page_title = 'JCI Website - Editor Critical Incident Management';

/*
 * The purpose of this file is to allow the editor
 * to view submitted Critical Incidents.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./includes/subnav.php'); // Include subnav
 require ('./include_utils/procedures.php'); // complete_procedure()
?>
<script type="text/javascript"> $( "#editor" ).addClass( "active" ); </script>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <?php if (isset($_SESSION['isEditor'])) { // Only display if logged in role is editor

                    //temporary until log-in is complete
                    $Year = date("Y");

                    $q_EditorViewSubmissions = "Call spEditorViewSubmissions($Year);"; // Call to stored procedure
                    $result = $dbc->query($q_EditorViewSubmissions); // Run procedure

                    //if something is returned
                    if ($result->num_rows > 0) { ?>
                        <table class="editorTable">
                            <tr>
                                <th class="editorTitle">Title</th>
                                <th class="editorName">Editor</th>
                                <th class="authorName">Author(s)</th>
                                <th class="reviewerName">Reviewer(s)</th>
                                <th class="subStatus">Submission Status</th>
                                <th class="subDate">Submission Date</th>
                                <th class="editorAction">Action</th>
                            </tr>
                        <?php
                        // output data of each row
                        while($row = $result->fetch_assoc()) {
                            //Checks for null EditorName
                            if ($row["EditorName"] == "") { $row["EditorName"] = "Unassigned"; }
                            echo '<tr><td class="editorTitle">' . $row["IncidentTitle"]. '</td> <td class="editorName">' . $row["EditorName"]. '</td> <td class="authorName">' . $row["Authors"]. '</td> <td class="reviewerName">' . $row["Reviewers"]. '</td> <td class="subStatus">' . $row["SubmissionStatus"]. '</td> <td class="subDate">' . $row["SubmissionDate"]. '<td class="editorAction"><a href="view_incident.php?SubmissionID=' . $row["SubmissionID"] .'">View</a></td></tr>';
                        }
                        echo "</table>";
                    } else {
                        //if no results found
                        echo "<tr><td>No results</td></tr>";
                    }
                    complete_procedure($dbc);?>
            </div>
            <?php require 'includes/sidebar.php'; // Include sidebar
        } else { echo "<p>You do not have permission</p>"; } ?>
    </div>
</div>
</div>
<?php require 'includes/footer.php'; // Include footer ?>
