<?php $page_title = "Author - Critical Incidents";
/*
    The purpose of this file is for author viewing
    a critical incident to be downloaded
*/
require ('../mysqli_connect.php'); // $dbc defined and initialized
include ('./includes/header.php'); //Page header and navigation
require ('./includes/subnav.php'); // Dashboard navigation
require ('./include_utils/procedures.php'); // functions complete_procedure()

$SubmissionID = $_GET["SubmissionID"];
?>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <?php
            $q_SubmissionGetInfo = "Call spSubmissionGetInfo($SubmissionID);"; // Call the procedure
            $result = $dbc->query($q_SubmissionGetInfo); // Run the procedure

            // If there is one Incident
            if ($result->num_rows == 1) { ?>
                <table>
                    <tr>
                        <th>Incident Title</th>
                        <th>Abstract</th>
                        <th>Keywords</th>
                        <th>Submission Date</th>
                    </tr>
                <?php
                // output data of each row
                while($row = $result->fetch_assoc()) {
                    echo "<tr><td>" . $row["IncidentTitle"]. "</td> <td>" . $row["Abstract"]. "</td> <td>" . $row["Keywords"]. "</td> <td>" . $row["SubmissionDate"]. "</tr>";
                }
                echo "</table>";
            } elseif ($result->num_rows > 1) {
                // If there is two incidents with the same id
                echo "<p>An Error Occurred.</p>";
            } else {
                // If there is no incidents with the id
                echo "<p>Incident Not Found.</p>";
            }
            complete_procedure($dbc);

            $q_AuthorGetSubmissionReviewerFilesList = "Call spSubmissionGetFilesList($SubmissionID);"; // Call the procedure
            $result = $dbc->query($q_AuthorGetSubmissionReviewerFilesList); // Run the procedure

            // If there are files
            if ($result->num_rows > 0) { ?>
                <table>
                    <tr>
                        <th>File Name</th>
                        <th>File Size</th>
                        <th>File Type</th>
                        <th>Action</th>
                    </tr>
                <?php
                // output data of each row
                while($row = $result->fetch_assoc()) {
                    echo "<tr><td>" . $row["FileName"]. "</td> <td>" . $row["FileSize"]. "</td> <td>" . $row["FileType"]. "<td><a href='download.php?fid=" . $row["FileMetaDataID"] . "'>Download</a></td></tr>";
                }
                echo "</table>";
            } else {
                echo "<tr><td>No Files Available</td></tr></table>";
            }
            complete_procedure($dbc);?>
            <script type="text/javascript"> $( "#author" ).addClass( "active" ); </script>
        </div>
        <!--Sidebar-->
        <?php include 'includes/sidebar.php'; ?>
    </div>
</div>
<!--Footer-->
<?php include 'includes/footer.php'; ?>
