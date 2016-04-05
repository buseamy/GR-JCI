USE gr_jci;

DELIMITER $$

/* Gets the List of available years from Publications */
DROP PROCEDURE IF EXISTS `spGetPublicationsYearsList`$$
CREATE PROCEDURE `spGetPublicationsYearsList`()
DETERMINISTIC
BEGIN
  Select Year
  From Publications
  Order By Year;
END$$

DELIMITER ;