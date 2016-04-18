USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spDeletePhoneNumber`$$
CREATE PROCEDURE `spDeletePhoneNumber`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes a user's phone number
   */
  Delete From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

DELIMITER ;