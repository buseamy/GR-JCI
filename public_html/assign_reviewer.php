<?php // assign reviewer page created by Jamal Ahmed

$page_title = 'assign_editor' ;
require('../mysqli_connect.php');
require('./include_utils/procedures.php');
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

if (!$error) {
	
	if ($is_editor) {
		
		
		if(isset($_POST['submit'])) {
		// if isset post method file upload/download prototype
		// spSubmissionGetInfo, spSubmissionGetFilesList
		
		$q_assign_reviewer = " spReviewerAddToSubmission('$caseID' ,'$reviewer_ID') " ;
		$r_assign_reviewer = @mysqli_query ($dbc, $q_assign_reviewer);
		while($row_assign_reviewer = mysqli_fetch_array($r_assign_reviewer, mysqli_ASSOC)) {
			echo 'The following cases have been assigned to the chosen reviewers' ;
			print_r($row_assign_reviewer);
			
		}
		}
		// Everything above this is processing the page
		
		// Everything below is preparing to display the form
		$submission_list = array();
		$case_list = array();
		$reviewer_list = array();
		
		$q_cases = "CALL spEditorViewSubmissions" . date("Y") ;
		$r_cases = @mysqli_query ($dbc, $q_cases);
		if(mysqli_num_rows($r_cases) > 0) {
			
	
		while($row_cases = mysqli_fetch_array($r_cases, MYSQLI_ASSOC)) 
				
				
				{
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
				
				complete_procedure($dbc);
			}
			 $submission_fileIDs = array();
			$q_submission_file = "CALL spSubmissionGetFilesList ($caseID);";
			$r_submission_file = @mysqli_query ($dbc, $q_submission_file);
			while($row_submission_file = mysqli_fetch_array($r_submission_file, MYSQLI_ASSOC)) {
				 
				 array_push($submission_fileIDs, $row_submission_file);
				
				 foreach($submission_file_list as $submission_file_row) {
					 $file_id = $submission_file_row['FileMetaDataID'] ;
				 }
				 complete_procedure($dbc);
			}
			$submission_file_list[$caseID] = $submission_fileIDs;
			}
		  
				
		$q_reviewers = " CALL spGetUsersReviewersList" ;
		$r_reviewers = @mysqli_query ($dbc, $q_reviewers);		

	
		while($row_reviewers = mysqli_fetch_array($r_reviewers , mysqli_ASSOC)) 
				// source http://stackoverflow.com/questions/6112875/display-sql-data-in-a-list-with-check-box
				{
			array_push($reviewer_list, $row_reviewers); 
			foreach($reviewer_list as $reviewer_row) {
				$reviewer_name = $reviewer_row['FullName'] ;
				$reviewer_ID = $reviewer_row['UserID'];
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
		foreach($reviewer_list as $reviewer_row) {
				$reviewer_name = $reviewer_row['FullName'] ;
				$reviewer_ID = $reviewer_row['UserID'];
		echo '<td>';
		echo '<label for = "chk-reviewer-'.$reviewer_ID.'">'.$reviewer_name.'</label>';
		echo '<input type="checkbox" id = "chk-case-'.$reviewer_ID.'" name="selected1[]" value="'.$reviewer_ID.'"/>';
		echo '</td>';
			}
		foreach($submission_file_list[$caseID] as $submission_file_row) {
			$file_id = $submission_file_row['FileMetaDataID'] ;
			$filename = $submission_file_row['FileName'] ;
			$filesize = $submission_file_row['FileSize'] ;
			echo '<td>';
			create_download_link ($file_id, $filename, $filesize);
			echo '</td>';
			
		}
		}
			?>
		</tr>
		</table>

		<input type="submit"/>
		</form>
		
		<?php
		// spReviewerAddToSubmission
		
		
		
			
			
			
		}
		
		else {
		echo 'No cases submitted at this time' ;
		}
		
		
		
	}
	
	
	
	
	
}

?>
