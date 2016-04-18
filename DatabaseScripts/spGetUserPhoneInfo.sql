USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetUserPhoneInfo`$$
CREATE PROCEDURE `spGetUserPhoneInfo`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the phone info for an id
   */
  Select PhoneNumberID,
         UserID,
         PhoneTypeID,
         PhoneNumber,
         PrimaryPhone
  From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

DELIMITER ;