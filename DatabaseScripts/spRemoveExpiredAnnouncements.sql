USE gr_jci;

DELIMITER $$

/* Deletes all expired announcements */
DROP PROCEDURE IF EXISTS `spRemoveExpiredAnnouncements`$$
CREATE PROCEDURE `spRemoveExpiredAnnouncements`() DETERMINISTIC
BEGIN
  /*
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID;
  */
  
  Delete From Announcements
  Where IfNull(ExpireDate, CURRENT_DATE) < CURRENT_DATE;
END$$

DELIMITER ;