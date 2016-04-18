USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublicationsYearsList`$$
CREATE PROCEDURE `spGetPublicationsYearsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available years from Publications in decending order
   */
  Select Year,
         FileMetaDataID
  From Publications
  Order By Year Desc;
END$$

DELIMITER ;