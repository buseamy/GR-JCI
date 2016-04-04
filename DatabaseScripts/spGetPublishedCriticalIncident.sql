USE gr_jci;

DELIMITER $$

/* Gets the Published Incident info */
DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncident`$$
CREATE PROCEDURE `spGetPublishedCriticalIncident`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
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