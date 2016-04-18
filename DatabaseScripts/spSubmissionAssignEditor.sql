USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSubmissionAssignEditor`$$
CREATE PROCEDURE `spSubmissionAssignEditor`(IN _SubmissionID int, IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Assigns an editor UserID to a Submission
   */
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure UserID exists */
	If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
	  Update Submissions
	  Set EditorUserID = _UserID
	  Where SubmissionID = _SubmissionID;
      
      Select s.IncidentTitle,
             Concat(u.LastName, ', ', u.FirstName) As 'EditorFullName'
      From Submissions s
        Inner Join Users u
          On u.UserID = s.EditorUserID
      Where s.SubmissionID = _SubmissionID;
	Else
	  Select 'User doesn''t exist' As 'Error';
	End If;
  Else
    Select 'Submission doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;