USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spRemoveCriticalIncidentCategories`$$
CREATE PROCEDURE `spRemoveCriticalIncidentCategories`(IN _CriticalIncidentID int,
                                                      IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a published incident from a publication category
   */
  Delete From PublishedCriticalIncidentCategories
  Where CriticalIncidentID = _CriticalIncidentID
    And CategoryID = _CategoryID;
END$$

DELIMITER ;