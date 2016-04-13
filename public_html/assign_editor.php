<?php // assign_editor created by Jamal Ahmed




$page_title = 'assign_editor' ;

if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}
require('../mysqli_connect.php');
require('./include_utils/procedures.php');
require('./include_utils/files.php'); // for create_download_link
$error = false;
$errors = array();

// this code was taken from Mitch
$is_editor = false;

if (isset($_SESSION['is_editor'])) {
	$is_editor = $_SESSION['is_editor'];
}
else {
    $error = true;
    array_push($errors, "This page can only be accessed by the Editor.");
}              

/*
used to check what sessions are active
foreach ($_SESSION as $key => $value) 
{    
echo "<p>Key-$key, Val-$value</p>";
}
In PHP, there are three kind of arrays:

Numeric array - An array with a numeric index
Associative array - An array where each ID key is associated with a value
Multidimensional array - An array containing one or more arrays
*/                   

if (!$error) {
	if ($is_editor) {
		if(isset($_POST['submit'])) {
			/*
			foreach ($_POST as $field => $value) {   
				// echo "<p>$field, $value</p>";   
			if ($field != 'submit' && $value != 'Record Results' && $value != 'empty') 
				{    $source = substr($field, 8);    $item = $value;        $q_r = "CALL AddRecord('$item', '$source', '$time');";    $r_r = mysqli_query($dbc, $q_r);   
			if ($r_r) 
			{     echo "<p>Source: $source and Item: $item successfully recorded.</p>";   
			}   	
			else {     echo '<p class="error">';   
			echo "Could not process Source $source: and Item: $item.</p>";    }  
			while (mysqli_more_results($dbc)) {     mysqli_next_result($dbc);    }
			
			}  
			}
			*/
            $q_assign_case = " CALL spUpdateSubmissionAssignEditor('$caseID' ,'$editor_id') ;" ;
            $r_assign_case = @mysqli_query ($dbc, $q_assign_case);
            while($row_assign_case = mysqli_fetch_array($r_assign_case, MYSQLI_ASSOC)) {
                echo 'The following cases have been assigned to the chosen editor' ;
                print_r($row_assign_case);
            }
            complete_procedure($dbc);
        }
		// Everything above this is processing the page
		
		// Everything below is preparing to display the form
		$submission_list = array();
		$case_list = array();
		$editor_list = array();
		
		$q_cases = "CALL spEditorViewSubmissions('" . date("Y") ."');" ;
		$r_cases = @mysqli_query ($dbc, $q_cases);
		if(mysqli_num_rows($r_cases) > 0) {

		while($row_cases = mysqli_fetch_array($r_cases, MYSQLI_ASSOC)) {
            // Mitch helped me learn how to use array_push
            //array_push(first parameter is the array, second parameter is the value of what is being put in the first parameter)
            array_push($case_list, $row_cases);
        }
        complete_procedure($dbc);
        
        foreach($case_list as $case_row) {
            $caseID = $case_row['SubmissionID'] ;
            
			$q_submission = "CALL spSubmissionGetInfo ($caseID);";
			$r_submission = @mysqli_query ($dbc, $q_submission);
			
			while($row_submission = mysqli_fetch_array($r_submission, MYSQLI_ASSOC)) {
				// echo '< name="case" value="'.$row_submission['IncidentTitle'].'"/>';
				
				$row_submission['SubmissionID'] = $caseID ; // check to see if this works
				// array_push($row_submission, $caseID);
				array_push($submission_list, $row_submission);
				foreach($submission_list as $submission_row) {
                    $case_title = $submission_row['IncidentTitle'] ;
				}
			}
            complete_procedure($dbc);
            
			$submission_fileIDs = array();
			$q_submission_file = "CALL spSubmissionGetFilesList ($caseID);";
			$r_submission_file = @mysqli_query ($dbc, $q_submission_file);
			while($row_submission_file = mysqli_fetch_array($r_submission_file, MYSQLI_ASSOC)) {
				// download link taken from author_view_critical incident page
				// echo '< name="ID" value="'.$row_submission_file['FileMetaDataID'].'"/>';
                // echo "<td><a href='download.php?fid=$file_ID'>Download</a></td>";
                //echo '</tr>';
				 
                array_push($submission_fileIDs, $row_submission_file);
				
                foreach($submission_file_list as $submission_file_row) {
                    $file_id = $submission_file_row['FileMetaDataID'] ;
                }
			}
            complete_procedure($dbc);
			$submission_file_list[$caseID] = $submission_fileIDs;
			// array_push($submission_file_list, $submission_fileIDs);
        }
		  
		  
		$q_editors = " CALL spGetUsersEditorsList ;" ;
		$r_editors = @mysqli_query ($dbc, $q_editors);
		while($row_editors = mysqli_fetch_array($r_editors, MYSQLI_ASSOC))
		{
			array_push($editor_list, $row_editors); 
			foreach($editor_list as $editor_row) {
				$editor_name = $editor_row['FullName'] ;// These values not used
				$editor_ID = $editor_row['UserID'];
			}
			
		}
		complete_procedure($dbc);
        
		?>
		<form action="assign_editor2.php" method="post">
		<table style="border: 1px solid black">
		<?php
		echo '<tr><td>';
		foreach($submission_list as $submission_row) {
            $caseID = $submission_row['SubmissionID'] ;
            $case_name = $submission_row['IncidentTitle'] ;
            
            // looked at for assistance http://stackoverflow.com/questions/6112875/display-sql-data-in-a-list-with-check-box
            // http://stackoverflow.com/questions/4997252/get-post-from-multiple-checkboxes
            echo '<label for = "chk-case-'.$caseID.'">'.$case_name.'</label>';
            echo '<input type="checkbox" id = "chk-case-'.$caseID.'" name="selected[]" value="'.$caseID.'"/>';
            echo '</td>';
            foreach($editor_list as $editor_row) {	
                $editor_name = $editor_row['FullName'] ;
                $editor_ID = $editor_row['UserID'];
                // radio button goes here
                echo '<td>';
                echo '<label for = "radio-editor-'.$editor_ID.'">'.$editor_name.'</label>';
                echo '<input type="radio" id = "radio-editor-'.$editor_ID.'" name="selected1" value="'.$editor_ID.'"/>';
                echo '</td>';
                // echo '<input type="radio" name="editor" value="'.$row_editors['UserID'].'"/>';
                // case name editors file download
            }
            foreach($submission_file_list[$caseID] as $submission_file_row) {
                $file_id = $submission_file_row['FileMetaDataID'] ;
                $filename = $submission_file_row['FileName'] ;
                $filesize = $submission_file_row['FileSize'] ;
                echo '<td>';
                create_download_link ($file_id, $filename, $filesize);
                echo '</td>';
                // download link goes here create_download_link($file_id, $filename, $filesize)
            }
		}
		echo '</tr>';
		?>
		
		</table>
		<input type="submit"/>
		</form>
		
		<?php
		
		
		
		

		}
	else {
	echo 'No cases submitted at this time' ;
	}
		
		
	}
		
}
	
	
	
	


?>