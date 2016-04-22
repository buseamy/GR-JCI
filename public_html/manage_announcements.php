<?PHP

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
echo "\t<div class=\"contentwidth row flush col s8\">\r\n";

	if ($is_editor) {
		
		$q_annoucements = " CALL spGetAllAnnouncementsList ;" ;
		$r_annoucements = mysqli_query ($dbc, $q_annoucements);
		while($row_annoucements = mysqli_fetch_array($r_annoucements, MYSQLI_ASSOC)) {
			array_push($announcement_array, $row_annoucements);
			
			complete_procedure($dbc);
			 
		}
		foreach($announcement_array as $annoucement_row1) {
			$announcement_ID = $annoucement_row1['AnnouncementID'];
		$q_annoucement_message = " CALL spGetAnnouncement($announcement_ID) ;" ;
		$r_annoucement_message = mysqli_query ($dbc, $q_annoucement_message);
		while($row_annoucements = mysqli_fetch_array($r_annoucement_message, MYSQLI_ASSOC)){
			array_push($announcement_message_array, $row_annoucements);
		}
		}
		complete_procedure($dbc);
		echo '<table>' ; 
			echo '<tr>';
			echo '<th>Title</th>';
			echo '<th>Message</th>';
			echo '<th>Create Date</th>';
			echo '<th>Expire Date Date</th>';
			echo '<th>Action</th>';
			echo '</tr>';
			// echo '</table>' ;
		
		foreach($announcement_array as $annoucement_row) {
			$announcement_ID = $annoucement_row['AnnouncementID'];
			$announcement_title = $annoucement_row['Title'];
			$create_date = $annoucement_row['CreateDate'];
			$expire_date = $annoucement_row['ExpireDate'];
			
			foreach($announcement_message_array as $message_row){
				$announcement_message = $message_row['Message'];
				
				
				echo "<tr>";
				echo "<td>$announcement_title</td>";
				echo "<td>$announcement_message</td>";
				echo "<td>$create_date</td>";
				echo "<td>$expire_date</td>";
				echo "<td><a target=\"_blank\" href=\"remove_announcement.php?id=$announcement_ID\">Action</a></td>"; 
				echo "</tr>";
			}
			}
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
echo "\t</div>\r\n";
include('./includes/sidebar.php');
echo "</div>\r\n";
include('./includes/footer.php');

?>