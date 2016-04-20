USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetAnnouncement`$$
CREATE PROCEDURE `spGetAnnouncement`(IN _AnnouncementID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the info of an announcement
   */
  Select AnnouncementID,
         Title,
         Message,
         CreateDate,
         IfNull(ExpireDate,'') As 'ExpireDate'
  From Announcements
  Where AnnouncementID = _AnnouncementID;
END$$

DELIMITER ;