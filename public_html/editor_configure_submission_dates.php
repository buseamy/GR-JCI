<!DOCTYPE html>
<html>
<body>
<?php
$page_title = 'Set Submission Dates';

// Written by: Jonathan Sankey on 4/15/2016
// This page allows the editor to set important due dates and store them in the database.
// This page uses preg_match to verify feilds. Documentation can be found at http://php.net/manual/en/function.preg-match.php


require ('./includes/header.php'); // Header
require ('./includes/subnav.php'); // Dashboard navigation

if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}

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
mysqli_close($dbc); // Close the database connection.


//quit the script:
exit();
}
}
?>

<!-- create the form-->
<?php if (isset($_SESSION['isEditor'])) { // Only display if logged in role is editor ?>
	<div class="contentwidth">
		<div class="row flush">
			<div class="col s7">
				<?php
				if (!empty($errors)) { // Report the errors.
					echo '<div>';
					echo '<h1 class="swatch alert_text">Error!</h1>
					<p><br><br>The following error(s) occurred:<br />';
					foreach ($errors as $msg) { // Print each error.
						echo " - $msg<br />\n";
					}
					echo '</p><p>Please try again.</p><p><br /></p>';
					echo '</div>';
				} // End of if (!empty($errors)).
				?>
				<div class="editor roundcorner">
					<h3>Set Important Submission Dates for the Year</h3>
				</div>
				<div>
					<form action="editor_configure_submission_dates.php" method="post">
						<br>
						<label for="pubyear">Publication Year:  <span class="required"></span></label>
						<input type="number" name="pubyear" class="regular" min="2015" max="2100" step="1" placeholder="2015"/>
						<br>
						<label for="fsstart">First Submission Start:  <span class="required"></span></label>
						<input type="text" name="fsstart" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="fsdue">First Submission Due:  <span class="required"></span></label>
						<input type="text" name="fsdue" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="frstart">First Review Start:  <span class="required"></span></label>
						<input type="text" name="frstart" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="frdue">First Review Due:  <span class="required"></span></label>
						<input type="text" name="frdue" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="sstart">Second Submission Starts:  <span class="required"></span></label>
						<input type="text" name="sstart" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="ssdue">Second Submission Due:  <span class="required"></span></input>
						<input type="text" name="ssdue" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="srstart">Second Review Starts:  <span class="required"></span></label>
						<input type="text" name="srstart" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="srdue">Second Review Due:  <span class="required"></span></label>
						<input type="text" name="srdue" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="psstart">Publication Submission Start:  <span class="required"></span></label>
						<input type="text" name="psstart" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="psdue">Publication Submission Due:  <span class="required"></span></label>
						<input type="text" name="psdue" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<label for="pdate">Publication Date:  <span class="required"></span></label>
						<input type="text" name="pdate" class="regular" placeholder="mm/dd/yyyy"/>
						<br>
						<input type="submit" class="editor" name="submit" value="Submit Changes" />
						<input class="alert" type="button" onclick="location.href='editor_system_settings.php'" value="Cancel" />
					</form>
				</div>
			</div>
			<?php require ('./includes/sidebar.php'); // Include the site sidebar
		echo '</div>';
	echo '</div>';
} else { echo '<p class="swatch alert_text">Please login and try again</p>'; }
require ('./includes/footer.php'); ?>

</body>
</html>
