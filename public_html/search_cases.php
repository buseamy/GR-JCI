<?php // search cases.php Written by Jamal Ahmed
	
	if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	require ('../mysqli_connect.php');
	$errors = array(); // Initialize an error array.
	

	// if nothing is entered give an error message
	if ((empty($_POST['case_ID'])) && (empty($_POST['case_title'])) && (empty($_POST['keyword']))
		&& (empty($_POST['author'])) && (empty($_POST['category']))) {
			$errors[] = 'You forgot to enter a search criteria please enter one.';
		}

	
	// if nothing is entered in to the field put in a wildcard operator which allows any value to be selected
	if (empty($_POST['case_ID'])) {
		$case_ID = '%';
	} else {
		$case_ID = mysqli_real_escape_string($dbc, trim($_POST['case_ID']));
	}

	if (empty($_POST['case_title'])) {
		$case_title = '%';
	} else {
		$case_title = mysqli_real_escape_string($dbc, trim($_POST['case_title']));
	}

	if (empty($_POST['keyword'])) {
		$keyword = '%';
	} else {
		$keyword = mysqli_real_escape_string($dbc, trim($_POST['keyword']));
	}
	
	if (empty($_POST['author'])) {
		$author = '%';
	} else {
		$author = mysqli_real_escape_string($dbc, trim($_POST['author']));
	}
	
	if (empty($_POST['category'])) {
		$category = '%';
	} else {
		$category = mysqli_real_escape_string($dbc, trim($_POST['category']));
	}

	// run only if one or more fields has been entered
	if (empty($errors)) {
/*
	// select statement joining user table to submission and category table 
	// using like instead of = because it allows the wildcard to be used
	$q = "select Abstract from Users u INNER JOIN AuthorsSubmission asub ON u.UserID = asub.UserID 
	INNER JOIN Submissions s ON asub.SubmissionID = s.SubmissionID INNER JOIN SubmissionCategories sc ON s.SubmissionID = sc.SubmissionID 
	INNER JOIN Categories c ON sc.CategoryID = c.CategoryID
	where SubmissionID like $case_ID AND CaseTitle like $case_title
	AND Keywords like $keyword AND (select FirstName, LastName from Users) like $author AND Category like $category" ;
*/
	$q_search = "CALL spSearchCases ('$case_ID', '$case_title', '$keyword', '$author', '$category' )" ;
	// http://stackoverflow.com/questions/20300582/display-sql-query-results-in-php source
	$r = @mysqli_query ($dbc, $q_search); // Run the query.
	//  if no results found
	if(mysqli_num_rows($r) < 1) {
		echo 'No results Found' ;
	}
	//dispay results
		while($row = mysqli_fetch_array($r, mysqli_ASSOC)) {
			print_r($row);

		}
	complete_procedure($dbc);
	} else { // Report the errors.
	
		echo '<h1>Error!</h1>
		<p class="error">The following error(s) occurred:<br />';
		foreach ($errors as $msg) { // Print each error.
			echo " - $msg<br />\n";
		}
		echo '</p><p>Please try Searching again.</p>';
		
	}
	
	
}
?>
<h1>Search cases</h1>
<form action="search_cases.php" method="post">
	<p>Case ID: <input type="text" name="case_ID" size="15" maxlength="20" value="<?php if (isset($_POST['case_ID'])) echo $_POST['case_ID']; ?>" /></p>
	<p>Case Title: <input type="text" name="case_title" size="15" maxlength="40" value="<?php if (isset($_POST['case_title'])) echo $_POST['case_title']; ?>" /></p>
	<p>Keywords: <input type="text" name="keyword" size="20" maxlength="60" value="<?php if (isset($_POST['keyword'])) echo $_POST['keyword']; ?>"  /> </p>
	<p>Author: <input type="text" name="author" size="10" maxlength="20" value="<?php if (isset($_POST['author'])) echo $_POST['author']; ?>"  /></p>
	<p>Category: <input type="text" name="category" size="10" maxlength="20" value="<?php if (isset($_POST['category'])) echo $_POST['category']; ?>"  /></p>
	<p><input type="submit" name="submit" value="search" /></p>
</form>


