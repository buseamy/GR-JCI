<?php // search cases.php

	// if nothing is entered in to the field 
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

	// not actual selct statement it will require a join
	$q = select cases from cases where case_ID like $case_ID AND case_title like $case_title AND keyword like $keyword AND author like $author AND category like $category
	// http://stackoverflow.com/questions/20300582/display-sql-query-results-in-php source
	$r = @mysqli_query ($dbc, $q); // Run the query.
	//dispay results
		while($row = mysqli_fetch_array($r, mysqli_ASSOC)) {
			print_r($row);

		}


?>
<h1>Register</h1>
<form action="search cases.php" method="post">
	<p>Case ID: <input type="text" name="case_ID" size="15" maxlength="20" value="<?php if (isset($_POST['case_ID'])) echo $_POST['case_ID']; ?>" /></p>
	<p>Case Title: <input type="text" name="case_title" size="15" maxlength="40" value="<?php if (isset($_POST['case_title'])) echo $_POST['case_title']; ?>" /></p>
	<p>Keywords: <input type="text" name="keyword" size="20" maxlength="60" value="<?php if (isset($_POST['keyword'])) echo $_POST['keyword']; ?>"  /> </p>
	<p>Author: <input type="text" name="author" size="10" maxlength="20" value="<?php if (isset($_POST['author'])) echo $_POST['author']; ?>"  /></p>
	<p>Category: <input type="text" name="category" size="10" maxlength="20" value="<?php if (isset($_POST['category'])) echo $_POST['category']; ?>"  /></p>
	<p><input type="submit" name="submit" value="search" /></p>
</form>


