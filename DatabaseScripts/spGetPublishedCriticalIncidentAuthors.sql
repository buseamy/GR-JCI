USE gr_jci;

DELIMITER $$

/* Gets the Authors for a Published Incident */
DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentAuthors`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentAuthors`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
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