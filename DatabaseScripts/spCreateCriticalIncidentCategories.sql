USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreateCriticalIncidentCategories`$$
CREATE PROCEDURE `spCreateCriticalIncidentCategories`(IN _CriticalIncidentID int, 
                                                      IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Links a published incident to a publication category
   */
  If(Select Exists(Select 1 From PublishedCriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
    If(Select Exists(Select 1 From PublicationCategories Where CategoryID = _CategoryID)) Then
      Insert Into PublishedCriticalIncidentCategories (CriticalIncidentID, CategoryID)
      Values (_CriticalIncidentID, _CategoryID);
    Else
      Select Concat('CategoryID ', _CategoryID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;