USE gr_jci;

DELIMITER $$

/* Gets a list of announcements for a UserID */
DROP PROCEDURE IF EXISTS `spGetUserAnnouncements`$$
CREATE PROCEDURE `spGetUserAnnouncements`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select a.Title,
         a.Message,
         a.CreateDate,
		 a.ExpireDate
  From Announcements a
    Inner Join AccouncementRoles ar
	  On ar.AnnouncementID = a.AnnouncementID
	Inner Join Roles r
	  On r.RoleID = ar.RoleID
	Inner Join UserRoles ur
	  On ur.RoleID = r.RoleID
  Where ur.UserID = _UserID
  Group By a.Title,
           a.Message,
           a.CreateDate,
		   a.ExpireDate
  Order By a.CreateDate,
           a.Title;
END$$

DELIMITER ;