<?PHP

/*
Created By Jamal Ahmed
*/
$page_title = 'Manage Announcements' ;

if (session_status() == PHP_SESSION_NONE) {
    // Only start the session if one doesn't exist
    session_start();
}
require('../mysqli_connect.php');
require('./include_utils/procedures.php');
require('./include_utils/files.php'); // for create_download_link
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
$announcement_array = array();
$announcement_message_array = array();

include('./includes/header.php');
include('./includes/subnav.php');
echo "<div class=\"contentwidth row flush\">\r\n";
echo "\t<div class=\"contentwidth row flush col s7\">\r\n";

	if ($is_editor) {
		$q_annoucements = " CALL spGetAllAnnouncementsList ;" ;
		$r_annoucements = mysqli_query ($dbc, $q_annoucements);
		/*
		if ($r_annoucements !== true) {
			echo 'error';
		}
		*/
		while($row_annoucements = mysqli_fetch_array($r_annoucements, MYSQLI_ASSOC)) {
			
			//array_push($announcement_array, $row_annoucements);
			$announcement_ID = $row_annoucements['AnnouncementID'];
			$announcement_title = $row_annoucements['Title'];
			$create_date = $row_annoucements['CreateDate'];
			$expire_date = $row_annoucements['ExpireDate'];
			// Jeff is going to add message to output of stored procedure
			$message = $row_annoucements['Message'];
			 complete_procedure($dbc);
		
		
		// foreach($announcement_array as $annoucement_row1) {
			// $announcement_ID = $annoucement_row1['AnnouncementID'];
		/*
		$q_annoucement_message = " CALL spGetAnnouncement($announcement_ID) ;" ;
		$r_annoucement_message = mysqli_query ($dbc, $q_annoucement_message);
		if ($r_annoucement_message !== true) {
			echo 'error2';
		}
		while($row_annoucements1 = mysqli_fetch_array($r_annoucement_message, MYSQLI_ASSOC)){
			// array_push($announcement_message_array, $row_annoucements);
			$message = $row_annoucements1['Message'];
			*/
		// echo $dbc->error;
		// }
		// complete_procedure($dbc);
		?>
		<table style= "border: 1px solid black"> 
			<tr>
			<th>Title</th>
			<th>Message</th>
			<th>Create Date</th>
			<th>Expire Date Date</th>
			<th>Action</th>
			</tr>
			<?php
		/*
		foreach($announcement_array as $annoucement_row) {
			$announcement_ID = $annoucement_row['AnnouncementID'];
			$announcement_title = $annoucement_row['Title'];
			$create_date = $annoucement_row['CreateDate'];
			$expire_date = $annoucement_row['ExpireDate'];
			
			foreach($announcement_message_array as $message_row){
				$announcement_message = $message_row['Message'];
				
			*/	
				echo "<tr>";
				echo "<td>$announcement_title</td>";
				echo "<td>$message</td>";
				echo "<td>$create_date</td>";
				echo "<td>$expire_date</td>";
				echo "<td><a href=\"remove_announcement.php?id=$announcement_ID\">Remove</a></td>"; 
				// view is not created yet will add when created
				echo "</tr>";
			// }
			// }
		
			 echo '</table>' ;
			 // }
		}
		complete_procedure($dbc);
		// button created by Jon Sankey
		?>
		<br />
		
		<button class="editor buttonform" onclick="location.href='create_announcement.php'">Create Announcement</button>
		<br />
		<?php
		
		
		
		
		
	}
	
	
	
	
	
	
// implemented CSS same as assign editor
echo "\t</div>\r\n";
include('./includes/sidebar.php');
echo "</div>\r\n";
include('./includes/footer.php');

?>