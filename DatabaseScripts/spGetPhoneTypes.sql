USE gr_jci;

DELIMITER $$

/* Gets the list of types of phone numbers */
DROP PROCEDURE IF EXISTS `spGetPhoneTypes`$$
CREATE PROCEDURE `spGetPhoneTypes`()
DETERMINISTIC
BEGIN
  Select PhoneTypeID, PhoneType
  From PhoneTypes
  Order By PhoneType;
END$$

DELIMITER ;