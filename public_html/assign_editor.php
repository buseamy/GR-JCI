<?php // assign_editor created by Jamal Ahmed and Mitch Spencer helped review and finish




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
$submission_list = array();
$case_list = array();
$editor_list = array();
$submission_file_list = array();


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
Notes on Arrays
In PHP, there are three kind of arrays:

Numeric array - An array with a numeric index
Associative array - An array where each ID key is associated with a value
Multidimensional array - An array containing one or more arrays
*/                   
// Mitch added CSS
include('./includes/header.php');
include('./includes/subnav.php');
echo "<div class=\"contentwidth row flush\">\r\n";
echo "\t<div class=\"contentwidth row flush col s7\">\r\n";

if (!$error) {
	if ($is_editor) {
		
		/*
		if (empty($_POST['selected'])) {
			$errors[] = 'You forgot to check a critical incident';
		}
		*/
		// Mitch helped with this to ensure both values are entered for stored procedure
		if(isset($_POST['submit']) && !isset($_POST['selected'])) {
			$errors[] = 'Incomplete form.';
		}
		
		if(isset($_POST['submit']) && isset($_POST['selected'])) {
			
			/*
			foreach ($_POST as $field => $value) {   
				echo "<p>$field, $value</p>"; 
			}
			
                $val = $_POST['selected-'.$caseID];
			*/ 
			// Mitch helped me too loop through for every checkbox checked
			foreach($_POST['selected'] as $caseID) {
				if(isset($_POST['selected-'.$caseID])) {
					
				
					
					$editor_id = $_POST['selected-'.$caseID];
				
					
					$q_assign_case = " CALL spSubmissionAssignEditor($caseID ,$editor_id) ;" ;
					$r_assign_case = mysqli_query ($dbc, $q_assign_case);
					
					while($row_assign_case = mysqli_fetch_array($r_assign_case, MYSQLI_ASSOC)) {
						
						
						//echo $r_assign_case->num_rows; For testing
						
						
							$title = $row_assign_case['IncidentTitle'];
							$case_editor_name = $row_assign_case['EditorFullName'];
							echo "The Critical Incident $title has been assigned to the editor $case_editor_name <br>" ;
						
						
					}
					
					
						/*
						error checking
						if ($r_assign_case !== true) {
							$row_err = mysqli_fetch_array($r_assign_case, MYSQLI_ASSOC);
							$ret_err = $row_err['Error'];
							$error = true;
							array_push($errors, "Review could not be committed because: $ret_err.");
							ignore_remaining_output($r_assign_case);
						}
						*/
						
					/*
						while($row_assign_case = mysqli_fetch_array($r_assign_case, MYSQLI_ASSOC)) {
							echo 'The following cases have been assigned to the chosen editor' ;
							print_r($row_assign_case);
						}
						*/
						complete_procedure($dbc);
					}
				}
				
				// echo $dbc->error;
				// complete_procedure($dbc);
				
			}
			
			
            
        }
		// Everything above this is processing the page
		
		// Everything below is preparing to display the form
		
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
		<form action="assign_editor.php" method="post">
		<h3 class = "editor">In Each row check the Critical Incident that you want Assigned to the corresponding Editor in the same Row. </h3>
		<table style="border: 1px solid black">
		<?php
		// Learned how to make tables from CIS 148 HTML & CSS book
		// table creation came from http://stackoverflow.com/questions/6112875/display-sql-data-in-a-list-with-check-box
		// Mitch helped with naming of checkboxes and radio buttons
		foreach($submission_list as $submission_row) {
            $caseID = $submission_row['SubmissionID'] ;
            $case_name = $submission_row['IncidentTitle'] ;
            
            // looked at for assistance http://stackoverflow.com/questions/6112875/display-sql-data-in-a-list-with-check-box
            // http://stackoverflow.com/questions/4997252/get-post-from-multiple-checkboxes
			echo '<tr>';
			echo '<td>';
            echo '<label for = "chk-case-'.$caseID.'">'.$case_name.'</label>';
            echo '<input type="checkbox" id = "chk-case-'.$caseID.'" name="selected[]" value="'.$caseID.'"/>';
            echo '</td>';
            foreach($editor_list as $editor_row) {	
                $editor_name = $editor_row['FullName'] ;
                $editor_ID = $editor_row['UserID'];
                // radio button goes here
                // notes copied from review_submission
                // NOTE - Radio Button inputs are accessible from POST through the NAME of the input
                // NAME also determines the selection grouping, so radio inputs with the same NAME and different ID are mutually-exclusive
                // VALUE is the value retrieved by pulling NAME from POST, e.g. "$_POST['NAME']"
                echo '<td>';
                echo '<label for = "radio-editor-'.$editor_ID.'">'.$editor_name.'</label>';
                echo '<input type="radio" id = "radio-editor-'.$caseID.'-'.$editor_ID.'" name="selected-'.$caseID.'" value="'.$editor_ID.'"/>';
                echo '</td>';
                // echo '<input type="radio" name="editor" value="'.$row_editors['UserID'].'"/>';
                // case name editors file download
            }
            foreach($submission_file_list[$caseID] as $submission_file_row) {
                $filetype = $submission_file_row['FileType'];
                $file_id = $submission_file_row['FileMetaDataID'] ;
                $filename = $submission_file_row['FileName'] ;
                $filesize = $submission_file_row['FileSize'] ;
                echo '<td>';
                create_download_link ($file_id, $filetype . ': ' . $filename, $filesize);
                echo '</td>';
                // download link goes here create_download_link($file_id, $filename, $filesize)
            }
			echo '</tr>';
			// http://stackoverflow.com/questions/21368625/how-do-i-check-if-checkbox-is-checked-in-php
			
			/*
			if((isset($_POST['selected'])) && (!isset($_POST['selected-'.$caseID]))) {
			$errors[] = 'You have selected a case without assigning it an editor';`
			}
			*/
			
		}
		
		?>
		
		</table>
		<input type="submit" name = "submit" value = "submit" class="editor" />
		</form>
		
		<?php
		
		
		
		

		}
	else {
	echo 'No cases submitted at this time' ;
	}
		
		
	}
		

	
	
	
	
// copied from review_submission
// mitch's code
$errorloc = '';
$incomplete = false;
// Handle error messages
if ($error || $incomplete) {
    // print errors
    if ($error) {
        echo "\t\t<p class=\"error\">The following issues occurred while $errorloc:\r\n";
    }

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