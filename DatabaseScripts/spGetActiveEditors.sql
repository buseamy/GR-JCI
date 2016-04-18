USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetActiveEditors`$$
CREATE PROCEDURE `spGetActiveEditors`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of Editors who are active
   */
  Select u.EmailAddress
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
  Where Active = 1
    And ur.RoleID = 3;
END$$

DELIMITER ;