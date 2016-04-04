USE gr_jci;

DELIMITER $$

/* Links a published author to a published critical incident */
DROP PROCEDURE IF EXISTS `spCreatePublishedIncidentAuthor`$$
CREATE PROCEDURE `spCreatePublishedIncidentAuthor`(IN _AuthorID int,
                                                   IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Make sure the AuthorID exists */
  If(Select Exists(Select 1 From PublishedAuthors Where AuthorID = _AuthorID)) Then
    /* Make sure the CriticalIncidentID exists */
    If(Select Exists(Select 1 From PublishedCriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
      Insert Into PublishedIncidentsAuthors (AuthorID, CriticalIncidentID)
      Values (_AuthorID, _CriticalIncidentID);
    Else
      Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('AuthorID ', _AuthorID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;