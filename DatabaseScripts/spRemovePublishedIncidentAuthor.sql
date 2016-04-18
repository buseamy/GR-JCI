USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spRemovePublishedIncidentAuthor`$$
CREATE PROCEDURE `spRemovePublishedIncidentAuthor`(IN _AuthorID int,
                                                   IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a published author to a published critical incident
   */
  /* Make sure the AuthorID exists */
  If(Select Exists(Select 1 From PublishedAuthors Where AuthorID = _AuthorID)) Then
    /* Make sure the CriticalIncidentID exists */
    If(Select Exists(Select 1 From PublishedCriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
      Delete From PublishedIncidentsAuthors
      Where AuthorID = _AuthorID
        And CriticalIncidentID = _CriticalIncidentID;
    Else
      Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('AuthorID ', _AuthorID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;