USE gr_jci;

DELIMITER $$

/* Expire user's EmailAddress change attempts */
DROP PROCEDURE IF EXISTS `spJobUpdateExpireUsersEmailAddressChange`$$
CREATE PROCEDURE `spJobUpdateExpireUsersEmailAddressChange`()
DETERMINISTIC
BEGIN
  Update Users
  Set EmailStatusID = 2
  Where EmailStatusID = 1
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 3 DAY;
END$$

DELIMITER ;