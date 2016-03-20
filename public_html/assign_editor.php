<?php // assign_editor created by Jamal Ahmed

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
		
		$q_cases = "CALL spEditorViewSubmissions" . date("Y") ;
		$r_cases = @mysqli_query ($dbc, $q_cases);
		if(mysqli_num_rows)($r_cases > 0) {

		?>
	
	<form action="" method="post">
    <table style="border: 1px solid black">
	<?php
	
		while($row_cases = mysqli_fetch_array($r_cases, mysqli_ASSOC)) 
				// print_r($row_cases);
				// source http://stackoverflow.com/questions/6112875/display-sql-data-in-a-list-with-check-box
				{
                echo '<tr><td>';
                echo '<input type="checkbox" name="selected[]" value="'.$row['SubmissionID'].'"/>'; // replace id with primary key SubmissionID
                echo '</td>';
                foreach ($row_cases as $key => $value)
                    echo '<td>'.htmlspecialchars($value).'</td>';
                echo '</tr>';
            }
		// http://stackoverflow.com/questions/4997252/get-post-from-multiple-checkboxes
		  foreach($_POST['selected'] as $caseID) {
            echo $caseID; //echoes the value set in the HTML form for each checked checkbox.
                         //so, if I were to check 1, 3, and 5 it would echo value 1, value 3, value 5.
                         //in this case, it would echo whatever $row['SubmissionID'] is equivalent to.
    }
			complete_procedure($dbc);
			?>
		</table>
		<?php
		$q_editors = " CALL spGetUsersEditorsList" ;
		$r_editors = @mysqli_query ($dbc, $q_editors);
		while($row_editors = mysqli_fetch_array($r_editors, mysqli_ASSOC))
		{
			echo '<input type="radio" name="editor" value="'.$row['UserID'].'"/>';
			foreach ($row_editors as $key => $value)
                echo '<td>'.htmlspecialchars($value).'</td>';
		}
		$editor_id = $_POST['editor'] ;
		complete_procedure($dbc);
		?>

		<input type="submit"/>
		</form>
		<?php
		
		$q_assign_case = " spUpdateSubmissionAssignEditor('$caseID' ,'$editor_id') " ;
		$r_assign_case = @mysqli_query ($dbc, $q_assign_case);
		while($row_assign_case = mysqli_fetch_array($r_assign_case, mysqli_ASSOC)) {
			echo 'The following cases have been assigned to the chosen editor' ;
			print_r($row_assign_case);
		}
		
		

		}
		else {
		echo 'No cases submitted at this time' ;
		}
		
		
	}
		
}
	
	
	
	
	
	
	
	
	
}

?>