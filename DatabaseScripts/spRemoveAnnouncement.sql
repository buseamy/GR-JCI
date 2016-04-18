USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spRemoveAnnouncement`$$
CREATE PROCEDURE `spRemoveAnnouncement`(IN _AnnouncementID int) DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes an existing announcement
   */
  /* Remove the Accouncement from the roles */
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID;
  
  /* Remove the Accouncement itself */
  Delete From Announcements
  Where AnnouncementID = _AnnouncementID;
END$$

DELIMITER ;