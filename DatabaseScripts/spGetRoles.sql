USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetRoles`$$
CREATE PROCEDURE `spGetRoles`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available roles
   */
  Select RoleID,
         RoleTitle
  From Roles
  Order By RoleTitle;
END$$

DELIMITER ;