<?php
$page_title = 'Manage Critical Incident Submission Files';
if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}
// Purpose: 
//      - 

require('../mysqli_connect.php');
require('./include_utils/procedures.php');
require('./include_utils/files.php'); // download links, upload inputs, mime-check

$error = false;
$incomplete = false;
$success = false;
$errorloc = '';
$errors = array();
$sub_title = '';
$sub_filelist = array();

$errorloc = 'validating permissions';
if (!isset($_SESSION['is_editor']) && !$_SESSION['is_editor']) {
    $error = true;
    array_push($errors, 'Only an Editor has permissions to access this page.');
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
    array_push($errors, 'A managable submission was not chosen.');
}


// Process editor cleaned files
if (!$error && $_SERVER['REQUEST_METHOD'] == 'POST') {
    $errorloc = 'processing uploads';
    
    // TODO: get spSubmissionGetFilesList to return FileTypeID, workaround part 1
    $q_filetypes = 'CALL spGetFileTypes(1);';
    $filetypes = array();
    if ($r_filetypes = mysqli_query($dbc, $q_filetypes)) {
        // defer to array so the connection can be cleared
        while ($row_filetypes = mysqli_fetch_array($r_filetypes, MYSQLI_ASSOC)) {
            array_push($filetypes, $row_filetypes);
        }
        complete_procedure($dbc);
    }
    else {
        $error = true;
        array_push($errors, 'File types could not be retrieved.');
    }
    
    // handle files, continue if incomplete
    if (!$error && isset($_FILES)) {
        $q_subfiles = "CALL spSubmissionGetFilesList($subID);";
        $subfiles = array();
        if ($r_subfiles = mysqli_query($dbc, $q_subfiles)) {
            while ($row_subfiles = mysqli_fetch_array($r_subfiles)) {
                $fid = $row_subfiles['FileMetaDataID'];
                $fname = $row_subfiles['FileName'];
                $fsize = $row_subfiles['FileSize'];
                $ftype = $row_subfiles['FileType'];
                array_push($subfiles, $row_subfiles);
            }
            complete_procedure($dbc);
            
            foreach ($subfiles as $filerow) {
                if (sizeof($filerow) > 0) { // an extra object appears to be initialized into the array
                    $fileId = $filerow['FileMetaDataID'];
                    $typeName = $filerow['FileType'];
                    $inName = 'fileup-' . $fileId;
                    if ($typeName != '' && isset($_FILES["$inName"]) && $_FILES["$inName"] != '' && isset($_FILES["$inName"]["type"]) && $_FILES["$inName"]["type"] != '') {
                        // adapted from prototyped file_upload_view_download
                        $DstFileName = $_FILES["$inName"]["name"];
                        $SrcFileType = $_FILES["$inName"]["type"];
                        $SrcFilePath = $_FILES["$inName"]["tmp_name"];
                        $FileErrorVal = $_FILES["$inName"]["error"];
                        $FileSize = $_FILES["$inName"]["size"];
                        
                        // TODO: get spSubmissionGetFilesList to return FileTypeID, workaround part 2
                        $typeId = -1;
                        foreach ($filetypes as $type) {
                            if ($type['FileType'] == $typeName) {
                                $typeId = $type['FileTypeID'];
                            }
                        }
                        if ($typeId == -1) {
                            $error = true;
                            $incomplete = true;
                            array_push($errors, 'Could not match uploaded file ' . $DstFileName . ' for type ' . $typeName . '.');
                        }
                        
                        if (is_mime_valid($SrcFileType)) { // && $FileSize < 2097152) { - no limit on Editor uploads
                            $q_update_fmd = "CALL spUpdateFileMetaData($fileId, $typeId, '$SrcFileType', '$DstFileName', $FileSize);";
                            // check typeId BEFORE running the query, workaround part 3
                            if (!$error && $r_update_fmd = mysqli_query($dbc, $q_update_fmd)) {
                                if ($r_update_fmd && $r_update_fmd !== true) {
                                    $row_update_fmd = mysqli_fetch_array($r_update_fmd, MYSQLI_ASSOC);
                                    if (isset($row_update_fmd['Error']) || $fileId == 0) {
                                        $error = true;
                                        $incomplete = true;
                                        $ret_err = $row_update_fmd['Error'];
                                        array_push($errors, "File for $typeName could not be uploaded because $ret_err.");
                                    }
                                    ignore_remaining_output($r_update_fmd);
                                }
                                complete_procedure($dbc);
                                
                                // File Processing
                                if (!$error && file_exists($SrcFilePath)) {
                                    $fp = fopen($SrcFilePath, "rb");
                                    $segment = 1;
                                    while (!feof($fp)) {
                                        // Make the data mysql insert safe
                                        $binarydata = addslashes(fread($fp, 65535));
                                        $SQL = "CALL spCreateFileContent ('$fileId', '$binarydata', $segment);";
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
            array_push($errors, 'Existing files could not be retrieved.');
        }
    }
    else {
        $error = true;
        array_push($errors, 'No files were submitted with your review');
    }
    
    if (!$error && !$incomplete) {
        $q_update = "CALL spUpdateSubmissionStatus($subID, 3);";
        if ($r_update = mysqli_query($dbc, $q_update)) {
            // type-check the boolean, expecting mysqli_result object if errors occurred
            if ($r_update !== true) {
                $row_err = mysqli_fetch_array($r_update, MYSQLI_ASSOC);
                $ret_err = $row_err['Error'];
                $error = true;
                array_push($errors, "Submission could not be updated because: $ret_err.");
                ignore_remaining_output($r_update);
            }
            complete_procedure($dbc);
        }
        else {
            $error = true;
            array_push($errors, 'Submission updates could not be committed.');
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
echo "<script type=\"text/javascript\"> $( \"#editor\" ).addClass( \"active\" ); </script>";
echo "<div class=\"contentwidth row flush\">\r\n";
echo "    <div class=\"contentwidth row flush col s7\">\r\n";


// Get information on the critical incident and display for download
if ($success) {
    // processing happened, display message
    echo "        <h3>Uploads Successfully Processed.</h3>\r\n";
    echo "        <p><a href=\"view_author_submissions.php\">Return to List of Author Submissions</a></p>\r\n";
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
        echo "        <h3 class=\"PLACEHOLDER\">Critical Incident: $sub_title</h3><br />\r\n";
        echo "        <h3 class=\"PLACEHOLDER\">Abstract: </h3><p class=\"PLACEHOLDER\">$sub_abstract</p><br />\r\n";
        $q_subfiles = "CALL spSubmissionGetFilesList($subID);";
        if ($r_subfiles = mysqli_query($dbc, $q_subfiles)) {
            while ($row_subfiles = mysqli_fetch_array($r_subfiles)) {
                $fid = $row_subfiles['FileMetaDataID'];
                $fname = $row_subfiles['FileName'];
                $fsize = $row_subfiles['FileSize'];
                $ftype = $row_subfiles['FileType'];
                create_download_link($fid, $ftype . ': ' . $fname, $fsize);
                array_push($sub_filelist, $row_subfiles);
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


// Provide form for editor to submit file updates
if (!$error && !$success) {
    $errorloc = 'building the file upload form';
    
    if (count($sub_filelist) > 0) {
        echo "        <div class=\"editor roundcorner\">\r\n";
        echo "            <h3 class=\"title\">Manage Critical Incident Submission Files: $sub_title </h3>\r\n";
        echo "        </div>\r\n";
        echo "        <div style=\"padding-left:50px;\" class=\"box_guest editor_alt\" id=\"registration-form\">\r\n";
        echo "            <form class=\"submitform\" method=\"post\" action=\"manage_author_submission.php?sid=$subID\" enctype=\"multipart/form-data\">\r\n";
        foreach ($sub_filelist as $filetype) {
            $fid = $filetype['FileMetaDataID'];
            $ftype = $filetype['FileType'];
            create_download_link($fid, $ftype . ': ' . $fname, $fsize);
            create_upload_input('fileup-' . $fid, $ftype, 'editor');
        }
        echo "                <br />\r\n";
        echo "                <input class=\"editor\" type=\"submit\" name=\"submit\" value=\"Submit Cleaned Files\" />\r\n";
        echo "            </form>\r\n";
        echo "        </div>\r\n";
        complete_procedure($dbc);
    }
    else {
        $error = true;
        array_push($errors, 'No files were found for this submission.');
    }
}


// Handle error messages
if ($error || $incomplete) {
    // print errors
    if ($error) {
        echo "        <p class=\"error\">The following issues occurred while $errorloc:\r\n";
    }
    else {
        echo "        <p class=\"incomplete\">Your cleaning was partially processed with the following issues:\r\n";
    }
    foreach ($errors as $msg) {
        echo "            <br /> - $msg\r\n";
    }
    echo "        </p>\r\n";
    if (isset($subID)) {
        echo "        <p><a href=\"manage_author_submission.php?sid=$subID\">Retry Submission Cleaning</a></p>";
    }
    else {
        echo "        <p><a href=\"view_author_submissions.php\">Return to List of Author Submissions</a></p>";
    }
}
echo "    </div>\r\n";
include('./includes/sidebar.php');
echo "</div>\r\n";
include('./includes/footer.php');

?>