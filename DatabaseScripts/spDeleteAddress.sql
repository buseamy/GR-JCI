USE gr_jci;

DELIMITER $$

/* Deletes a user's address */
DROP PROCEDURE IF EXISTS `spDeleteAddress`$$
CREATE PROCEDURE `spDeleteAddress`(IN _AddressID int)
DETERMINISTIC
BEGIN
  Delete From Addresses
  Where AddressID = _AddressID;
END$$

DELIMITER ;