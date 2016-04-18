USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSearchIncidents`$$
CREATE PROCEDURE `spSearchIncidents`(IN _Title varchar(100),
                                     IN _Keyword varchar(20),
                                     IN _Author varchar(30),
                                     IN _Category varchar(25))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Searches Published Incidents from multiple input parameters
   */
  /* Sanitize the inputs */
  Set _Title = Replace(Replace(Concat('%', IfNull(_Title, '%'), '%'), '%%%', '%'), '%%', '%');
  Set _Keyword = Replace(Replace(Concat('%', IfNull(_Keyword, '%'), '%'), '%%%', '%'), '%%', '%');
  Set _Author = Replace(Replace(Concat('%', IfNull(_Author, '%'), '%'), '%%%', '%'), '%%', '%');
  Set _Category = Replace(Replace(Concat('%', IfNull(_Category, '%'), '%'), '%%%', '%'), '%%', '%');
  
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
    Where pci.IncidentTitle Like _Title
      And pci.Keywords Like _Keyword
      And pa.LastName Like _Author
      And pa.FirstName Like _Author
      And pc.Category Like _Category
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
END$$

DELIMITER ;