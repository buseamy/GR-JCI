<?php $page_title = 'JCI Website - Process Submission';

/*
 * The purpose of this file is to process
 * the submited case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./include_utils/procedures.php'); // complete_procedure()
 require('./include_utils/files.php'); // download links, upload inputs, mime-check

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['submit'])) {
    $Error = false;
    $PreviousSubmissionID = "NULL";
    $SubmissionNumber = 1;
    $UserID = $_SESSION['UserID'];
    $Errors = array();

    //Collect and validate data from submission
    if(!isset($_POST['title']) || strlen(trim($_POST['title'])) == 0){
        echo '<p>No title provided</p><br/>';
        $Error = true;
    } else {
        $IncidentTitle = $_POST['title'];
    }
    $MemberCode = $_POST['memberCode'];
    $counter = $_POST['counter'];

    if ($counter > 1) {
        $count = $counter;
        while ($count > 1) {
            if (!isset($_POST['email'.$count])|| strlen(trim($_POST['email'.$count])) == 0){
                $Error = true;
                echo "<p>Please provide all author email addresses</p><br>";
            } else {
                ${'Email' . $count} =$_POST['email'.$count];
            }
            $count--;
        }
    }
    if (!isset($_FILES["coverPage"]) || !isset($_FILES["coverPage"]["type"])) {
        echo '<p>No Cover Page provided</p><br/>';
        $Error = true;
    }
    if (!isset($_FILES["criticalIncident"]) || !isset($_FILES["criticalIncident"]["type"])) {
        echo '<p>No Critical Incident provided</p><br/>';
        $Error = true;
    }
    if (!isset($_FILES["teachingNotes"]) || !isset($_FILES["teachingNotes"]["type"])) {
        echo '<p>No Teaching Notes provided</p><br/>';
        $Error = true;
    }
    if (!isset($_FILES["memo"]) || !isset($_FILES["memo"]["type"])) {
        echo '<p>No Memo provided</p><br/>';
        $Error = true;
    }
    $KeyWords = $_POST['keywords'];
    $Abstract = $_POST['abstract'];

    // Check if authors are registered users
    if($Error == false) {
        $count = $counter;
        while ($count > 1 && $Error == false) {

            //Check if users exist
            $results = $dbc->query("Call spSearchGetUsersEmail('${'Email' . $count}');"); // Run procedure
            complete_procedure($dbc);

            if ($results->num_rows > 0) {
                // output data of each row
                while($row = $results->fetch_assoc()) {
                    ${'AdditionalAuthorUserID' . $count} = $row["UserID"];
                }
            } else {
                echo "<p>Author " . $count . " not found</p><br>";
                $Error = true;
            }
            $count--;
        }
    }

    if (isset($_POST['submit']) && $Error == false) {
        // create the initial submission
        $q_AuthorCreateSubmission = "Call spAuthorCreateSubmission($UserID, '$IncidentTitle', '$Abstract', '$KeyWords', $PreviousSubmissionID, $SubmissionNumber);"; // Call to stored procedure
        $results = $dbc->query($q_AuthorCreateSubmission); // Run procedure

        //if nothing is returned
        if (!$results){
            $Error = true;
        } else { //if something is returned
            // output data of each row
            while($row = $results->fetch_assoc()) {
                $SubmissionID = $row["SubmissionID"];
            }
        }
        complete_procedure($dbc); // Complete SP Create submission
        // If submission creation was successful
        if (!$SubmissionID) {
            $Error = true;
        } elseif($Error == false) {
            $count = $counter;
            while ($count > 1 && $Error == false) {
                $PrimaryContact = 0;
                $AdditionalAuthorUserID = ${'AdditionalAuthorUserID' . $count};
                $checkAuthor = $dbc->query("Call spAuthorAddToSubmission('$AdditionalAuthorUserID', '$SubmissionID', '$PrimaryContact');"); // Run procedure
                complete_procedure($dbc);
                if ($checkAuthor == false) {
                    echo "<p>problem with spAuthorAddToSubmission</p><br>";
                    $Error = true;
                }elseif (is_bool($checkAuthor) === false){
                    while($checkAuthorRow = $checkAuthor->fetch_assoc()) {
                        if ($checkAuthorRow["Error"] == true){
                            echo "<p>The following errors occured with spAuthorAddToSubmission: </p><br>";
                            echo $checkAuthorRow["Error"];
                            $Error = true;
                        }
    		        }
                }
                $count--;
            }
        }
        if ($Error == false ) {
            // run Submission Update if there are no errors
            $checkSubmission = $dbc->query("Call spAuthorUpdateSubmission('$SubmissionID', '$IncidentTitle', '$Abstract', '$KeyWords', '$SubmissionNumber');");
            complete_procedure($dbc);

            if ($checkSubmission == false) {
                echo "<p>Error adding aditional authors</p><br>";
                $Error = true;
            }elseif (is_bool($checkSubmission) === false){
                while($checkSubmissionRow = $checkSubmission->fetch_assoc()) {
                    if ($checkSubmissionRow["Error"] == true){
                        echo "<p>The following errors occured while adding additional authors: </p><br>";
                        echo $checkSubmissionRow["Error"];
                        $Error = true;
                    }
                }
            }
        }
        $files = array('coverPage', 'criticalIncident', 'teachingNotes', 'memo', 'summary');
        if (isset($SubmissionID) && $Error == false) {
            foreach ($files as $inName) {
                if ($inName === 'coverPage') {
                    $FileTypeID = 1;
                }elseif ($inName === 'CriticalIncident') {
                    $FileTypeID = 2;
                }elseif ($inName === 'Summary') {
                    $FileTypeID = 3;
                }elseif ($inName === 'TeachingNotes') {
                    $FileTypeID = 4;
                }elseif ($inName === 'Memo') {
                    $FileTypeID = 5;
                }
                //$inName = 'fileup-' . $typeId;
                if (isset($_FILES["$inName"]) && isset($_FILES["$inName"]["type"])) {
                    // adapted from prototyped file_upload_view_download
                    $DstFileName = $_FILES["$inName"]["name"];
                    $SrcFileType = $_FILES["$inName"]["type"];
                    $SrcFilePath = $_FILES["$inName"]["tmp_name"];
                    $FileErrorVal = $_FILES["$inName"]["error"];
                    $FileSize = $_FILES["$inName"]["size"];
                    if (is_mime_valid($SrcFileType) && $FileSize < 2097152) {
                        $q_create_rfmd = "CALL spCreateSubmissionFileMetaData('$SubmissionID', '$FileTypeID', '$SrcFileType', '$DstFileName', '$FileSize');";
                        if ($r_create_rfmd = mysqli_query($dbc, $q_create_rfmd)) {
                            $row_create_rfmd = mysqli_fetch_array($r_create_rfmd, MYSQLI_ASSOC);
                            $fmdId = $row_create_rfmd['FileMetaDataID'];
                            // TODO: verify this check works as intended
                            if (isset($row_create_rfmd['Error']) || $fmdId == 0) {
                                $Error = true;
                                $ret_err = $row_create_rfmd['Error'];
                                array_push($Errors, "File for $typeName could not be uploaded because $ret_err.");
                                echo "<p>File for $typeName could not be uploaded because $ret_err.</p><br>";
                            }
                            ignore_remaining_output($r_create_rfmd);
                            complete_procedure($dbc);

                            // File Processing
                            if (!$Error && file_exists($SrcFilePath)) {
                                $fp = fopen($SrcFilePath, "rb");
                                $segment = 1;
                                while (!feof($fp)) {
                                    // Make the data mysql insert safe
                                    $binarydata = addslashes(fread($fp, 65535));
                                    $SQL = "CALL spCreateFileContent ('$fmdId', '$binarydata', $segment);";
                                    if (!$result = mysqli_query($dbc, $SQL)) {
                                        $Error = true;
                                        $ret_err = $dbc->error;
                                        array_push($Errors, "Segment $segment of file for $typeName could not be uploaded because $ret_err.");
                                        echo "<p>Segment $segment of file for $typeName could not be uploaded because $ret_err.</p><br>";
                                    }
                                    complete_procedure($dbc);
                                    $segment ++;
                                }
                                fclose($fp);
                            }
                        }
                        else {
                            array_push($Errors, 'File could not be uploaded for ' . $typeName . '.');
                            echo '<p>File could not be uploaded for ' . $typeName . '.</p><br>';
                        }
                    }
                    else {
                        $Error = true;
                        array_push($Errors, 'Uploaded documents must be less than 2MB and in Word-document or PDF format.');
                        echo '<p>Uploaded documents must be less than 2MB and in Word-document or PDF format.</p><br>';
                    }
                }

                //$CreateSubmissionFileMetaData = $dbc->query("Call spCreateSubmissionFileMetaData('$SubmissionID', '$FileTypeID', '$FileMime', '$sFileName', '$sFileSize');");
            }
        }
        if ($Error == false) {
            echo "<h1>Submission successfull</h1>";
            echo "<h2>Details:</h2>";
            echo "Title: $IncidentTitle";
            echo "<p>Submitting Author: $firstname $lastname </p>";
        }
    }elseif ($error == true) { echo "There were error(s) with submission.";}
}
    require "./includes/footer.php";
 ?>
