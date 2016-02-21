USE gr_jci;

DELIMITER $$

/* Gets the List of available roles */
DROP PROCEDURE IF EXISTS `spGetRoles`$$
CREATE PROCEDURE `spGetRoles`()
DETERMINISTIC
BEGIN
  Select RoleID,
         RoleTitle
  From Roles
  Order By RoleTitle;
END$$

DELIMITER ;