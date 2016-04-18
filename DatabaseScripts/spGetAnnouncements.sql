USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetAnnouncements`$$
CREATE PROCEDURE `spGetAnnouncements`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of Announcements for a UserID
   */
  Select rtn.Title,
         rtn.Message,
         rtn.CreateDate,
         IfNull(rtn.ExpireDate,'') As 'ExpireDate'
  From (
    Select Title,
           Message,
           CreateDate,
           ExpireDate
    From Announcements a
      Inner Join AccouncementRoles ar
        On ar.AnnouncementID = a.AnnouncementID 
    Where ar.RoleID = 6 /* Public announcements */
    Union All
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
      Inner Join Users u
        On u.UserID = ur.UserID
    Where u.UserID = _UserID /* User specific (all roles) announcements */
  ) rtn
  Group By rtn.Title,
           rtn.Message,
           rtn.CreateDate,
           rtn.ExpireDate
  Order By rtn.CreateDate,
           rtn.Title;
END$$

DELIMITER ;