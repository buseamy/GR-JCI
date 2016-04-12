USE gr_jci;

DELIMITER $$

/* Gets the list of all Announcements */
DROP PROCEDURE IF EXISTS `spGetAllAnnouncementsList`$$
CREATE PROCEDURE `spGetAllAnnouncementsList`()
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
  Group By a.Title,
           a.CreateDate,
           a.ExpireDate
  Order By a.CreateDate,
           a.Title;
END$$

DELIMITER ;