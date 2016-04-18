USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetAddressTypes`$$
CREATE PROCEDURE `spGetAddressTypes`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of addresses
   */
  Select AddressTypeID, AddressType
  From AddressTypes
  Order By AddressType;
END$$

DELIMITER ;