USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spAnnouncementRemoveRole`$$
CREATE PROCEDURE `spAnnouncementRemoveRole`(IN _AnnouncementID int,
                                            IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes an AnnouncementID with a RoleID
   */
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID
    And RoleID = _RoleID;
END$$

DELIMITER ;