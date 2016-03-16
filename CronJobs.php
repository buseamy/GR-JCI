<?php 
require('mysqli_connect.php');
require('public_html/include_utils/procedures.php');

//Expire unverified email address changes
mysqli_query($dbc, 'Call spJobUpdateExpireUsersEmailAddressChange()');
complete_procedure($dbc);

//Delete expired announcements
mysqli_query($dbc, 'Call spJobRemoveExpiredAnnouncements()');
complete_procedure($dbc);

if ((date('n') == 1) && date('d') == 1) {
  //Create the new Dates records for current year
  mysqli_query($dbc, 'Call spJobCreateArticleDates()');
  complete_procedure($dbc);
}

if ((date('n') == 12) && date('d') == 31) {
  //Record user's MembershipCode history for current year
  mysqli_query($dbc, 'Call spJobYearlyAddMembershipHistory()');
  complete_procedure($dbc);
}

?>