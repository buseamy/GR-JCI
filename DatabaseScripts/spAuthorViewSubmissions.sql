USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spAuthorViewSubmissions`$$
CREATE PROCEDURE `spAuthorViewSubmissions`(IN _UserID int, IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Lists the submissions for an author for a given year
   */
  Select s.SubmissionID,
         s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 ss.SubmissionStatus,
		 s.SubmissionDate
  From Submissions s
    Inner Join AuthorsSubmission a
	  On a.SubmissionID = s.SubmissionID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
	Left Join Users eu
	  On eu.UserID = s.EditorUserID
  Where a.UserID = _UserID
    And Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DELIMITER ;