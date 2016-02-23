USE gr_jci;

DELIMITER $$

/* Expire user's EmailAddress change attempts */
DROP PROCEDURE IF EXISTS `spUpdateExpireUsersEmailAddressChange`$$
CREATE PROCEDURE `spUpdateExpireUsersEmailAddressChange`()
DETERMINISTIC
BEGIN
  Update Users
  Set EmailStatusID = 2
  Where EmailStatusID = 1
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 3 DAY;
END$$

DELIMITER ;