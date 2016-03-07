USE gr_jci;

DELIMITER $$

/* Removes a SubmissionID from a CategoryID */
DROP PROCEDURE IF EXISTS `spSubmissionRemoveCategory`$$
CREATE PROCEDURE `spSubmissionRemoveCategory`(IN _SubmissionID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
  Delete From SubmissionCategories
  Where SubmissionID = _SubmissionID
    And CategoryID = _CategoryID;
END$$

DELIMITER ;