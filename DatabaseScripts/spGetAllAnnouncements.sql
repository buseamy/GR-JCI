USE gr_jci;

DELIMITER $$

/* Gets the list of all Announcements */
DROP PROCEDURE IF EXISTS `spGetAllAnnouncements`$$
CREATE PROCEDURE `spGetAllAnnouncements`()
DETERMINISTIC
BEGIN
  Select a.Title,
         GROUP_CONCAT(r.RoleTitle) As 'Roles',
         a.CreateDate,
		 IfNull(a.ExpireDate,'') As 'ExpireDate'
  From Announcements a
    Inner Join AccouncementRoles ar
	  On ar.AnnouncementID = a.AnnouncementID
	Inner Join Roles r
	  On r.RoleID = ar.RoleID
	Order By CreateDate,
	         Title;
END$$

DELIMITER ;