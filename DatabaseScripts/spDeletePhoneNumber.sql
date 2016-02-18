USE gr_jci;

DELIMITER $$

/* Deletes a user's phone number */
DROP PROCEDURE IF EXISTS `spDeletePhoneNumber`$$
CREATE PROCEDURE `spDeletePhoneNumber`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  Delete From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

DELIMITER ;