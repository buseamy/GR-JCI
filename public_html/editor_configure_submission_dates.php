<!DOCTYPE html>
<html>
<body>
<?php
$page_title = 'Set Submission Dates';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	// database connection is required for queries to be inserted in database and conversion page is needed to convert dates.
	require ('../mysqli_connect.php');
	require ('./include_utils/procedures.php');
	require ('./include_utils/date_conversion.php');
	
	// Convert all the dates for push to database.
	$Year = ($_POST['pubyear']);
    $AuthorFirstSubmissionStartDate = convert_to($_POST['fsstart']);
	$AuthorFirstSubmissionDueDate = convert_to($_POST['fsdue']);
	$FirstReviewStartDate = convert_to($_POST['frstart']);
	$FirstReviewDueDate = convert_to($_POST['frdue']);
	$AuthorSecondSubmissionStartDate = convert_to($_POST['sstart']);
	$AuthorSecondSubmissionDueDate = convert_to($_POST['ssdue']);
	$SecondReviewStartDate = convert_to($_POST['srstart']);
	$SecondReviewDueDate = convert_to($_POST['srdue']);
	$AuthorPublicationSubmissionStartDate = convert_to($_POST['psstart']);
	$AuthorPublicationSubmissionDueDate = convert_to($_POST['psdue']);
	$PublicationDate = convert_to($_POST['pdate']);
	
	// create query and send the data.
	$q_dates = "CALL spUpdateArticleDates ('$Year', '$AuthorFirstSubmissionStartDate', '$AuthorFirstSubmissionDueDate', 
	'$FirstReviewStartDate', '$FirstReviewDueDate', '$AuthorSecondSubmissionStartDate', '$AuthorSecondSubmissionDueDate', 
	'$SecondReviewStartDate', '$SecondReviewDueDate', '$AuthorPublicationSubmissionStartDate', '$AuthorPublicationSubmissionDueDate',
	'$PublicationDate')";
	if (mysqli_query ($dbc, $q_dates)){
		echo '<p>You have successfully updated the submission dates.</p><p><br /></p>';
	}else{
		echo '<p>There was an error updating the submission dates. Please try again.</p><br />,/p>';
	}
}
?>

<!-- create the form-->
<h1>Set Important Submission Dates for the Year</h1>
<form action="editor_configure_submission_dates.php" method="post">
	<p>Publication Year:  <input type="number" name="pubyear" min="2015" max="2100" step="1" value="2015"/></p>
	<p>First Submission Start:  <input type="text" name="fsstart" value="mm/dd/yyyy"/> </p>
	<p>First Submission Due:  <input type="text" name="fsdue" value="mm/dd/yyyy"/> </p>
	<p>First Review Start:  <input type="text" name="frstart" value="mm/dd/yyyy"/></p>
	<p>First Review Due:  <input type="text" name="frdue" value="mm/dd/yyyy"/></p>
	<p>Second Submission Starts:  <input type="text" name="sstart" value="mm/dd/yyyy"/></p>
	<p>Second Submission Due:  <input type="text" name="ssdue" value="mm/dd/yyyy"/></p>
	<p>Second Review Starts:  <input type="text" name="srstart" value="mm/dd/yyyy"/></p>
	<p>Second Review Due:  <input type="text" name="srdue" value="mm/dd/yyyy"/></p>
	<p>Publication Submission Start:  <input type="text" name="psstart" value="mm/dd/yyyy"/></p>
	<p>Publication Submission Due:  <input type="text" name="psdue" value="mm/dd/yyyy"/></p>
	<p>Publication Date:  <input type="text" name="pdate" value="mm/dd/yyyy"/></p>
	<p><input type="submit" name="submit" value="Submit Changes" /></p>
</form>
<a href="index.php" class="button">Cancel</a>

</body>
</html>
