USE gr_jci;

DELIMITER $$

/* Updates an existing submission record */
DROP PROCEDURE IF EXISTS `spAuthorUpdateSubmission`$$
CREATE PROCEDURE `spAuthorUpdateSubmission`(IN _SubmissionID int,
                                            IN _IncidentTitle varchar(150),
										    IN _Abstract varchar(5000),
										    IN _KeyWords varchar(5000),
										    IN _SubmissionNumber TINYINT)
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
  
	/* Update the submission record */
	Update Submissions
	Set IncidentTitle = _IncidentTitle,
	    Abstract = _Abstract,
		Keywords = _KeyWords,
		SubmissionNumber = _SubmissionNumber
	Where SubmissionID = _SubmissionID;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;