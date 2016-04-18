USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetUsersList`$$
CREATE PROCEDURE `spGetUsersList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Get the list of users, both active and inactive in alphbetical order
   */
  Select u.UserID,
         u.EmailAddress,
         CONCAT(u.LastName,', ',u.FirstName) As 'FullName',
         GROUP_CONCAT(r.RoleTitle) As 'Roles',
         IF(u.Active, 'Y', 'N') As 'IsActive'
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
    Inner Join Roles r
      On r.RoleID = ur.RoleID
  Group By u.UserID,
           u.EmailAddress,
           u.FirstName,
           u.LastName,
           u.Active
  Order By u.LastName,
           u.FirstName,
           u.UserID;
END$$

DELIMITER ;