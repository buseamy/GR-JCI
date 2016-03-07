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

	/*
	    <form action="" method="post">
    <table style="border: 1px solid black"> create table 
	*/
		while($row_cases = mysqli_fetch_array($r_cases, mysqli_ASSOC)) {
				// print_r($row_cases);
				// source http://stackoverflow.com/questions/6112875/display-sql-data-in-a-list-with-check-box
				{
                echo '<tr><td>';
                echo '<input type="checkbox" name="selected[]" value="'.$row['id'].'"/>'; // replace id with primary key SubmissionID
                echo '</td>';
                foreach ($row_cases as $key => $value)
                    echo '<td>'.htmlspecialchars($value).'</td>';
                echo '</tr>';
            }
			//</table>
		
		//<input type="submit"/>
		//</form>
		// SELECT * FROM table WHERE id = '.$_POST['selected'][i] where i is iterating through every element of array
		
		}
		print_r($_POST);
		$_POST['selected']
		}
		else {
		echo 'No cases submitted at this time' ;
		}
		complete_procedure($dbc);
		
	}
		
}
	
	
	
	
	
	
	
	
	
}

?>