USE gr_jci;

DELIMITER $$

/* Lists the submissions for an author for a given year */
DROP PROCEDURE IF EXISTS `spAuthorViewSubmissions`$$
CREATE PROCEDURE `spAuthorViewSubmissions`(IN _UserID int, IN _Year int)
DETERMINISTIC
BEGIN
  Select s.CaseTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 s.SubmissionDate
  From Submissions s
    Inner Join AuthorsSubmission a
	  On a.SubmissionID = s.SubmissionID
	Inner Join Users u
	  On u.UserID = a.UserID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
	Right Join Users eu
	  On eu.UserID = s.EditorUserID
  Where u.UserID = _UserID
  Order By s.SubmissionDate,
           s.CaseTitle;
END$$

DELIMITER ;