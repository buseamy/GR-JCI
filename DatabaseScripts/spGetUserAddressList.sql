USE gr_jci;

DELIMITER $$

/* Gets the user's address list */
DROP PROCEDURE IF EXISTS `spGetUserAddressList`$$
CREATE PROCEDURE `spGetUserAddressList`(IN _UserID int)
DETERMINISTIC
BEGIN
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