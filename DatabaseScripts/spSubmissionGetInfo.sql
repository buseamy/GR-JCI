USE gr_jci;

DELIMITER $$

/* Gets the info for a SubmissionID  */
DROP PROCEDURE IF EXISTS `spSubmissionGetInfo`$$
CREATE PROCEDURE `spSubmissionGetInfo`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
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