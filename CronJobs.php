<?php

/* Created By: Jeff Ballard
 * On: 15-Mar-2016
 * The purpose of this file is allow processing of things at certain intervals throughout the year
 */

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

//Get the due dates for nagging emails
$Dates = mysqli_fetch_array(mysqli_query($dbc, 'Call spGetArticleDates(Null);'), MYSQLI_ASSOC);
complete_procedure($dbc);

//Get the active settings records
$Settings = mysqli_fetch_array(mysqli_query($dbc, 'Call spGetEmailSettingsActive();'), MYSQLI_ASSOC);
complete_procedure($dbc);

//Save the dates
$FirstReviewDueDate = date_create($Dates["FirstReviewDueDate"]);
$AuthorSecondSubmissionDueDate = date_create($Dates["AuthorSecondSubmissionDueDate"]);
$SecondReviewDueDate = date_create($Dates["SecondReviewDueDate"]);
$AuthorPublicationSubmissionDueDate = date_create($Dates["AuthorPublicationSubmissionDueDate"]);

// Get the days settings
$AuthorNagDays = $Settings["AuthorNagEmailDays"];
$ReviewerNagDays = $Settings["ReviewerNagEmailDays"];

$AuthorSubjectTemplate = $Settings["AuthorSubjectTemplate"];
$AuthorBodyTemplate = $Settings["AuthorBodyTemplate"];
$ReviewerSubjectTemplate = $Settings["ReviewerSubjectTemplate"];
$ReviewerBodyTemplate = $Settings["ReviewerBodyTemplate"];

//For date subtraction
$AuthorsDaysConverstion = $AuthorNagDays.' day'.($AuthorNagDays > 1 ? 's' : '');
$ReviewersDaysConverstion = $ReviewerNagDays.' day'.($ReviewerNagDays > 1 ? 's' : '');

//Do the subtractions
$AuthorSecondSubmissionDueDate = date_sub($AuthorSecondSubmissionDueDate, date_interval_create_from_date_string($AuthorsDaysConverstion));
$AuthorPublicationSubmissionDueDate = date_sub($AuthorPublicationSubmissionDueDate, date_interval_create_from_date_string($AuthorsDaysConverstion));

$FirstReviewDueDate = date_sub($FirstReviewDueDate, date_interval_create_from_date_string($ReviewersDaysConverstion));
$SecondReviewDueDate = date_sub($SecondReviewDueDate, date_interval_create_from_date_string($ReviewersDaysConverstion));

//Get current date
$today=date_create(date('Y-m-d'));

//echo 'today = '.$today->format('Y-m-d').'<br />';
//echo 'AuthorSecondSubmissionDueDate = '.$AuthorSecondSubmissionDueDate->format('Y-m-d').'<br />';

//Check dates
if (compareDates($today, $AuthorSecondSubmissionDueDate)) {
    //Get the authors list for nagging emails
    $Authors = mysqli_query($dbc, 'Call spNagAuthorsSubTwoGetList();');
    complete_procedure($dbc);
    
    if (mysqli_num_rows($Authors) > 0) {
        while($row = $Authors->fetch_assoc()) {
            $To = $row["EmailAddress"];
            $Message = str_replace('{0}', $row["FirstName"].' '.$row["LastName"], $AuthorBodyTemplate);

            //Send the email
            sendNagEmail($To, $AuthorSubjectTemplate, $Message);
        }
    }
}
else if (compareDates($today, $AuthorPublicationSubmissionDueDate)) {
    //Get the authors list for nagging emails
    $Authors = mysqli_query($dbc, 'Call spNagAuthorsSubThreeGetList();');
    complete_procedure($dbc);
    
    if (mysqli_num_rows($Authors) > 0) {
        while($row = $Authors->fetch_assoc()) {
            $To = $row["EmailAddress"];
            $Message = str_replace('{0}', $row["FirstName"].' '.$row["LastName"], $AuthorBodyTemplate);

            //Send the email
            sendNagEmail($To, $AuthorSubjectTemplate, $Message);
        }
    }
}
else if (compareDates($today, $FirstReviewDueDate)) {
    //Get the reviewers list for nagging emails
    $Reviewers = mysqli_query($dbc, 'Call spNagReviewersGetList();');
    complete_procedure($dbc);
    
    if (mysqli_num_rows($Reviewers) > 0) {
        while($row = $Reviewers->fetch_assoc()) {
            $To = $row["EmailAddress"];
            $Message = str_replace('{0}', $row["FirstName"].' '.$row["LastName"], $ReviewerBodyTemplate);

            //Send the email
            sendNagEmail($To, $ReviewerSubjectTemplate, $Message);
        }
    }
}
else if (compareDates($today, $SecondReviewDueDate)) {
    //Get the reviewers list for nagging emails
    $Reviewers = mysqli_query($dbc, 'Call spNagReviewersGetList();');
    complete_procedure($dbc);
    
    if (mysqli_num_rows($Reviewers) > 0) {
        while($row = $Reviewers->fetch_assoc()) {
            $To = $row["EmailAddress"];
            $Message = str_replace('{0}', $row["FirstName"].' '.$row["LastName"], $ReviewerBodyTemplate);

            //Send the email
            sendNagEmail($To, $ReviewerSubjectTemplate, $Message);
        }
    }
}

mysqli_close($dbc);

function compareDates($date1, $date2) {
    //date formatting gotten from http://stackoverflow.com/questions/10569053/convert-datetime-to-string-php on 18-Apr-2016
    //echo 'date1: '.$date1->format('Y-m-d').'<br />date2: '.$date2->format('Y-m-d');
    return ($date1->format('Y-m-d') == $date2->format('Y-m-d'));
}
?>