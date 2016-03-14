<style>th {text-align: left;} td {width : 200px;}</style>
<?php $page_title = "Author - Critical Incidents";
/*
    The purpose of this file is for author viewing
    a critical incident to be downloaded
*/
require('../mysqli_connect.php'); // $dbc defined and initialized
require('./include_utils/procedures.php'); // functions complete_procedure()
include ('./includes/header.php'); //Page header and navigation

$SubmissionID = $_GET["SubmissionID"];

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
            <th>Action</th>
        </tr>
    <?php
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["IncidentTitle"]. "</td> <td>" . $row["Abstract"]. "</td> <td>" . $row["Keywords"]. "</td> <td>" . $row["SubmissionDate"]. "<td><a href='download.php?fid=$SubmissionID'>Download</a></td></tr>";
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

$q_AuthorGetSubmissionReviewerFilesList = "Call spAuthorGetSubmissionReviewerFilesList($SubmissionID);"; // Call the procedure
$result = $dbc->query($q_AuthorGetSubmissionReviewerFilesList); // Run the procedure

// If there are files
if ($result->num_rows > 0) { ?>
    <table>
        <tr>
            <th>File Name</th>
            <th>File Size</th>
            <th>File Type</th>
        </tr>
    <?php
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["FileName"]. "</td> <td>" . $row["FileSize"]. "</td> <td>" . $row["FileType"]. "<td><a href='#'>View</a></td></tr>";
    }
    echo "</table>";
} else {
    echo "<tr><td>No Files Available</td></tr>";
}
complete_procedure($dbc);?>
