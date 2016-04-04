USE gr_jci;

DELIMITER $$

/* Gets the list of Editors who are active */
DROP PROCEDURE IF EXISTS `spGetActiveEditors`$$
CREATE PROCEDURE `spGetActiveEditors`()
DETERMINISTIC
BEGIN
  Select u.EmailAddress
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
  Where Active = 1
    And ur.RoleID = 3;
END$$

DELIMITER ;