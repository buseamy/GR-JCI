USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentCategories`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentCategories`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the Categories for a Published Incident
   */
  Select pc.CategoryID, pc.Category
  From PublicationCategories pc
    Inner Join PublishedCriticalIncidentCategories pcic
	  On pcic.CategoryID = pc.CategoryID
  Where pcic.CriticalIncidentID = _CriticalIncidentID
  Order By pc.Category;
END$$

DELIMITER ;