USE gr_jci;

DELIMITER $$

/* Marks a user's email address as invalid */
DROP PROCEDURE IF EXISTS `spUpdateRejectEmailAddress`$$
CREATE PROCEDURE `spUpdateRejectEmailAddress`(IN _UserID int)
DETERMINISTIC
BEGIN
  Update Users
  Set EmailStatusID = 2
  Where UserID = _UserID;
END$$

DELIMITER ;