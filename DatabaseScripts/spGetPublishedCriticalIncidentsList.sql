USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentsList`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentsList`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list Published Incidents for a year for search page
   */
  Select pci.CriticalIncidentID,
         pci.IncidentTitle,
         pci.Abstract,
         pci.Keywords,
         Group_Concat(concat(pa.LastName, ', ', pa.FirstName)) As 'Authors',
         pci.FileMetaDataID
  From PublishedCriticalIncidents pci
    Inner Join Publications p
	  On p.PublicationID = pci.PublicationID
    Right Join PublishedIncidentsAuthors pia
      On pia.CriticalIncidentID = pci.CriticalIncidentID
    Right Join PublishedAuthors pa
      On pa.AuthorID = pia.AuthorID
  Where p.Year = _Year
  Group By pci.CriticalIncidentID,
           pci.IncidentTitle,
           pci.Abstract,
           pci.Keywords,
           pci.FileMetaDataID
  Order By pci.IncidentTitle;
END$$

DELIMITER ;