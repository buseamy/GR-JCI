<?php $page_title = 'JCI Website - Process Submission';

/*
 * The purpose of this file is to process
 * the submited case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./include_utils/procedures.php'); // complete_procedure()

$Error = false;
$PreviousSubmissionID = "NULL";
$SubmissionNumber = 1;
$UserID = $_SESSION['UserID'];

//Collect and validate data from submission
if(!isset($_POST['title']) || strlen(trim($_POST['title'])) == 0){
    echo 'No title provided<br/>';
    $Error = true;
} else {
    $IncidentTitle = $_POST['title'];
}
$MemberCode = $_POST['memberCode'];
$counter = $_POST['counter'];
if(!isset($_POST['email']) || strlen(trim($_POST['email'])) == 0){
    echo 'No email address provided<br/>';
    $Error = true;
} elseif ($counter == 1) {
    $Email = $_POST['email'];
} else {
    $Email = $_POST['email'];
    $count = $counter;
    while ($count > 1) {
        if (!isset($_POST['email'.$count])|| strlen(trim($_POST['email'.$count])) == 0){
            $Error = true;
            echo "Please provide all author email addresses";
        } else {
            ${'Email' . $count} =$_POST['email'.$count];
        }
        $count--;
    }
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

// Check if authors are registered users
if($Error == false) {
    $count = $counter;
    while ($count > 1 && $Error == false) {

        //Check if users exist
        $results = $dbc->query("Call spSearchGetUsersEmail('${'Email' . $count}');"); // Run procedure
        complete_procedure($dbc);

        if ($results->num_rows > 0) {
            // output data of each row
            while($row = $results->fetch_assoc()) {
                ${'AdditionalAuthorUserID' . $count} = $row["UserID"];
            }
        } else {
            echo "Author " . $count . " not found";
            $Error = true;
        }
        $count--;
    }
}

if (isset($_POST['submit']) && $Error == false) {
    // create the initial submission
    $q_AuthorCreateSubmission = "Call spAuthorCreateSubmission($UserID, '$IncidentTitle', '$Abstract', '$KeyWords', $PreviousSubmissionID, $SubmissionNumber);"; // Call to stored procedure
    $results = $dbc->query($q_AuthorCreateSubmission); // Run procedure

    //if nothing is returned
    if (!$results){
        $Error = true;
    } else { //if something is returned
        // output data of each row
        while($row = $results->fetch_assoc()) {
            $SubmissionID = $row["SubmissionID"];
        }
    }
    complete_procedure($dbc); // Complete SP Create submission
    // If submission creation was successful
    if (!$SubmissionID) {
        $Error = true;
    } elseif($Error == false) {
        $count = $counter;
        while ($count > 1 && $Error == false) {
            $PrimaryContact = 0;
            $AdditionalAuthorUserID = ${'AdditionalAuthorUserID' . $count};
            $checkAuthor = $dbc->query("Call spAuthorAddToSubmission('$AdditionalAuthorUserID', '$SubmissionID', '$PrimaryContact');"); // Run procedure
            complete_procedure($dbc);
            if ($checkAuthor == false) {
                echo "problem with spAuthorAddToSubmission";
                $Error = true;
            }elseif (is_bool($checkAuthor) === false){
                while($checkAuthorRow = $checkAuthor->fetch_assoc()) {
                    if ($checkAuthorRow["Error"] == true){
                        echo "The following errors occured with spAuthorAddToSubmission: <br>";
                        echo $checkAuthorRow["Error"];
                        $Error = true;
                    }
		        }
            }elseif ($checkAuthor == true) {
                echo "success adding author";
            }
            $count--;
        }
    }
    if ($Error == false) {
        // run Submission Update if there are no errors
        $checkSubmission = $dbc->query("Call spAuthorUpdateSubmission('$SubmissionID', '$IncidentTitle', '$Abstract', '$KeyWords', '$SubmissionNumber');");
        complete_procedure($dbc);

        if ($checkSubmission == false) {
            echo "problem with spAuthorAddToSubmission";
            $Error = true;
        }elseif (is_bool($checkSubmission) === false){
            while($checkSubmissionRow = $checkSubmission->fetch_assoc()) {
                if ($checkSubmissionRow["Error"] == true){
                    echo "The following errors occured with spAuthorUpdateSubmission: <br>";
                    echo $checkSubmissionRow["Error"];
                    $Error = true;
                }
            }
        }elseif ($checkSubmission == true) {
            echo "success updating submission";
        }
    }
}else { echo "Error with submission.";}
require "./includes/footer.php";
 ?>
