USE gr_jci;

DELIMITER $$

/* Searches Published Incidents from a single input parameter */
DROP PROCEDURE IF EXISTS `spSearchIncidentsSingleInput`$$
CREATE PROCEDURE `spSearchIncidentsSingleInput`(IN _SearchTerm varchar(100))
DETERMINISTIC
BEGIN
  /* Make sure there's something to search for */
  If ((_SearchTerm Is Not Null) And (Char_Length(_SearchTerm) > 0)) Then
    /* Make sure the SearchTerm has wildcard chars around it */
    Set _SearchTerm = Concat('%', _SearchTerm, '%');
    
    Select results.CriticalIncidentID,
           results.Year,
           results.IncidentTitle,
           results.Abstract,
           results.Keywords,
           results.Authors,
           results.Categories,
           results.FileMetaDataID
    From (
      Select pci.CriticalIncidentID,
             p.Year,
             pci.IncidentTitle,
             pci.Abstract,
             pci.Keywords,
             GROUP_CONCAT(Concat(pa.LastName, ' ,', pa.FirstName) SEPARATOR '; ') As 'Authors',
             GROUP_CONCAT(pc.Category SEPARATOR '; ') As 'Categories',
             pci.FileMetaDataID
      From Publications p
        Inner Join PublishedCriticalIncidents pci
          On pci.PublicationID = p.PublicationID
        Right Join PublishedIncidentsAuthors pia
          On pia.CriticalIncidentID = pci.CriticalIncidentID
        Right Join PublishedAuthors pa
          On pa.AuthorID = pia.AuthorID
        Right Join PublishedCriticalIncidentCategories pcic
          On pcic.CriticalIncidentID = pci.CriticalIncidentID
        Right Join PublicationCategories pc
          On pc.CategoryID = pcic.CategoryID
      Where p.Year Like _SearchTerm
        Or pci.IncidentTitle Like _SearchTerm
        Or pci.Abstract Like _SearchTerm
        Or pci.Keywords Like _SearchTerm
        Or pa.LastName Like _SearchTerm
        Or pa.FirstName Like _SearchTerm
        Or pc.Category Like _SearchTerm
      Group By pci.CriticalIncidentID,
               p.Year,
               pci.IncidentTitle,
               pci.Abstract,
               pci.Keywords) As results
    Group By results.CriticalIncidentID,
             results.Year,
             results.IncidentTitle,
             results.Abstract,
             results.Keywords,
             results.Authors,
             results.Categories
    Order By results.IncidentTitle Asc,
             results.Year Desc;
  End If;
END$$

DELIMITER ;