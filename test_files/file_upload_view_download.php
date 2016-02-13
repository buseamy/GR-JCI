<?php
/*
Purpose: this file is part of a self-contained test for prototyping file upload and download
Requirement: this file requires the "file_upload_view_download.sql" script to have created the database

Core References:
http://dev.mysql.com/doc/refman/5.7/en/blob.html
http://www.dreamwerx.net/site/article01
http://www.media-division.com/the-right-way-to-handle-file-downloads-in-php/
*/

// Set the database access information as constants:
DEFINE ('DB_USER', 'Test_DB_Admin');
DEFINE ('DB_PASSWORD', 'php$qld6!');
DEFINE ('DB_HOST', 'localhost');
DEFINE ('DB_NAME', 'Test_DB');

// Make the connection:
$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

// if no connection could be made, trigger an error:
if(!$dbc) {
	trigger_error ('Could not connect to MySQL: ' .mysqli_connect_error());
} else { // Otherwise, set the encoding:
	mysqli_set_charset($dbc, 'utf8');
}


$STARTFILE = 1;
$ONFILE = "file" . $STARTFILE;
while (isset($_FILES["$ONFILE"]))
{
    $DstFileName = $_FILES["$ONFILE"]["name"];
    $SrcFileType = $_FILES["$ONFILE"]["type"];
    $SrcFilePath = $_FILES["$ONFILE"]["tmp_name"];
    $FileErrorVal = $_FILES["$ONFILE"]["error"];
    $FileSize = $_FILES["$ONFILE"]["size"];
    echo "<p>$ONFILE $DstFileName $SrcFileType $SrcFilePath $FileErrorVal $FileSize</p>";
    /*
    file1, Array
    name, GPL.html
    type, text/html
    tmp_name, C:\xampp\tmp\phpF8B5.tmp
    error, 0
    size, 16153
    */
    
    clearstatcache();
    // http://php.net/manual/en/function.clearstatcache.php
    // clears cache for file_exists()
    
    // File Processing
    if (file_exists($SrcFilePath)) {
        // Insert into the filedata table
        $fp = fopen($SrcFilePath, "rb");
        while (!feof($fp)) {
            // temporarily raise PHP memory limit, due to potentially large filesize
            // ini_set('memory_limit', '2048M');
            
            // one of these should increase the available POST Content-Length
            // unfortunately, this setting can't be changed programmatically like memory_limit can
            // ini_set('post_max_size', '2048M');
            // ini_set('upload_max_filesize', '2048M');
            
            // IMPORTANT: Memory Limits
            // default memory limit of 134217728 bytes (128MB)
            // POST Content-Length memory limit of 8388608 (8MB) bytes
            // reads up to the specified number of bytes - 65535 (65KB) is maximum size for blob
            
            // Make the data mysql insert safe
            $binarydata = addslashes(fread($fp, 65535));
            $SQL = "CALL UploadFile ('$DstFileName', '$SrcFileType', $FileSize, '$binarydata');";
            echo "<p>$DstFileName $SrcFileType $FileSize</p>";
            if (!$result = mysqli_query($dbc, $SQL)) {
                echo '<p>' . $dbc->error . '</p>';
                die("Failure to insert binary inode data row!");
            }
            // clear stored procedure results from the connection
            while (mysqli_more_results($dbc)) {
                mysqli_next_result($dbc);
            }
        }
        fclose($fp);
    }
    
    $STARTFILE ++;
    $ONFILE = "file" . $STARTFILE;
}
clearstatcache();

if (isset($_GET["fn"])) {
    $fileName = mysqli_real_escape_string($dbc, $_GET["fn"]);
    $q_FileData = "CALL GetFile('$fileName')";
    if (!$r_FileData = mysqli_query($dbc, $q_FileData)) {
        echo '<p>' . $dbc->error . '</p>';
        die("Failed to retrieve file $fileName");
    }
    if (mysqli_num_rows($r_FileData) != 1) {
        echo '<p>' . $dbc->error . '</p>';
        die("Invalid file $fileName");
    }
    $row_FileData = mysqli_fetch_array($r_FileData, MYSQLI_ASSOC);
    $recName = $row_FileData["files_name"];
    $recMime = $row_FileData["filetype_name"];
    $recSize = $row_FileData["files_size"];
    $recData = $row_FileData["files_data"];
    
    // Send down the header to the client
    Header("Content-Type: $recMime", false);
    Header("Content-Length: $recSize", false);
    Header("Content-Disposition: attachment; filename=$recName", false);
    echo $recData;
    // clear stored procedure results from the connection
    while ($row_FileData = mysqli_fetch_array($r_FileData, MYSQLI_ASSOC)) {
        // do nothing - placeholder for if DB-design segments the file
    }
    while (mysqli_more_results($dbc)) {
        mysqli_next_result($dbc);
    }
}

$q_FileList = "CALL GetFileList();";
$r_FileList = mysqli_query($dbc, $q_FileList);
while ($row_FileList = mysqli_fetch_array($r_FileList, MYSQLI_ASSOC)) {
    $filename = $row_FileList["files_name"];
    echo '<p><a target="_blank" href="file_upload_view_download.php?fn=' . $filename . '">' . $filename . '</a></p>';
}
// clear stored procedure results from the connection
while (mysqli_more_results($dbc)) {
    mysqli_next_result($dbc);
}


?>
<form method="post" action="file_upload_view_download.php" enctype="multipart/form-data">
<input type="file" name="file1" size="20">
<input type="submit" name="submit" value="submit">
</form>
