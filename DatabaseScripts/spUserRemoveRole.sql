USE gr_jci;

DELIMITER $$

/* Removes a UserID with a RoleID */
DROP PROCEDURE IF EXISTS `spUserRemoveRole`$$
CREATE PROCEDURE `spUserRemoveRole`(IN _UserID int, IN _RoleID int)
DETERMINISTIC
BEGIN
  Delete From UserRoles
  Where UserID = _UserID
    And RoleID = _RoleID;
END$$

DELIMITER ;