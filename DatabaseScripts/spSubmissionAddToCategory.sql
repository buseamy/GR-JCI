USE gr_jci;

DELIMITER $$

/* Assigns a UserID to the EditorUserID in the Submissions table */
DROP PROCEDURE IF EXISTS `spSubmissionAddToCategory`$$
CREATE PROCEDURE `spSubmissionAddToCategory`(IN _SubmissionID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure CategoryID exists */
    If(Select Exists(Select 1 From Categories Where CategoryID = _CategoryID)) Then
	  /* Make sure SubmissionID and CategoryID combination doesn't exist */
      If(Select Exists(Select 1 From SubmissionCategories Where SubmissionID = _SubmissionID And CategoryID = _CategoryID)) Then
        Select 'Submission already has that Category' As 'Error';
      Else
	    /* Make the connection */
        Insert Into SubmissionCategories (SubmissionID,CategoryID)
	    Values (_SubmissionID,_CategoryID);
      End If;
	Else
	  Select 'CategoryID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;