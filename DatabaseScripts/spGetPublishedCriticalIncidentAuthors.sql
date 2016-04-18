USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentAuthors`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentAuthors`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the Authors for a Published Incident
   */
  Select Concat(pa.LastName, ', ', pa.FirstName) As 'FullName',
         pa.EmailAddress,
		 pa.InstitutionAffiliation
  From PublishedAuthors pa
    Inner Join PublishedIncidentsAuthors pca
	  On pca.AuthorID = pa.AuthorID
  Where pca.CriticalIncidentID = _CriticalIncidentID
  Order By pa.LastName, pa.FirstName;
END$$

DELIMITER ;