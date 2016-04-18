USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateFileMetaData`$$
CREATE PROCEDURE `spUpdateFileMetaData`(IN _FileMetaDataID int,
                                        IN _FileTypeID int,
										IN _FileMime varchar(200),
										IN _sFileName varchar(200),
										IN _sFileSize int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the FileMetaData record for a FileMetaDataID, also deletes the associated FileData records
   */
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Deletes the Contents records */
    Delete From FileData
	Where FileMetaDataID = _FileMetaDataID;
	
	/* Set's the new meta data info */
    Update FileMetaData
	Set FileTypeID = _FileTypeID,
	    FileMime = _FileMime,
		FileName = _sFileName,
		FileSize = _sFileSize
	Where FileMetaDataID = _FileMetaDataID;
  Else
    Select 'FileMetaDataID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;