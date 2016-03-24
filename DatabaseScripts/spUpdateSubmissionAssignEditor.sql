USE gr_jci;

DELIMITER $$

/* Assigns an editor UserID to a Submission */
DROP PROCEDURE IF EXISTS `spUpdateSubmissionAssignEditor`$$
CREATE PROCEDURE `spUpdateSubmissionAssignEditor`(IN _SubmissionID int, IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the UserID exists */
	If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
	  Update Submissions
	  Set EditorUserID = _UserID,
	      SubmissionStatusID = 2
	  Where SubmissionID = _SubmissionID;
	Else
	  Select 'User doesn''t exist' As 'Error';
	End If;
  Else
    Select 'Submission doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;