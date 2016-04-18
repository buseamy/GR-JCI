USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spDeleteAddress`$$
CREATE PROCEDURE `spDeleteAddress`(IN _AddressID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes a user's address
   */
  Delete From Addresses
  Where AddressID = _AddressID;
END$$

DELIMITER ;