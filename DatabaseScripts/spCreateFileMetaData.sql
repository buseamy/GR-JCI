USE gr_jci;

DELIMITER $$

/* Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID */
DROP PROCEDURE IF EXISTS `spCreateFileMetaData`$$
CREATE PROCEDURE `spCreateFileMetaData`(IN _FileTypeID int,
                                        IN _FileMime varchar(200),
                                        IN _sFileName varchar(200),
                                        IN _sFileSize int)
DETERMINISTIC
BEGIN
  Declare _FileMetaDataID int;
  
  /* Make sure the FileTypeID exists */
  If(Select Exists(Select 1 From FileTypes Where FileTypeID = _FileTypeID)) Then
    Insert Into FileMetaData (FileTypeID,FileMime,FileName,FileSize)
    Values (_FileTypeID,_FileMime,_sFileName,_sFileSize);
    
    /* Return the new FileMetaDataID */
    Select last_insert_id() As 'FileMetaDataID';
  Else
    Select Concat('FileTypeID ', _FileTypeID,' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;