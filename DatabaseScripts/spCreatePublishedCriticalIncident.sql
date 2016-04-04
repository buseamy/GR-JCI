USE gr_jci;

DELIMITER $$

/* Creates a Published Critical Incident record */
DROP PROCEDURE IF EXISTS `spCreatePublishedCriticalIncident`$$
CREATE PROCEDURE `spCreatePublishedCriticalIncident`(IN _PublicationID int,
                                                     IN _IncidentTitle varchar(150),
													 IN _Abstract varchar(5000),
													 IN _Keywords varchar(5000),
													 IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Make sure the PublicationID exists */
    If(Select Exists(Select 1 From Publications Where PublicationID = _PublicationID)) Then
	  Insert Into PublishedCriticalIncidents (PublicationID, IncidentTitle, Abstract, Keywords, FileMetaDataID)
	  Values (_PublicationID, _IncidentTitle, _Abstract, _Keywords, _FileMetaDataID);

	  Select last_insert_id() As 'CriticalIncidentID';
    Else
      Select Concat('PublicationID ', _PublicationID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;