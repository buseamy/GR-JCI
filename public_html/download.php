<?php
/*
Purpose: this file is the landing page for all download requests
    permission for the user to download the file must be checked
    and an error displayed for the user if the file will not be sent
*/

// use this to prevent page from displaying if the download is valid
// because flushing the page and resetting the header depends on the browser
$display = true;
// keep this to short-circuit and display on failed download
$error = false;
$errors = array();

// user permission validation goes here, set error to true when failed

//

if (isset($_GET["fid"])) {
    // $dbc defined and initialized
    require('../mysqli_connect.php');
    // functions complete_procedure and ignore_remaining_output defined
    require('./include_utils/procedures.php');
    
    $fid = mysqli_real_escape_string($dbc, $_GET["fid"]);
    if (!isnumeric($fid)) {
        $error = true;
        $errors.push("Invalid input in link: <$fid>");
    }
    
    $q_FileInfo = "CALL GetFileInfo('$fid')";
    if (!$error && !$r_FileInfo = mysqli_query($dbc, $q_FileInfo)) {
        $error = true;
        $errors.push("Unable to get file information.");
    }
    if (!$error && mysqli_num_rows($r_FileInfo) != 1) {
        $error = true;
        $errors.push("Expecting one record, none or multiple found.");
    }
    
    if (!$error)
    {
        $row_FileInfo = mysqli_fetch_array($r_FileInfo, MYSQLI_ASSOC);
        $fileName = $row_FileInfo["FileName"];
        $fileMime = $row_FileInfo["FileMime"];
        $fileSize = $row_FileInfo["FileSize"];
        // end the query and free the connection - expected one line
        ignore_procedure($r_FileInfo);
        complete_procedure($dbc);
        
        // check query before sending header information
        $q_FileSegments = "CALL GetFileSegments('$fid')";
        if (!$r_FileSegments = mysqli_query($dbc, $q_FileSegments)) {
            $error = true;
            $errors.push("Unable to get file content.");
        }
        if (!$error && mysqli_num_rows($r_FileSegments) < 1) {
            $error = truel
            $errors.push("No content found for file.");
        }
        
        if (!$error) {
            // no errors so far - errors now are in the download itself
            $display = false;
            // send the header to the client
            Header("Content-Type: $fileMime", false);
            Header("Content-Length: $fileSize", false);
            Header("Content-Disposition: attachment; filename=$fileName", false);
            
            // send the file content
            while ($row_FileSegments = mysqli_fetch_array($r_FileSegments, MYSQLI_ASSOC)) {
                echo $row_FileSegments["FileContents"];
            }
            complete_procedure($dbc);
        }
    }
}

if ($display || $error) {
    // TODO: display a prettified page for notifying the user of issues
    
    // print errors
    echo '<h1>Download Canceled</h1>
    <p class="error">The following issues prevented download:<br />';
    foreach ($errors as $msg) {
        echo " - $msg<br />\n";
    }
    echo '</p><p>Please try again.</p><p><br /></p>';
}

?>