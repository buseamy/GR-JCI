USE gr_jci;

DELIMITER $$

/* Deletes all expired announcements */
DROP PROCEDURE IF EXISTS `spJobRemoveExpiredAnnouncements`$$
CREATE PROCEDURE `spJobRemoveExpiredAnnouncements`() DETERMINISTIC
BEGIN

  /* Remove the associated roles with the expired announcements */
  Delete From AccouncementRoles
  Where AnnouncementID IN (
        Select AnnouncementID
		From Announcements
		Where IfNull(ExpireDate, CURRENT_DATE) < CURRENT_DATE
	);

  /* Remove the expired announcements */
  Delete From Announcements
  Where IfNull(ExpireDate, CURRENT_DATE) < CURRENT_DATE;
END$$

DELIMITER ;