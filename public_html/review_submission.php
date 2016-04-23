<?php
$page_title = 'Review Critical Incident';
if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}
// Purpose: allow a reviewer to review a singlular Critical Incident
//      - reviewer can download submission files and upload review files

require('../mysqli_connect.php');
require('./include_utils/procedures.php');
require('./include_utils/files.php'); // download links, upload inputs, mime-check

$error = false;
$incomplete = false;
$success = false;
$errorloc = '';
$errors = array();
$sub_title = '';

// Make sure the user is a reviewer
if (!isset($_SESSION['is_reviewer']) || !$_SESSION['is_reviewer']) {
    $errorloc = 'verifying reviewer status';
    $error = true;
    array_push($errors, 'Only reviewers may review critical incidents.');
}
// Get UserID
if (isset($_SESSION['UserID'])) {
    $userID = $_SESSION['UserID'];
}
else {
    $error = true;
    array_push($errors, 'You must be logged in to access this page.');
}

// Make sure a submission is selected
if (isset($_GET['sid']) && is_numeric($_GET['sid'])) {
    $subID = mysqli_real_escape_string($dbc, $_GET["sid"]);
}
else {
    $errorloc = 'navigating to this page';
    $error = true;
    array_push($errors, 'A reviewable critical incident was not chosen.');
}

// Process reviewer submission
if (!$error && $_SERVER['REQUEST_METHOD'] == 'POST') {
    $errorloc = 'processing uploads';
    
    // handle files, continue if incomplete
    if (!$error && isset($_FILES)) {
        $q_filetypes = 'CALL spGetFileTypes(2);';
        $filetypes[] = array();
        if ($r_filetypes = mysqli_query($dbc, $q_filetypes)) {
            // defer to array so the connection can be cleared
            while ($row_filetypes = mysqli_fetch_array($r_filetypes, MYSQLI_ASSOC)) {
                array_push($filetypes, $row_filetypes);
            }
            complete_procedure($dbc);
            
            foreach ($filetypes as $filerow) {
                if (sizeof($filerow) > 0) { // an extra object appears to be initialized into the array
                    $typeId = $filerow['FileTypeID'];
                    $typeName = $filerow['FileType'];
                    $inName = 'fileup-' . $typeId;
                    if ($typeName != '' && isset($_FILES["$inName"]) && $_FILES["$inName"] != '' && isset($_FILES["$inName"]["type"]) && $_FILES["$inName"]["type"] != '') {
                        // adapted from prototyped file_upload_view_download
                        $DstFileName = $_FILES["$inName"]["name"];
                        $SrcFileType = $_FILES["$inName"]["type"];
                        $SrcFilePath = $_FILES["$inName"]["tmp_name"];
                        $FileErrorVal = $_FILES["$inName"]["error"];
                        $FileSize = $_FILES["$inName"]["size"];
                        if (is_mime_valid($SrcFileType) && $FileSize < 2097152) {
                            $q_create_rfmd = "CALL spCreateReviewerFileMetaData($subID, $userID, $typeId, '$SrcFileType', '$DstFileName', $FileSize);";
                            if ($r_create_rfmd = mysqli_query($dbc, $q_create_rfmd)) {
                                $row_create_rfmd = mysqli_fetch_array($r_create_rfmd, MYSQLI_ASSOC);
                                $fmdId = $row_create_rfmd['FileMetaDataID'];
                                // TODO: verify this check works as intended
                                if (isset($row_create_rfmd['Error']) || $fmdId == 0) {
                                    $error = true;
                                    $incomplete = true;
                                    $ret_err = $row_create_rfmd['Error'];
                                    array_push($errors, "File for $typeName could not be uploaded because $ret_err.");
                                }
                                ignore_remaining_output($r_create_rfmd);
                                complete_procedure($dbc);
                                
                                // File Processing
                                if (!$error && file_exists($SrcFilePath)) {
                                    $fp = fopen($SrcFilePath, "rb");
                                    $segment = 1;
                                    while (!feof($fp)) {
                                        // Make the data mysql insert safe
                                        $binarydata = addslashes(fread($fp, 65535));
                                        $SQL = "CALL spCreateFileContent ('$fmdId', '$binarydata', $segment);";
                                        if (!$result = mysqli_query($dbc, $SQL)) {
                                            $error = true;
                                            $incomplete = true;
                                            $ret_err = $dbc->error;
                                            array_push($errors, "Segment $segment of file for $typeName could not be uploaded because $ret_err.");
                                        }
                                        complete_procedure($dbc);
                                        $segment ++;
                                    }
                                    fclose($fp);
                                }
                            }
                            else {
                                $incomplete = true;
                                array_push($errors, 'File could not be uploaded for ' . $typeName . '.');
                            }
                        }
                        else {
                            $error = true;
                            $incomplete = true;
                            array_push($errors, 'Uploaded documents must be less than 2MB and in Word-document or PDF format.');
                        }
                    }
                    else {
                        $incomplete = true;
                        array_push($errors, 'Review file was missing for ' . $typeName . '.');
                    }
                } // this condition has no error, it is filtering out the blank entry
            }
        }
        else {
            $error = true;
            array_push($errors, 'File types could not be retrieved.');
        }
    }
    else {
        $error = true;
        array_push($errors, 'No files were submitted with your review');
    }
    
    if (!$error && !$incomplete) {
        if (isset($_POST['status'])) {
            $rev_status = $_POST['status'];
            $q_update_review = "CALL spReviewerUpdateReviewStatus($userID, $subID, $rev_status);";
            if ($r_update_review = mysqli_query($dbc, $q_update_review)) {
                // type-check the boolean, expecting mysqli_result object if errors occurred
                if ($r_update_review !== true) {
                    $row_err = mysqli_fetch_array($r_update_review, MYSQLI_ASSOC);
                    $ret_err = $row_err['Error'];
                    $error = true;
                    array_push($errors, "Review could not be committed because: $ret_err.");
                    ignore_remaining_output($r_update_review);
                }
                complete_procedure($dbc);
            }
            else {
                $error = true;
                array_push($errors, 'Review could not be committed.');
            }
        }
        else {
            $error = true;
            array_push($errors, 'Status was not selected for review.');
        }
    }
    
    // can only be successful if processing happened
    if (!$error && !$incomplete) {
        $success = true;
    }
}

// Display section
include('./includes/header.php');
include('./includes/subnav.php');
echo "<div class=\"contentwidth row flush\">\r\n";
echo "\t<div class=\"contentwidth row flush col s7\">\r\n";

// Get information on the critical incident and display for download
if ($success) {
    // processing happened, display message
    echo "\t\t<h3>Review Successfully Processed.</h3>\r\n";
    echo "\t\t<p><a href=\"reviewer_incident_management.php\">Return to List of Reviewable Critical Incidents</a></p>\r\n";
}
if (!$error) {
    $errorloc = 'displaying information for this critical incident';
    $q_submission = "CALL spSubmissionGetInfo($subID);";
    if ($r_submission = mysqli_query($dbc, $q_submission)) {
        $row_submission = mysqli_fetch_array($r_submission, MYSQLI_ASSOC);
        $sub_title = $row_submission['IncidentTitle'];
        $sub_abstract = $row_submission['Abstract'];
        $sub_keywords = $row_submission['Keywords'];
        $sub_status = $row_submission['SubmissionStatus'];
        // expecting one row
        ignore_remaining_output($r_submission);
        complete_procedure($dbc);
        echo "\t\t<h3 class=\"PLACEHOLDER\">Critical Incident: $sub_title</h3><br />\r\n";
        echo "\t\t<h3 class=\"PLACEHOLDER\">Abstract: </h3><p class=\"PLACEHOLDER\">$sub_abstract</p><br />\r\n";
        $q_subfiles = "CALL spSubmissionGetFilesList($subID);";
        if ($r_subfiles = mysqli_query($dbc, $q_subfiles)) {
            while ($row_subfiles = mysqli_fetch_array($r_subfiles)) {
                $fid = $row_subfiles['FileMetaDataID'];
                $fname = $row_subfiles['FileName'];
                $fsize = $row_subfiles['FileSize'];
                $ftype = $row_subfiles['FileType'];
                create_download_link($fid, $ftype . ': ' . $fname, $fsize);
            }
            complete_procedure($dbc);
        }
        else {
            $error = true;
            array_push($errors, 'Author files were not found for this submission.');
        }
    }
    else {
        $error = true;
        array_push($errors, 'Critical Incident information could not be retrieved.');
    }
    
}

// Provide form for reviewer to submit review documents
if (!$error && !$success) {
    $errorloc = 'building the file upload form';
    
    $status_list = array();
    $q_statuses = 'CALL spGetReviewStatusList();';
    $r_statuses = mysqli_query($dbc, $q_statuses);
    while ($row_statuses = mysqli_fetch_array($r_statuses, MYSQLI_ASSOC)) {
        if ($row_statuses['ReviewStatus'] != 'Reviewing')
        {
            array_push($status_list, $row_statuses);
        }
    }
    complete_procedure($dbc);
    
    $q_filetypes = 'CALL spGetFileTypes(2);';
    if ($r_filetypes = mysqli_query($dbc, $q_filetypes)) {
        
        echo "\t\t<div class=\"reviewer roundcorner\">\r\n";
        echo "\t\t\t<h3 class=\"title\">Review Critical Incident: $sub_title </h3>\r\n";
        echo "\t\t</div>\r\n";
        echo "\t\t<div style=\"padding-left:50px;\" class=\"box_guest reviewer_alt\" id=\"registration-form\">\r\n";
        echo "\t\t\t<form class=\"submitform\" method=\"post\" action=\"review_submission.php?sid=$subID\" enctype=\"multipart/form-data\">\r\n";
        while ($row_filetypes = mysqli_fetch_array($r_filetypes, MYSQLI_ASSOC)) {
            $typeId = $row_filetypes['FileTypeID'];
            $typeName = $row_filetypes['FileType'];
            create_upload_input('fileup-' . $typeId, $typeName, 'reviewer');
        }
        // NOTE - Radio Button inputs are accessible from POST through the NAME of the input
        // NAME also determines the selection grouping, so radio inputs with the same NAME and different ID are mutually-exclusive
        // VALUE is the value retrieved by pulling NAME from POST, e.g. "$_POST['NAME']"
        echo "\t\t\t\t<h3>Review Status:</h3>\r\n";
        foreach ($status_list as $stat_row) {
            $status_id = $stat_row['ReviewStatusID'];
            $status_name = $stat_row['ReviewStatus'];
            $input_id = 'status-' . $status_id;
            echo "\t\t\t\t<label for=\"$input_id\">$status_name</label>\r\n";
            echo "\t\t\t\t<input class=\"\" type=\"radio\" name=\"status\" id=\"$input_id\" value=\"$status_id\" /><br />\r\n";
        }
        echo "\t\t\t\t<br />\r\n\t\t\t\t<input class=\"reviewer\" type=\"submit\" name=\"submit\" value=\"Submit Review\" />\r\n";
        echo "\t\t\t</form>\r\n";
        echo "\t\t</div>\r\n";
        complete_procedure($dbc);
    }
    else {
        $error = true;
        array_push($errors, 'File types could not be retrieved.');
    }
}

// Handle error messages
if ($error || $incomplete) {
    // print errors
    if ($error) {
        echo "\t\t<p class=\"error\">The following issues occurred while $errorloc:\r\n";
    }
    else {
        echo "\t\t<p class=\"incomplete\">Your review was partially processed with the following issues:\r\n";
    }
    foreach ($errors as $msg) {
        echo "\t\t\t<br /> - $msg\r\n";
    }
    echo "\t\t</p>\r\n";
    if (isset($subID)) {
        echo "\t\t<p><a href=\"review_submission.php?sid=$subID\">Retry Review</a></p>";
    }
    else {
        echo "\t\t<p><a href=\"reviewer_incident_management.php\">Return to List of Reviewable Critical Incidents</a></p>";
    }
}
echo "\t</div>\r\n";
include('./includes/sidebar.php');
echo "</div>\r\n";
include('./includes/footer.php');

?>