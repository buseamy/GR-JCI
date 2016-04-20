USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSubmissionAssignEditor`$$
CREATE PROCEDURE `spSubmissionAssignEditor`(IN _SubmissionID int,
                                            IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Assigns an editor UserID to a Submission
   */
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure UserID exists and is an editor */
	If(Select Exists(Select 1 From Users u Inner Join UserRoles ur On ur.UserID = u.UserID Where u.UserID = _UserID And ur.RoleID = 3)) Then
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
	  Select Concat('UserID ', _UserID, ' doesn''t exist or isn''t an editor') As 'Error';
	End If;
  Else
    Select Concat('SubmissionID ', _SubmissionID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;