<?php
$page_title = 'Review Critical Incident';
// Purpose: allow a reviewer to review a singlular Critical Incident
//      - reviewer can download submission files and upload review files

require('../mysqli_connect.php');
require('./include_utils/procedures.php');
require('./include_utils/files.php'); // download links

//spGetFileTypes(RoleID)[FileTypeID,FileType]
//  populate a list of form file inputs

//spGetFileInfo(FileMetaDataID)[FileName, FileMime, FileSize]
//  list files available for download
//spReviewerGetFileList(ReviewerUserID, SubmissionID)[FileMetaDataID, FileName, FileSize, FileType]
//  list files available to reviewer - partially make sure the user is a reviewer

//spGetRoles[RoleID, RoleTitle]
//  make sure the user is a reviewer
//spGetUserRoles(UserID)[RoleTitle]
//  make sure the user is a reviewer

?>