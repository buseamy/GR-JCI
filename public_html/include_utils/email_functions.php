<?php
/*
  Author:      Jeff Ballard
  Created:     25-Mar-2016
  Description: Functions for sending various emails
*/

require('../mysqli_connect.php');
require('procedures.php');

function sendVerificationEmail($dbc, $UID, $MessageType) {
    $r = mysqli_fetch_array(mysqli_query($dbc, "Call spGetVerificationUserInfo($UID);"), MYSQLI_ASSOC);
    complete_procedure($dbc);
    
    switch ($MessageType) {
      case 1:
        $Subject = 'Welcome to SCR - Journal of Critical Incidents';
        $Message = $r["FirstName"].' '.$r["LastName"].',<br />&nbsp;&nbsp;Thank you for registering with Society for Case Research - Journal of Critical Incidents.<br /><br />&nbsp;&nbsp;In order to complete the registration process please click on the link below to confirm your recieving of this email.<br />&nbsp;&nbsp;<a href="http://www.sfcrjci.org/verify_emailaddress.php?e='.$r["EmailVerificationGUID"].'">Verify Email</a></html>';
        break;
      case 2:
        $Subject = 'Mesage from SCR - Journal of Critial Incidents';
        $Message = $r["FirstName"].' '.$r["LastName"].',<br />&nbsp;&nbsp;It looks like you\'re wanting to change your email address for the Society for Case Research - Journal of Critical Incidents website, to complete the change process please click the link below:<br />&nbsp;&nbsp;<a href="http://www.sfcrjci.org/verify_emailaddress.php?e='.$r["EmailVerificationGUID"].'">Verify Email</a><br /><br />&nbsp;&nbsp;If you didn\'t request a change of email address please disregard this email.';
        break;
    }
    
    $Message = '<html><body>'.$Message.'</body></html>';
    $To = $r["NewEmailAddress"];
    $Header = "From: NoReply@sfcrjci.org\r\nContent-Type: text/html;charset=iso-8859-1\r\nMIME-Version: 1.0\r\n";

    mail($To,$Subject,$Message,$Header);
}

?>