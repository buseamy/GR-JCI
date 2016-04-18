USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetUsersAuthorsList`$$
CREATE PROCEDURE `spGetUsersAuthorsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of active UserID and FullNames who are Authors
   */
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
  Where ur.RoleID = 1
    And u.Active = 1
	And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

DELIMITER ;