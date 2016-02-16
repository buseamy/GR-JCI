USE gr_jci;

DELIMITER $$

/* Gets the roles associated with a UserID */
DROP PROCEDURE IF EXISTS `spGetUsersRoles`$$
CREATE PROCEDURE `spGetUsersRoles`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select r.RoleTitle
  From UserRoles ur
    Inner Join Roles r
      On r.RoleID = ur.RoleID
  Where ur.UserID = _UserID;
END$$

DELIMITER ;