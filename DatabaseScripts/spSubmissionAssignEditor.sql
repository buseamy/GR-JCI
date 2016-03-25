USE gr_jci;

DELIMITER $$

/* Connects a SubmissionID with a CategoryID */
DROP PROCEDURE IF EXISTS `spSubmissionAssignEditor`$$
CREATE PROCEDURE `spSubmissionAssignEditor`(IN _SubmissionID int, IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure UserID exists */
	If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
	  Update Submissions
	  Set EditorUserID = _UserID
	  Where SubmissionID = _SubmissionID;
	Else
	  Select 'User doesn't exist' As 'Error';
	End If;
  Else
    Select 'Submission doesn't exist' As 'Error';
  End If;
END$$

DELIMITER ;