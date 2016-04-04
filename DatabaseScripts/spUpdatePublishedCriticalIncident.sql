USE gr_jci;

DELIMITER $$

/* Updates a Published Critical Incident record */
DROP PROCEDURE IF EXISTS `spUpdatePublishedCriticalIncident`$$
CREATE PROCEDURE `spUpdatePublishedCriticalIncident`(IN _CriticalIncidentID int,
                                                     IN _PublicationID int,
                                                     IN _IncidentTitle varchar(150),
													 IN _Abstract varchar(5000),
													 IN _Keywords varchar(5000),
													 IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Make sure the CriticalIncidentID exists */
  If(Select Exists(Select 1 From CriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
    /* Make sure the FileMetaDataID exists */
    If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
	  /* Make sure the PublicationID exists */
	  If(Select Exists(Select 1 From Publications Where PublicationID = _PublicationID)) Then
	    Update CriticalIncidents
	    Set PublicationID = _PublicationID,
		    IncidentTitle = _IncidentTitle,
			Abstract = _Abstract,
			Keywords = _Keywords,
		    FileMetaDataID = _FileMetaDataID
	    Where CriticalIncidentID = _CriticalIncidentID;
	  Else
	    Select Concat('PublicationID ', _PublicationID, ' doesn''t exist') As 'Error';
	  End If;
	Else
	  Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
	End If;
  Else
    Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;