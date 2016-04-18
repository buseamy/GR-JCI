USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublicationsList`$$
CREATE PROCEDURE `spGetPublicationsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Publications
   */
  Select PublicationID,
         Year,
         FileMetaDataID
  From Publications
  Order By Year;
END$$

DELIMITER ;