USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetUserAddressList`$$
CREATE PROCEDURE `spGetUserAddressList`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's address list
   */
  Select a.AddressID,
         t.AddressType,
         a.AddressLn1,
         a.AddressLn2,
         a.City,
         s.Abbr As 'State',
         a.PostCode,
         a.PrimaryAddress
  From Addresses a
    Inner Join AddressTypes t
      On t.AddressTypeID = a.AddressTypeID
    Inner Join States s
      On s.StateID = a.StateID
  Where UserID = _UserID
  Order By a.CreateDate;
END$$

DELIMITER ;