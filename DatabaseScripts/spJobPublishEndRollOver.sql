USE gr_jci;

DELIMITER $$

/* Gets the List of available Article Dates for a year */
DROP PROCEDURE IF EXISTS `spJobPublishEndRollOver`$$
CREATE PROCEDURE `spJobPublishEndRollOver`()
DETERMINISTIC
BEGIN
  Select IF(CURRENT_DATE >= (PublicationDate + INTERVAL 5 DAY), 1, 0) As 'RollOver'
  From SystemSettings_ArticleDates
  Where Year = Year(CURRENT_DATE);
END$$

DELIMITER ;