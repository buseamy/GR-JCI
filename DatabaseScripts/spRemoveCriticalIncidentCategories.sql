USE gr_jci;

DELIMITER $$

/* Removes a published incident from a publication category */
DROP PROCEDURE IF EXISTS `spRemoveCriticalIncidentCategories`$$
CREATE PROCEDURE `spRemoveCriticalIncidentCategories`(IN _CriticalIncidentID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
  Delete From PublishedCriticalIncidentCategories
  Where CriticalIncidentID = _CriticalIncidentID
    And CategoryID = _CategoryID;
END$$

DELIMITER ;