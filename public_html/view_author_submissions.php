<?php
$page_title = 'View Critical Incident Submissions';
if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}
// Purpose: List Author submissions for the Editor to check the files
//      - 

require('../mysqli_connect.php');
require('./include_utils/procedures.php');

// extra processing stuff - shouldn't need here
$error = false;
$incomplete = false;
$success = false;
$errorloc = '';
$errors = array();
$sub_title = '';

$errorloc = 'validating permissions';
if (!isset($_SESSION['is_editor']) && !$_SESSION['is_editor']) {
    $error = true;
    array_push($errors, 'Only an Editor has permissions to access this page.');
}

// different action links based on this type
// asgned - assign editor
// updsub - update submission files
// asgnrev - assign reviewer
// updrev - update review files for submission
// pubsub - publish submission
$type = '';
if (isset($_GET['type'])) {
    $type = $_GET['type'];
}
// TODO: refactor to actually use this type, default as the author-submission-file update for now
$type = 'updsub';

// Processing
$errorloc = 'retrieving submissions';
$author_submissions = array();
$year = date("Y");
$q_submissions = "CALL spEditorViewSubmissions($year);";
if ($r_submissions = mysqli_query($dbc, $q_submissions))
{
    while ($row_submissions = mysqli_fetch_array($r_submissions, MYSQLI_ASSOC)) {
        $status = $row_submissions['SubmissionStatus'];
        $push = false;
        if ($type == '') {
            $push = true;
        }
        elseif ($type == 'asgned') {
            $push = ($status == 'Submitted' || $status == 'Editor Assigned');
        }
        elseif ($type == 'updsub') {
            $push = ($status == 'Editor Assigned' || $status == 'Editor Updated');
        }
        elseif ($type == 'asgnrev') {
            $push = ($status == 'Editor Updated' || $status == 'Reviewers Assigned');
        }
        elseif ($type == 'updrev') {
            $push = ($status == 'Reviews Completed' || $status == 'Editor Reviewed');
        }
        elseif ($type == 'pubsub') {
            $push = ($status == 'Ready For Publish');
        }
        else {
            $errorloc = 'navigating to this page';
            $error = true;
            array_push($errors, 'Invalid list type given.');
        }
        if ($push) { array_push($author_submissions, $row_submissions); }
    }
    complete_procedure($dbc);
}
else {
    $error = true;
    array_push($errors, $dbc->error);
}

// Display section
include('./includes/header.php');
include('./includes/subnav.php');
echo "<script type=\"text/javascript\"> $( \"#editor\" ).addClass( \"active\" ); </script>";
echo "<div class=\"contentwidth row flush\">\r\n";
echo "    <div class=\"contentwidth row flush col s7\">\r\n";

if (count($author_submissions) > 0) {
    echo "        <table class=\"editorTable\">\r\n";
    echo "            <tr>\r\n";
    echo "                <th class=\"editorTitle\">Title</th>\r\n";
    echo "                <th class=\"editorName\">Editor</th>\r\n";
    echo "                <th class=\"authorName\">Author(s)</th>\r\n";
    echo "                <th class=\"subStatus\">Submission Status</th>\r\n";
    echo "                <th class=\"subDate\">Submission Date</th>\r\n";
    echo "                <th class=\"editorAction\">Action</th>\r\n";
    echo "            </tr>\r\n";
    
    foreach ($author_submissions as $submission) {
        $status = $submission['SubmissionStatus'];
        echo "            <tr>\r\n";
        echo "                <td class=\"editorTitle\">" . $submission['IncidentTitle'] . "</td>\r\n";
        echo "                <td class=\"editorName\">" . $submission['EditorName'] . "</td>\r\n";
        echo "                <td class=\"authorName\">" . $submission['Authors'] . "</td>\r\n";
        echo "                <td class=\"subStatus\">" . $status . "</td>\r\n";
        echo "                <td class=\"subDate\">" . $submission['SubmissionDate'] . "</td>\r\n";
        // TODO: use different links and link text for different types
        echo "                <td class=\"editorAction\"><a href=\"manage_author_submission.php?sid=" . $submission['SubmissionID'] . "\">Manage Submission Files</a></td>\r\n";
        echo "            </tr>\r\n";
    }
    echo "        </table>\r\n";
}
else {
    echo "        <p>No Results</p>\r\n";
}


// Handle error messages
if ($error) {
    // print errors
    if ($error) {
        echo "        <p class=\"error\">The following issues occurred while $errorloc:\r\n";
    }
    foreach ($errors as $msg) {
        echo "            <br /> - $msg\r\n";
    }
    echo "        </p>\r\n";
}
echo "    </div>\r\n";
include('./includes/sidebar.php');
echo "</div>\r\n";
include('./includes/footer.php');

?>