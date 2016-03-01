USE gr_jci;

DELIMITER $$

/* Lists the submissions for a reviewer for a given year */
DROP PROCEDURE IF EXISTS `spReviewerViewSubmissions`$$
CREATE PROCEDURE `spReviewerViewSubmissions`(IN _UserID int, IN _Year int)
DETERMINISTIC
BEGIN
  Select s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 ss.SubmissionStatus,
		 s.SubmissionDate
  From Submissions s
    Inner Join Reviewers r
	  On r.SubmissionID = s.SubmissionID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
	Left Join Users eu
	  On eu.UserID = s.EditorUserID
  Where r.ReviewerUserID = _UserID
    And Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DELIMITER ;