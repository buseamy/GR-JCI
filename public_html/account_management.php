<?php 

$page_title = 'View the Current Users';
include ('includes/header.php');
echo '<h1>Account Management</h1>';

require ('../mysqli_connect.php');

// Number of records to show per page:
$display = 10;

// Determine how many pages there are.
if (isset($_GET['p']) && is_numeric($_GET['p'])) {
	$pages = $_GET['p'];
} else { // Need to determine.
 	// Count the number of records:
	$query = "SELECT COUNT(UserID) FROM users"; //Replace with stored procedure
	$result = @mysqli_query ($dbc, $query) OR die(mysqli_error($dbc));
	
	$row = @mysqli_fetch_array ($result, MYSQLI_NUM);
	$records = $row[0];
	// Calculate the number of pages.
	if ($records > $display) { // More than 1 page.
		$pages = ceil ($records/$display);
	} else {
		$pages = 1;
	}
} // End of p IF.

// Determine where in the database to start returning results.
if (isset($_GET['s']) && is_numeric($_GET['s'])) {
	$start = $_GET['s'];
} else {
	$start = 0;
}

// Determine the sort.
// Default is by registration date.
$sort = (isset($_GET['sort'])) ? $_GET['sort'] : 'cd';

// Determine the sorting order:
switch ($sort) {
	case 'ln':
		$order_by = 'FirstName ASC';
		break;
	case 'fn':
		$order_by = 'LastName ASC';
		break;
	case 'ea':
		$order_by = 'EmailAddress ASC';
		break;
	default:
		$order_by = 'CreateDate ASC';
		$sort = 'cd';
		break;
}
	
// Define the query:
$query= "SELECT UserID, LastName, FirstName, EmailAddress, CreateDate FROM users ORDER BY $order_by LIMIT $start, $display";		
$result = @mysqli_query ($dbc, $query); // Run the query.

// Table header:
echo '<table align="center" cellspacing="0" cellpadding="5" width="75%">
<tr>
	<td align="left"><b></b></td>
	<td align="left"><b></b></td>
	<td align="left"><b><a href="account_management.php?sort=ln">Last Name</a></b></td>
	<td align="left"><b><a href="account_management.php?sort=fn">First Name</a></b></td>
	<td align="left"><b><a href="account_management.php?sort=ea">Email Address</a></b></td>
	<td align="left"><b><a href="account_management.php?sort=cd">Date Created</a></b></td>
</tr>
';

// Fetch and print all the records
$bg = '#eeeeee'; 
while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
	$bg = ($bg=='#eeeeee' ? '#ffffff' : '#eeeeee');
		echo '<tr bgcolor="' . $bg . '">
		<td align="left"><a href="#' . $row['UserID'] . '">Edit</a></td>
		<td align="left"><a href="#' . $row['UserID'] . '">Delete</a></td>
		<td align="left">' . $row['FirstName'] . '</td>
		<td align="left">' . $row['LastName'] . '</td>
		<td align="left">' . $row['EmailAddress'] . '</td>
		<td align="left">' . $row['CreateDate'] . '</td>
	</tr>
	';
} 
echo '</table>';
//mysqli_free_result ($result);
mysqli_close($dbc);

// Make the links to other pages, if necessary.
if ($pages > 1) {
	
	echo '<br /><p>';
	$current_page = ($start/$display) + 1;
	
	// If it's not the first page, make a Previous button:
	if ($current_page != 1) {
		echo '<a href="view_users.php?s=' . ($start - $display) . '&p=' . $pages . '&sort=' . $sort . '">Previous</a> ';
	}
	
	// Make all the numbered pages:
	for ($i = 1; $i <= $pages; $i++) {
		if ($i != $current_page) {
			echo '<a href="view_users.php?s=' . (($display * ($i - 1))) . '&p=' . $pages . '&sort=' . $sort . '">' . $i . '</a> ';
		} else {
			echo $i . ' ';
		}
	} 
	
	if ($current_page != $pages) {
		echo '<a href="view_users.php?s=' . ($start + $display) . '&p=' . $pages . '&sort=' . $sort . '">Next</a>';
	}
	
	echo '</p>'; 
	
} 
	
?>