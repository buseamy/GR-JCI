USE gr_jci;

DELIMITER $$

/* Gets the phone info for an id */
DROP PROCEDURE IF EXISTS `spGetUserPhoneInfo`$$
CREATE PROCEDURE `spGetUserPhoneInfo`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  Select PhoneNumberID,
         UserID,
         PhoneTypeID,
         PhoneNumber,
         PrimaryPhone
  From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

DELIMITER ;