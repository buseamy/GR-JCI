USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetAllAnnouncementsList`$$
CREATE PROCEDURE `spGetAllAnnouncementsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of all Announcements
   */
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