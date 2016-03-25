<?php 
require('mysqli_connect.php');
require('public_html/include_utils/procedures.php');

//Expire unverified email address changes
mysqli_query($dbc, 'Call spJobUpdateExpireUsersEmailAddressChange()');
complete_procedure($dbc);

//Delete expired announcements
mysqli_query($dbc, 'Call spJobRemoveExpiredAnnouncements()');
complete_procedure($dbc);

//Find out if end of publish things need to happen yet
$r = mysqli_fetch_array(mysqli_query($dbc, 'Call spJobPublishEndRollOver();'), MYSQLI_ASSOC);
complete_procedure($dbc);

if ($r["RollOver"] == 1) {
  //Record user's MembershipCode history for current year
  mysqli_query($dbc, 'Call spJobYearlyAddMembershipHistory()');
  complete_procedure($dbc);
  
  //Create the new Dates records for current year
  mysqli_query($dbc, 'Call spJobCreateArticleDates()');
  complete_procedure($dbc);
}

?>