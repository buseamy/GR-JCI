USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spJobPublishEndRollOver`$$
CREATE PROCEDURE `spJobPublishEndRollOver`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Article Dates for a year
   */
  Select IF(CURRENT_DATE >= (PublicationDate + INTERVAL 5 DAY), 1, 0) As 'RollOver'
  From SystemSettings_ArticleDates
  Where Year = Year(CURRENT_DATE);
END$$

DELIMITER ;