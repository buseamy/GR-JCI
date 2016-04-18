USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidents`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidents`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list Published Incidents for a year for editor adding
   */
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