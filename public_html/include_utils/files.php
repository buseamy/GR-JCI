<?php
// these functions can be used to create file download and upload links

// create_download_link - expects integer corresponding to a database file id,
// expects string to display as filename, expects integer bytecount of filesize to display
function create_download_link ($file_id, $filename, $filesize) {
    $bytecount = $filesize;
    $byteunit = 'B';
    if ($filesize > 1073741824) {
        $bytecount = $filesize / 1073741824.0;
        $byteunit = 'GB';
    }
    elseif ($filesize > 1048576) {
        $bytecount = $filesize / 1048576.0;
        $byteunit = 'MB';
    }
    elseif ($filesize > 1024) {
        $bytecount = $filesize / 1024.0;
        $byteunit = 'KB';
    }
    
    echo "<p><a target=\"_blank\" href=\"download.php?fid=$file_id\">$filename</a>";
    if (isset($filesize) && is_numeric($filesize)) {
        echo " ($bytecount $byteunit)";
    }
    echo "</p>\n";
}

function is_mime_valid ($mime) {
    // valid MIMEs are:
    $doc = 'application/msword';
    $docx = 'application/vnd.openxmlformats-officedocument.wordprocessing';
    $pdf = 'application/pdf';
    return ($mime == $doc || $mime == $docx || $mime == $pdf);
}

// create_upload_input - expects string for input-id name,
// expects string for display text, expects string for CSS class
function create_upload_input ($inputname, $filename, $inputrole) {
    echo "\t<p><label for=\"$inputname\">$filename: span class=\"required\">*</span></label>\n";
    echo "\t<input class=\"$inputrole\" type=\"file\" name=\"$inputname\" id=\"$inputname\"></p>\n";
}
?>