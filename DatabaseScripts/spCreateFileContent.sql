USE gr_jci;

DELIMITER $$

/* Inserts a file content record for a FileMetaDataID  */
DROP PROCEDURE IF EXISTS `spCreateFileContent`$$
CREATE PROCEDURE `spCreateFileContent`(IN _FileMetaDataID int,
                                       IN _FileContent blob,
									   IN _SequenceNumber int)
DETERMINISTIC
BEGIN
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Make sure the FileMetaDataID & SequenceNumber doesn't exist */
    If(Select Exists(Select 1 From FileData Where FileMetaDataID = _FileMetaDataID And SequenceNumber = _SequenceNumber)) Then
	  Select 'FileMetaDataID with this SequenceNumber already exists' As 'Error';
	Else
	  Insert Into FileData (FileMetaDataID,FileContents,SequenceNumber)
	  Values (_FileMetaDataID,_FileContent,_SequenceNumber);
	End If;
  Else
    Select 'FileMetaDataID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;