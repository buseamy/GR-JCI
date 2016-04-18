USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetUserAddressInfo`$$
CREATE PROCEDURE `spGetUserAddressInfo`(IN _AddressID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the address info for an id
   */
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