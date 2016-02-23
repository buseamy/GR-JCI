USE gr_jci;

DELIMITER $$

/* Get the list of users, both active and inactive in alphbetical order */
DROP PROCEDURE IF EXISTS `spGetUsersList`$$
CREATE PROCEDURE `spGetUsersList`()
DETERMINISTIC
BEGIN
  Select u.UserID,
         u.EmailAddress,
		 CONCAT(u.FirstName,' ',u.LastName) As 'Name',
		 GROUP_CONCAT(r.RoleTitle) As 'Roles',
		 IF(u.Active, 'Y', 'N') As 'IsActive'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
	Inner Join Roles r
	  On r.RoleID = ur.RoleID
  Order By u.LastName,
           u.FirstName,
		   u.UserID;
END$$

DELIMITER ;