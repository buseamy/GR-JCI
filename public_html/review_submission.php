<?php
$page_title = 'Review Critical Incident';
// Purpose: allow a reviewer to review a singlular Critical Incident
//      - reviewer can download submission files and upload review files

require('../mysqli_connect.php');
require('./include_utils/procedures.php');
require('./include_utils/files.php'); // download links, upload inputs

$error = false;
$errorloc = '';
$errors = array();

//spGetFileInfo(FileMetaDataID)[FileName, FileMime, FileSize]
//  list files available for download
//spReviewerGetFileList(ReviewerUserID, SubmissionID)[FileMetaDataID, FileName, FileSize, FileType]
//  list files available to reviewer - partially make sure the user is a reviewer

//spGetRoles[RoleID, RoleTitle]
//  make sure the user is a reviewer
//spGetUserRoles(UserID)[RoleTitle]
//  make sure the user is a reviewer

// Make sure the user is a reviewer
if (!isset($_SESSION) || !$_SESSION['is_reviewer']) {
    $errorloc = 'verifying reviewer status';
    
    $error = true;
    array_push($errors, 'Only reviewers may review critical incidents.');
}

// Process reviewer submission
if (!$error && $_SERVER['REQUEST_METHOD'] == 'POST') {
    $errorloc = 'upload processing';
    
    $startfile = 1;
    while (isset($_FILES["$startfile"])) {

    }
}

// Display section
include('./includes/header.php');
include('./includes/subnav.php');
echo "<div class=\"contentwidth row flush\">\r\n";
echo "\t<div class=\"contentwidth row flush col s7\">\r\n";

// Get information on the critical incident and display for download
if (!$error) {
    $errorloc = 'critical incident display';
    
    
}

// Provide form for reviewer to submit review documents
if (!$error) {
    $errorloc = 'file upload form generation';
    
    $q_filetypes = 'CALL spGetFileTypes(2)';
    if ($r_filetypes = mysqli_query($dbc, $q_filetypes)) {
        
        echo "\t\t<form>\r\n";
        while ($row_filetypes = mysqli_fetch_array($r_filetypes, MYSQLI_ASSOC)) {
            $typeId = $row_filetypes['FileTypeID'];
            $typeName = $row_filetypes['FileType'];
            create_upload_input('fileup-' . $typeId, $typeName, 'reviewer');
        }
        echo "\t\t</form>\r\n";
        complete_procedure($dbc);
    }
    else {
        $error = true;
        array_push($errors, 'File types could not be retrieved.');
    }
}

// Handle error messages
if ($error) {
    // print errors
    echo "\t\t<p class=\"error\">The following issues occurred while $errorloc:\r\n";
    foreach ($errors as $msg) {
        echo "\t\t\t<br /> - $msg\r\n";
    }
    echo "\t\t</p>\r\n";
}
echo "\t</div>\r\n";
include('./includes/sidebar.php');
echo "</div>\r\n";
include('./includes/footer.php');

?>