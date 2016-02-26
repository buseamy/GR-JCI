USE gr_jci;

DELIMITER $$

/* Lists the submissions for an editor for a given year */
DROP PROCEDURE IF EXISTS `spReviewerViewSubmissions`$$
CREATE PROCEDURE `spReviewerViewSubmissions`(IN _UserID int, IN _Year int)
DETERMINISTIC
BEGIN
  Select s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 GROUP_CONCAT(CONCAT('''',u.FirstName,' ',u.LastName,'''')) As 'Authors',
		 ss.SubmissionStatus,
		 s.SubmissionDate
  From Submissions s
    Inner Join Reviewers r
	  On r.SubmissionID = s.SubmissionID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
	Left Join Users eu
	  On eu.UserID = s.EditorUserID
    Inner Join AuthorsSubmission a
	  On a.SubmissionID = s.SubmissionID
	Inner Join Users u
	  On u.UserID = a.UserID
  Where r.ReviewerUserID = _UserID
    And Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DELIMITER ;