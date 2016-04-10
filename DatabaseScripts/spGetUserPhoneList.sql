USE gr_jci;

DELIMITER $$

/* Gets the user's phone list */
DROP PROCEDURE IF EXISTS `spGetUserPhoneList`$$
CREATE PROCEDURE `spGetUserPhoneList`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select p.PhoneNumberID,
         t.PhoneType,
         p.PhoneNumber,
         p.PrimaryPhone
  From PhoneNumbers p
    Inner Join PhoneTypes t
      On t.PhoneTypeID = p.PhoneTypeID
  Where p.UserID = _UserID
  Order By p.CreateDate;
END$$

DELIMITER ;