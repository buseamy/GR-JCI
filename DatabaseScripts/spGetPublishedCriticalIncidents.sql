USE gr_jci;

DELIMITER $$

/* Gets the list Published Incidents for a year for editor adding */
DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidents`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidents`(IN _Year int)
DETERMINISTIC
BEGIN
  Select pci.CriticalIncidentID,
         pci.IncidentTitle,
         pci.Abstract
  From PublishedCriticalIncidents pci
    Inner Join Publications p
	  On p.PublicationID = pci.PublicationID
  Where p.Year = _Year
  Order By pci.IncidentTitle;
END$$

DELIMITER ;