USE gr_jci;

DELIMITER $$

/* Gets the List of available years from Publications in decending order */
DROP PROCEDURE IF EXISTS `spGetPublicationsYearsList`$$
CREATE PROCEDURE `spGetPublicationsYearsList`()
DETERMINISTIC
BEGIN
  Select Year,
         FileMetaDataID
  From Publications
  Order By Year Desc;
END$$

DELIMITER ;