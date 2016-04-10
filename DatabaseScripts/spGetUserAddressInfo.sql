USE gr_jci;

DELIMITER $$

/* Gets the address info for an id */
DROP PROCEDURE IF EXISTS `spGetUserAddressInfo`$$
CREATE PROCEDURE `spGetUserAddressInfo`(IN _AddressID int)
DETERMINISTIC
BEGIN
  Select AddressID,
         UserID,
         AddressTypeID,
         AddressLn1,
         AddressLn2,
         City,
         StateID,
         PostCode,
         PrimaryAddress
  From Addresses
  Where AddressID = _AddressID
  Order By CreateDate;
END$$

DELIMITER ;