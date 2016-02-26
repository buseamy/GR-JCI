USE gr_jci;

DELIMITER $$

/* Lists the submissions for an editor for a given year */
DROP PROCEDURE IF EXISTS `spEditorViewSubmissions`$$
CREATE PROCEDURE `spEditorViewSubmissions`(IN _Year int)
DETERMINISTIC
BEGIN
  Select s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 GROUP_CONCAT(CONCAT('''',ua.FirstName,' ',ua.LastName,'''')) As 'Authors',
		 GROUP_CONCAT(CONCAT('''',ur.FirstName,' ',ur.LastName,'''')) As 'Reviewers',
		 ss.SubmissionStatus,
		 s.SubmissionDate
  From Submissions s
	Left Join Users eu
	  On eu.UserID = s.EditorUserID
    Inner Join Reviewers r
	  On r.SubmissionID = s.SubmissionID
    Inner Join Users ur
	  On ur.UserID = r.ReviewerUserID
    Inner Join AuthorsSubmission a
	  On a.SubmissionID = s.SubmissionID
	Inner Join Users ua
	  On ua.UserID = a.UserID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
  Where Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DELIMITER ;