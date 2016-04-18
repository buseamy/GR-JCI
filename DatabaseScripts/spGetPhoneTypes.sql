USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPhoneTypes`$$
CREATE PROCEDURE `spGetPhoneTypes`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of phone numbers
   */
  Select PhoneTypeID, PhoneType
  From PhoneTypes
  Order By PhoneType;
END$$

DELIMITER ;