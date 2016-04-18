USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncident`$$
CREATE PROCEDURE `spGetPublishedCriticalIncident`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the Published Incident info
   */
  Select pci.CriticalIncidentID,
         pci.IncidentTitle,
         pci.Abstract,
		 pci.Keywords,
		 p.Year
  From PublishedCriticalIncidents pci
    Inner Join Publications p
	  On p.PublicationID = pci.PublicationID
  Where pci.CriticalIncidentID = _CriticalIncidentID
  Order By pci.IncidentTitle;
END$$

DELIMITER ;