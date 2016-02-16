USE gr_jci;

DELIMITER $$

/* Gets the list of types of addresses */
DROP PROCEDURE IF EXISTS `spGetAddressTypes`$$
CREATE PROCEDURE `spGetAddressTypes`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select AddressTypeID, AddressType
  From AddressTypes
  Order By AddressType;
END$$

DELIMITER ;
