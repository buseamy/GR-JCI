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
        $segment = 1;
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
            $SQL = "CALL UploadFileSegment ('$DstFileName', '$SrcFileType', $FileSize, $segment, '$binarydata');";
            echo "<p>$DstFileName $SrcFileType $FileSize $segment</p>";
            if (!$result = mysqli_query($dbc, $SQL)) {
                echo '<p>' . $dbc->error . '</p>';
                die("Failure to insert binary inode data row!");
            }
            // clear stored procedure results from the connection
            while (mysqli_more_results($dbc)) {
                mysqli_next_result($dbc);
            }
            $segment ++;
        }
        fclose($fp);
    }
    
    $STARTFILE ++;
    $ONFILE = "file" . $STARTFILE;
}
clearstatcache();

if (isset($_GET["fn"])) {
    $fileName = mysqli_real_escape_string($dbc, $_GET["fn"]);
    $q_FileInfo = "CALL GetFileInfo('$fileName')";
    if (!$r_FileInfo = mysqli_query($dbc, $q_FileInfo)) {
        echo '<p>' . $dbc->error . '</p>';
        die("Failed to retrieve file $fileName");
    }
    if (mysqli_num_rows($r_FileInfo) != 1) {
        echo '<p>' . $dbc->error . '</p>';
        die("Invalid file $fileName");
    }
    $row_FileInfo = mysqli_fetch_array($r_FileInfo, MYSQLI_ASSOC);
    $fileID = $row_FileInfo["files_id"];
    $recName = $row_FileInfo["files_name"];
    $recMime = $row_FileInfo["filetype_name"];
    $recSize = $row_FileInfo["files_size"];
    // clear stored procedure results from the connection
    while ($row_FileInfo = mysqli_fetch_array($r_FileInfo, MYSQLI_ASSOC)) {
        // do nothing - placeholder for if DB-design segments the file
    }
    while (mysqli_more_results($dbc)) {
        mysqli_next_result($dbc);
    }
    
    // check query before sending header information
    $q_FileSegments = "CALL GetFileSegments('$fileID')";
    $r_FileSegments = mysqli_query($dbc, $q_FileSegments);
    if (mysqli_num_rows($r_FileSegments) < 1) {
        echo '<p>' . $dbc->error . '</p>';
        die("Failed to retrieve file segments for file $fileName");
    }
    
    // Send down the header to the client
    Header("Content-Type: $recMime", false);
    Header("Content-Length: $recSize", false);
    Header("Content-Disposition: attachment; filename=$recName", false);
    
    // echo each segment in order (ordered by ORDER BY)
    while ($row_FileSegments = mysqli_fetch_array($r_FileSegments, MYSQLI_ASSOC)) {
        $recData = $row_FileSegments["filedata"];
        echo $recData;
    }
    while (mysqli_more_results($dbc)) {
        mysqli_next_result($dbc);
    }
    // send the page data to the client, depends on browser
    // may be best to have download functionality at the end of scripts
    // where there is no page content remaining
    // also, the page will be automatically closing anyways
    ob_flush();
    flush();
    
    //http://php.net/manual/en/function.header-remove.php
    //header_remove(string) removes specified header
    //header_remove() removes all PHP-set headers
    //header(string:val) must be used if PHP version is before 5.3
    header_remove("Content-Type");
    header_remove("Content-Length");
    header_remove("Content-Disposition");
}

$q_FileList = "CALL GetFileList();";
$r_FileList = mysqli_query($dbc, $q_FileList);
while ($row_FileList = mysqli_fetch_array($r_FileList, MYSQLI_ASSOC)) {
    $filename = $row_FileList["files_name"];
    $filemime = $row_FileList["filetype_name"];
    $filesize = $row_FileList["files_size"];
    echo '<p><a target="_blank" href="file_upload_view_download.php?fn=' . $filename . '">' . $filename . '</a> MIME:' . $filemime . ' Size:' . $filesize . 'B</p>';
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
