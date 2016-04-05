USE gr_jci;

DELIMITER $$

/* Gets the Categories for a Published Incident */
DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentCategories`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentCategories`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  Select pc.CategoryID, pc.Category
  From PublicationCategories pc
    Inner Join PublishedCriticalIncidentCategories pcic
	  On pcic.CategoryID = pc.CategoryID
  Where pcic.CriticalIncidentID = _CriticalIncidentID
  Order By pc.Category;
END$$

DELIMITER ;