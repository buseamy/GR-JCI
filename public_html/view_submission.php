<?php
/*
Purpose: this file is the display page for a chosen submission
    this page could potentially be used as a user-generic landing page for viewing a critical incident
*/
$error = false;
$errors = array();

// expected valid roles are guest, author, reviewer, and editor
// default to invalid id and false is_role for guests
$uid = -1;
$is_author = false;
$is_reviewer = false;
$is_editor = false;
if (isset($_SESSION)) {
    if (isset($_SESSION['id'])) {
        $uid = $_SESSION['id'];
    }
    if (isset($_SESSION['is_author'])) {
        $is_author = $_SESSION['is_author'];
    }
    if (isset($_SESSION['is_reviewer'])) {
        $is_reviewer = $_SESSION['is_reviewer'];
    }
    if (isset($_SESSION['is_editor'])) {
        $is_editor = $_SESSION['is_editor'];
    }
}

$case_id = -1;
if (isset($_GET) && isset($_GET['cid'])) {
    $case_id = $_GET['cid'];
}
else {
    $error = true;
    array_push($errors, "This page was accessed without a selected submission.");
}

// create_download_link(int:fid, string:display, int:bytes)
require('./include_utils/files.php');
// complete_procedure(dbc)
// ignore_remaining_output(result)
require('./include_utils/procedures.php');
require('../mysqli_connect.php');
$file_list = array();
$input_list = array();

if (!$error) {
    
    if ($is_reviewer || $is_editor) {
        // get list of files attached to this submission by author for reviewer - prioritize latest submission
        // FTR - file-type-role, get file-list for author submissions
        $q_getFiles = "SELECT FM.FileMetaDataID, FM.FileName, FM.FileSize, FT.FileType
            FROM FileMetaData AS FM
            INNER JOIN FileTypes AS FT ON (FM.FileTypeID = FT.FileTypeID)
            INNER JOIN Roles AS FTR ON (FT.RoleID = FTR.RoleID)
            INNER JOIN SubmissionFiles AS SF ON (FM.FileMetaDataID = SF.FileMetaDataID)
            INNER JOIN Reviewers AS R ON (SF.SubmissionID = R.SubmissionID)
            
            WHERE FTR.RoleTitle = 'Author'
            AND SF.SubmissionID = $case_id
            AND R.ReviewerUserID = $uid;";
        if ($r_getFiles = mysqli_query($dbc, $q_getFiles)) {
            if (mysqli_num_rows($r_GetFiles) < 1) {
                $error = true;
                array_push($errors, "No accessible files were found for this submission.");
            }
            while ($row_getFiles = mysqli_fetch_array($r_getFiles, MYSQLI_ASSOC)) {
                array_push($file_list, $row_getFiles);
            }
            //complete_procedure($dbc);
        }
        else {
            $error = true;
            array_push($errors, "Unable to request files for this submission.");
        }
    }
    
    if (!$is_author && !$is_reviewer && !$is_editor) {
        // get list of files attached to this submission for the guest if the critical incident is published
        $q_getFiles = "SELECT FM.FileMetaDataID, FM.FileName, FM.FileSize, FT.FileType
            FROM FileMetaData AS FM
            INNER JOIN FileTypes AS FT ON (FM.FileTypeID = FT.FileTypeID)
            INNER JOIN SubmissionFiles AS SF ON (FM.FileMetaDataID = SF.FileMetaDataID)
            INNER JOIN Submissions AS S ON (SF.SubmissionID = S.SubmissionID)
            INNER JOIN SubmissionStatus AS SS ON (S.SubmissionStatusID = SS.SubmissionStatusID)
            
            WHERE S.SubmissionID = $case_id
            AND SS.SubmissionStatus = 'Published';";
        if ($r_getFiles = mysqli_query($dbc, $q_getFiles)) {
            if (mysqli_num_rows($r_getFiles) < 1) {
                $error = true;
                array_push($errors, "No accessible files were found for this submission.");
            }
            while ($row_getFiles = mysqli_fetch_array($r_getFiles, MYSQLI_ASSOC)) {
                array_push($file_list, $row_getFiles);
            }
            //complete_procedure($dbc);
        }
        else {
            $error = true;
            array_push($errors, "Unable to request files for this submission.");
        }
    }
}

if (!$error) {
    
}

// page display section
$page_title = 'Review Critical Incident';
$_SESSION['is_editor'] = true;
include('./includes/header.php');

if (!$error && count($file_list) > 0) {
    echo "<div class=\"content\">\n";
    echo "<h1>Submission Files</h1>\n";
    foreach ($file_list as $record) {
        create_download_link($record['FileMetaDataID'], $record['FileType'] . ':' . $record['FileName'], $record['FileSize']);
    }
    create_download_link();
    echo "</div>\n";
}

if ($error) {
    
    // print errors
    echo "<div class=\"error\"><h1>Submission Unavailable</h1>\n";
    echo "\t<p class=\"error\">The following issues occurred while requesting submission information:<br />";
    foreach ($errors as $msg) {
        echo " - $msg<br />\n";
    }
    echo "\t</p><p><br /></p>\n</div>\n";
}

include('./includes/footer.php');
?>