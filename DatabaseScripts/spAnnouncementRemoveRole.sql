USE gr_jci;

DELIMITER $$

/* Removes an AnnouncementID with a RoleID */
DROP PROCEDURE IF EXISTS `spAnnouncementRemoveRole`$$
CREATE PROCEDURE `spAnnouncementRemoveRole`(IN _AnnouncementID int, IN _RoleID int)
DETERMINISTIC
BEGIN
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID
    And RoleID = _RoleID;
END$$

DELIMITER ;