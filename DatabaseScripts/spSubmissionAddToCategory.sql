USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSubmissionAddToCategory`$$
CREATE PROCEDURE `spSubmissionAddToCategory`(IN _SubmissionID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Connects a Submission to a Category
   */
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