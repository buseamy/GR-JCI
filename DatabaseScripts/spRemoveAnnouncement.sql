USE gr_jci;

DELIMITER $$

/* Deletes an existing announcement */
DROP PROCEDURE IF EXISTS `spRemoveAnnouncement`$$
CREATE PROCEDURE `spRemoveAnnouncement`(IN _AnnouncementID int) DETERMINISTIC
BEGIN
  /* Remove the Accouncement from the roles */
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID;
  
  /* Remove the Accouncement itself */
  Delete From Announcements
  Where AnnouncementID = _AnnouncementID;
END$$

DELIMITER ;