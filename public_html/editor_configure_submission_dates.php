<!DOCTYPE html>
<html>
<body>
<?php
$page_title = 'Set Submission Dates';

function isdate($indate) {
	if (preg_match('/(0[1-9]|[12][0-9]|3[01])[\/.](0[1-9]|1[012])[\/.](19|20)\d\d/',$indate)) {
		return true;
	} else {
		return false;
	}
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database and conversion page is needed to convert dates.
	require ('../mysqli_connect.php');
	require ('./include_utils/procedures.php');
	require ('./include_utils/date_conversion.php');
	
	$errors = array(); // Initialize an error array.
	
	// Convert all the dates for push to database.
	
	if (!empty ($_POST['pubyear'])) {
		$Year = ($_POST['pubyear']);
	} else {
		$errors[] = 'Publication year must be entered';
	}
	
	if (!empty ($_POST['fsstart'])) {
		if (isdate($_POST['fsstart'])) {
			$AuthorFirstSubmissionStartDate = convert_to($_POST['fsstart']);
		} else {
			$errors[] = 'The first submission start date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First submission start date must be entered';
	}
	
	if (!empty($_POST['fsdue'])) {
		if (isdate($_POST['fsdue'])) {
			$AuthorFirstSubmissionDueDate = convert_to($_POST['fsdue']);
		} else {
			$errors[] = 'The first submission due date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First submission due date must be entered';
	}
	
	if (!empty($_POST['frstart'])) {
		if (isdate($_POST['frstart'])) {
			$FirstReviewStartDate = convert_to($_POST['frstart']);
		} else {
			$errors[] = 'The first review start date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First review start date must be entered';
	}
	
	if (!empty($_POST['frdue'])) {
		if (isdate($_POST['frdue'])) {
			$FirstReviewDueDate = convert_to($_POST['frdue']);
		} else {
			$errors[] = 'The first review due date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First review due date must be entered';
	}
	
	if (!empty($_POST['sstart'])) {
		if (isdate($_POST['sstart'])) {
			$AuthorSecondSubmissionStartDate = convert_to($_POST['sstart']);
		} else {
			$errors[] = 'The second submission start date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'Second submission start date must be entered';
	}
	
	if (!empty($_POST['ssdue'])) {
		if (isdate($_POST['ssdue'])) {
			$AuthorSecondSubmissionDueDate = convert_to($_POST['ssdue']);
		} else {
			$errors[] = 'The second submission due date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Second submission due date must be entered';
	}
	
	if (!empty($_POST['srstart'])) {
		if (isdate($_POST['srstart'])) {
			$SecondReviewStartDate = convert_to($_POST['srstart']);
		} else {
			$errors[] = 'The second review start date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Second review start date must be entered';
	}
	
	if (!empty($_POST['srdue'])) {
		if (isdate($_POST['srdue'])) {
			$SecondReviewDueDate = convert_to($_POST['srdue']);
		} else {
			$errors[] = 'The second review due date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Second review due date must be entered';
	}
	
	if (!empty($_POST['psstart'])) {
		if (isdate($_POST['psstart'])) {
			$AuthorPublicationSubmissionStartDate = convert_to($_POST['psstart']);
		} else {
			$errors[] = 'The publication submission start date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Publication submission start date must be entered';
	}
	
	if (!empty($_POST['psdue'])) {
		if (isdate($_POST['psdue'])) {
			$AuthorPublicationSubmissionDueDate = convert_to($_POST['psdue']);
		} else {
			$errors[] = 'The publication submission due date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Publication submission due date must be entered';
	}
	
	if (!empty($_POST['pdate'])) {
		if (isdate($_POST['pdate'])) {
			$PublicationDate = convert_to($_POST['pdate']);
		} else {
			$errors[] = 'The publication date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Publication date must be entered';
	}
	
	// create query and send the data.
	if (empty($errors)) { // no errors
		$q_dates = "CALL spUpdateArticleDates ('$Year', '$AuthorFirstSubmissionStartDate', '$AuthorFirstSubmissionDueDate', 
		'$FirstReviewStartDate', '$FirstReviewDueDate', '$AuthorSecondSubmissionStartDate', '$AuthorSecondSubmissionDueDate', 
		'$SecondReviewStartDate', '$SecondReviewDueDate', '$AuthorPublicationSubmissionStartDate', '$AuthorPublicationSubmissionDueDate',
		'$PublicationDate')";
		if (mysqli_query ($dbc, $q_dates)){
			echo '<p>You have successfully updated the submission dates.</p><p><br /></p>';
		}else{
			echo '<p>There was an error updating the submission dates. Please try again.</p><br />,/p>';
		}
	} else { // Report the errors.
		echo '<h1 class="swatch alert_text">Error!</h1>
		<p>The following error(s) occurred:<br />';
		foreach ($errors as $msg) { // Print each error.
			echo " - $msg<br />\n";
		}
		echo '</p><p>Please try again.</p><p><br /></p>';
	}	
}
?>

<!-- create the form-->
<h1>Set Important Submission Dates for the Year</h1>
<form action="editor_configure_submission_dates.php" method="post">
	<p>Publication Year:  <input type="number" name="pubyear" min="2015" max="2100" step="1" placeholder="2015"/></p>
	<p>First Submission Start:  <input type="text" name="fsstart" placeholder="mm/dd/yyyy"/> </p>
	<p>First Submission Due:  <input type="text" name="fsdue" placeholder="mm/dd/yyyy"/> </p>
	<p>First Review Start:  <input type="text" name="frstart" placeholder="mm/dd/yyyy"/></p>
	<p>First Review Due:  <input type="text" name="frdue" placeholder="mm/dd/yyyy"/></p>
	<p>Second Submission Starts:  <input type="text" name="sstart" placeholder="mm/dd/yyyy"/></p>
	<p>Second Submission Due:  <input type="text" name="ssdue" placeholder="mm/dd/yyyy"/></p>
	<p>Second Review Starts:  <input type="text" name="srstart" placeholder="mm/dd/yyyy"/></p>
	<p>Second Review Due:  <input type="text" name="srdue" placeholder="mm/dd/yyyy"/></p>
	<p>Publication Submission Start:  <input type="text" name="psstart" placeholder="mm/dd/yyyy"/></p>
	<p>Publication Submission Due:  <input type="text" name="psdue" placeholder="mm/dd/yyyy"/></p>
	<p>Publication Date:  <input type="text" name="pdate" placeholder="mm/dd/yyyy"/></p>
	<p><input type="submit" name="submit" value="Submit Changes" /></p>
</form>
<a href="index.php" class="button">Cancel</a>

</body>
</html>
