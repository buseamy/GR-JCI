<?php
// This script was barrowed from ISYS 288 and adapted by Jonathan Sankey.
// This script retrieves all the authors critical icidents and allows them to view the reviewer feedback.
// This also allows the critical isidents to be sorted in different ways.

$page_title = 'View Critical Incidents';
include ('includes/header.html');
require('./include_utils/procedures.php');
echo '<h1>Critical Incidents</h1>';

require ('../mysqli_connect.php');

// Number of records to show per page:
$display = 10;

// Determine how many pages there are...
if (isset($_GET['p']) && is_numeric($_GET['p'])) { // Already been determined.
	$pages = $_GET['p'];
} else { // Need to determine.
 	// Count the number of submissions:
	$q = "SELECT COUNT(SubmissionID) FROM Submissions s
	JOIN AuthorsSubmission a ON s.SubmissionID = a.SubmissionID
	JOIN Users u ON a.UserID = u.UserID
	WHERE UserID = {$_SESSION['id']}";
	$r = @mysqli_query ($dbc, $q);
	$row = @mysqli_fetch_array ($r, MYSQLI_NUM);
	$records = $row[0];
	// Calculate the number of pages...
	if ($records > $display) { // More than 1 page.
		$pages = ceil ($records/$display);
	} else {
		$pages = 1;
	}
} // End of p IF.

// Determine where in the database to start returning results...
if (isset($_GET['s']) && is_numeric($_GET['s'])) {
	$start = $_GET['s'];
} else {
	$start = 0;
}

// Determine the sort...
// Default is by registration date.
$sort = (isset($_GET['sort'])) ? $_GET['sort'] : 'rd';

// Determine the sorting order:
switch ($sort) {
	case 'fn':
		$order_by = 'CaseTitle ASC';
		break;
	case 'rd':
		$order_by = 'SubmissionDate ASC';
		break;
	default:
		$order_by = 'SubmissionDate ASC';
		$sort = 'rd';
		break;
}
	
// Define the query:
$q = "SELECT CaseTitle, SubmissionDate FROM Submissions s
	JOIN AuthorsSubmission a ON s.SubmissionID = a.SubmissionID
	JOIN Users u ON a.UserID = u.UserID
	WHERE UserID = {$_SESSION['id']}
	ORDER BY $order_by LIMIT $start, $display";		
$r = @mysqli_query ($dbc, $q); // Run the query.

// Table header:
echo '<table align="center" cellspacing="0" cellpadding="5" width="75%">
<tr>
	<td align="left"><b>View Feedback</b></td>
	<td align="left"><b><a href="view_users.php?sort=fn">First Name</a></b></td>
	<td align="left"><b><a href="view_users.php?sort=rd">Date Registered</a></b></td>
</tr>
';

// Fetch and print all the records....
$bg = '#eeeeee'; 
while ($row = mysqli_fetch_array($r, MYSQLI_ASSOC)) {
	$bg = ($bg=='#eeeeee' ? '#ffffff' : '#eeeeee');
		echo '<tr bgcolor="' . $bg . '">
		<td align="left"><a href="download_feedback.php?id=' . $row['SubmissionID'] . '">View Feedback</a></td>
		<td align="left">' . $row['CaseTitle'] . '</td>
		<td align="left">' . $row['SubmissionDate'] . '</td>
	</tr>
	';
} // End of WHILE loop.

echo '</table>';
mysqli_free_result ($r);
mysqli_close($dbc);

// Make the links to other pages, if necessary.
if ($pages > 1) {
	
	echo '<br /><p>';
	$current_page = ($start/$display) + 1;
	
	// If it's not the first page, make a Previous button:
	if ($current_page != 1) {
		echo '<a href="author_view_cases.php?s=' . ($start - $display) . '&p=' . $pages . '&sort=' . $sort . '">Previous</a> ';
	}
	
	// Make all the numbered pages:
	for ($i = 1; $i <= $pages; $i++) {
		if ($i != $current_page) {
			echo '<a href="author_view_cases.php?s=' . (($display * ($i - 1))) . '&p=' . $pages . '&sort=' . $sort . '">' . $i . '</a> ';
		} else {
			echo $i . ' ';
		}
	} // End of FOR loop.
	
	// If it's not the last page, make a Next button:
	if ($current_page != $pages) {
		echo '<a href="author_view_cases.php?s=' . ($start + $display) . '&p=' . $pages . '&sort=' . $sort . '">Next</a>';
	}
	
	echo '</p>'; // Close the paragraph.
	
} // End of links section.
	
include ('includes/footer.html');
?>