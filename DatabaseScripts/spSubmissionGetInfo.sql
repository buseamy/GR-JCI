USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSubmissionGetInfo`$$
CREATE PROCEDURE `spSubmissionGetInfo`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the info for a SubmissionID
   */
  Select s.IncidentTitle,
         s.Abstract,
		 s.Keywords,
		 s.SubmissionDate,
		 s.SubmissionNumber,
		 ss.SubmissionStatus
  From Submissions s
    Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
  Where s.SubmissionID = _SubmissionID;
END$$

DELIMITER ;