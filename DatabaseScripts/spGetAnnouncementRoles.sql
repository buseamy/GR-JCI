USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetAnnouncementRoles`$$
CREATE PROCEDURE `spGetAnnouncementRoles`(IN _AnnouncementID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of roles for an announcement
   */
  Select r.RoleTitle
  From AccouncementRoles ar
    Inner Join Roles r
      On r.RoleID = ar.RoleID
  Where ar.AnnouncementID = _AnnouncementID;
END$$

DELIMITER ;