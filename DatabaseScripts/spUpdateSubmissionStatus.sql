USE gr_jci;

DELIMITER $$

/* Updates an existing Submissions' status */
DROP PROCEDURE IF EXISTS `spUpdateSubmissionStatus`$$
CREATE PROCEDURE `spUpdateSubmissionStatus`(IN _SubmissionID int,
                                            IN _SubmissionStatusID int
) DETERMINISTIC
BEGIN
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the SubmissionStatusID exists */
    If(Select Exists(Select 1 From SubmissionStatus Where SubmissionStatusID = _SubmissionStatusID)) Then
      /* Update the Submission record */
	  Update Submissions
	  Set SubmissionStatusID = _SubmissionStatusID
	  Where SubmissionID = _SubmissionID;
    Else
      Select 'SubmissionStatusID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;