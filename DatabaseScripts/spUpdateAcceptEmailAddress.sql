USE gr_jci;

DELIMITER $$

/* Marks a user's email address as valid */
DROP PROCEDURE IF EXISTS `spUpdateAcceptEmailAddress`$$
CREATE PROCEDURE `spUpdateAcceptEmailAddress`(IN _UserID int)
DETERMINISTIC
BEGIN
  Update Users
  Set EmailStatusID = 3
  Where UserID = _UserID;
END$$

DELIMITER ;