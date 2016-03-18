<?php $page_title = 'JCI Website - Process Submission';

/*
 * The purpose of this file is to allow the authors
 * to submit a case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./include_utils/procedures.php'); // complete_procedure()

$Error = false;
$PreviousSubmissionID = NULL;
$SubmissionNumber = 1;
$UserID = $_SESSION['UserID'];

//Collect data from submission and validate
if(!isset($_POST['title']) || strlen(trim($_POST['title'])) == 0){
    echo 'No title provided<br/>';
    $Error = true;
} else {
    $IncidentTitle = $_POST['title'];
}
$MemberCode = $_POST['memberCode'];
if(!isset($_POST['email']) || strlen(trim($_POST['email'])) == 0){
    echo 'No email address provided<br/>';
    $Error = true;
} else {
    $Email = $_POST['email'];
}
if(!isset($_POST['authorFirst']) || strlen(trim($_POST['authorFirst'])) == 0){
    echo 'No Author First Name provided<br/>';
    $Error = true;
} else {
    $AuthorFirst = $_POST['authorFirst'];
}
if(!isset($_POST['authorLast']) || strlen(trim($_POST['authorLast'])) == 0){
    echo 'No Author Last Name provided<br/>';
    $Error = true;
} else {
    $AuthorLast = $_POST['authorLast'];
}
$counter = $_POST['counter'];
if(!isset($_POST['coverPage']) || strlen(trim($_POST['coverPage'])) == 0){
    echo 'No Cover Page provided<br/>';
    $Error = true;
} else {
    $CoverPage = $_POST['coverPage'];
}
if(!isset($_POST['criticalIncident']) || strlen(trim($_POST['criticalIncident'])) == 0){
    echo 'No Critical Incident provided<br/>';
    $Error = true;
} else {
    $CriticalIncident = $_POST['criticalIncident'];
}
if(!isset($_POST['teachingNotes']) || strlen(trim($_POST['teachingNotes'])) == 0){
    echo 'No Teaching Notes provided<br/>';
    $Error = true;
} else {
    $TeachingNotes = $_POST['teachingNotes'];
}
if(!isset($_POST['memo']) || strlen(trim($_POST['memo'])) == 0){
    echo 'No Memo provided<br/>';
    $Error = true;
} else {
    $Memo = $_POST['memo'];
}
$Summary = $_POST['summary'];
$KeyWords = $_POST['keywords'];
$Abstract = $_POST['abstract'];


if (isset($_POST['submit']) && $Error == false) {

    $q_AuthorCreateSubmission = "Call spAuthorCreateSubmission($UserID, $IncidentTitle, $Abstract, $KeyWords, $PreviousSubmissionID, $SubmissionNumber);"; // Call to stored procedure
    $results = $dbc->query($q_AuthorCreateSubmission); // Run procedure

    //if nothing is returned
    if (!$results){
        echo "nothing returned";
    } else { //if something is returned
        // output data of each row
        while($row = $results->fetch_assoc()) {
            $SubmissionID = $row["SubmissionID"];
            echo $SubmissionID;
        }
    }
} else { echo "Error with submission.";}
 ?>
