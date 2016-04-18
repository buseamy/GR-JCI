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
		$tempdate = trim($_POST['fsstart']);
		if (vardate($tempdate)) {
			$AuthorFirstSubmissionStartDate = convert_to($tempdate);
		} else {
			$errors[] = 'The first submission start date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First submission start date must be entered';
	}
	
	if (!empty($_POST['fsdue'])) {
		$tempdate = trim($_POST['fsdue']);
		if (vardate($tempdate)) {
			$AuthorFirstSubmissionDueDate = convert_to($tempdate);
		} else {
			$errors[] = 'The first submission due date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First submission due date must be entered';
	}
	
	if (!empty($_POST['frstart'])) {
		$tempdate = trim($_POST['frstart']);
		if (vardate($tempdate)) {
			$FirstReviewStartDate = convert_to($tempdate);
		} else {
			$errors[] = 'The first review start date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First review start date must be entered';
	}
	
	if (!empty($_POST['frdue'])) {
		$tempdate = trim($_POST['frdue']);
		if (vardate($tempdate)) {
			$FirstReviewDueDate = convert_to($tempdate);
		} else {
			$errors[] = 'The first review due date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'First review due date must be entered';
	}
	
	if (!empty($_POST['sstart'])) {
		$tempdate = trim($_POST['sstart']);
		if (vardate($tempdate)) {
			$AuthorSecondSubmissionStartDate = convert_to($tempdate);
		} else {
			$errors[] = 'The second submission start date provided was in the wrong format.';
		}
	} else {
		$errors[] = 'Second submission start date must be entered';
	}
	
	if (!empty($_POST['ssdue'])) {
		$tempdate = trim($_POST['ssdue']);
		if (vardate($tempdate)) {
			$AuthorSecondSubmissionDueDate = convert_to($tempdate);
		} else {
			$errors[] = 'The second submission due date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Second submission due date must be entered';
	}
	
	if (!empty($_POST['srstart'])) {
		$tempdate = trim($_POST['srstart']);
		if (vardate($tempdate)) {
			$SecondReviewStartDate = convert_to($tempdate);
		} else {
			$errors[] = 'The second review start date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Second review start date must be entered';
	}
	
	if (!empty($_POST['srdue'])) {
		$tempdate = trim($_POST['srdue']);
		if (vardate($tempdate)) {
			$SecondReviewDueDate = convert_to($tempdate);
		} else {
			$errors[] = 'The second review due date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Second review due date must be entered';
	}
	
	if (!empty($_POST['psstart'])) {
		$tempdate = trim($_POST['psstart']);
		if (vardate($tempdate)) {
			$AuthorPublicationSubmissionStartDate = convert_to($tempdate);
		} else {
			$errors[] = 'The publication submission start date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Publication submission start date must be entered';
	}
	
	if (!empty($_POST['psdue'])) {
		$tempdate = trim($_POST['psdue']);
		if (vardate($tempdate)) {
			$AuthorPublicationSubmissionDueDate = convert_to($tempdate);
		} else {
			$errors[] = 'The publication submission due date provided was in the wrong format.';
		}	
	} else {
		$errors[] = 'Publication submission due date must be entered';
	}
	
	if (!empty($_POST['pdate'])) {
		$tempdate = trim($_POST['pdate']);
		if (vardate($tempdate)) {
			$PublicationDate = convert_to($tempdate);
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
				<div class="box editor_alt">
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
						<br>
						<input type="submit" class="editor" name="submit" value="Submit Changes" />
						<input class="alert" type="button" onclick="location.href='editor_system_settings.php'" value="Cancel" />
						<br>
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

