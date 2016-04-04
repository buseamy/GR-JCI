USE gr_jci;

DELIMITER $$

/* Gets the List of available Publications */
DROP PROCEDURE IF EXISTS `spGetPublicationsList`$$
CREATE PROCEDURE `spGetPublicationsList`()
DETERMINISTIC
BEGIN
  Select PublicationID,
         Year,
         FileMetaDataID
  From Publications
  Order By Year;
END$$

DELIMITER ;