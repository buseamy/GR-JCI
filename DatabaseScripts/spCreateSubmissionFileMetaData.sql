USE gr_jci;

DELIMITER $$

/* Creates the Meta Data record for a file to be uploaded returns the new  */
DROP PROCEDURE IF EXISTS `spCreateSubmissionFileMetaData`$$
CREATE PROCEDURE `spCreateSubmissionFileMetaData`(IN _SubmissionID int,
                                                  IN _FileTypeID int,
												  IN _FileMime varchar(200),
												  IN _sFileName varchar(200),
												  IN _sFileSize int)
DETERMINISTIC
BEGIN
  Declare _FileMetaDataID int;
  
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    Insert Into FileMetaData (FileTypeID,FileMime,FileName,FileSize)
	Values (_FileTypeID,_FileMime,_sFileName,_sFileSize);
	
	/* Get the new FileMetaDataID */
	Set _FileMetaDataID = last_insert_id();
	
	/* Connect the new FileMetaDataID to the SubmissionID */
	Insert Into SubmissionFiles(SubmissionID,FileMetaDataID)
	Values (_SubmissionID,_FileMetaDataID);
	
	/* Output the new FileMetaDataID */
	Select _FileMetaDataID As 'FileMetaDataID';
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

/* Gets the file list for a SubmissionID  */
DROP PROCEDURE IF EXISTS `spSubmissionGetFilesList`$$
CREATE PROCEDURE `spSubmissionGetFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  Select fmd.FileMetaDataID,
         fmd.FileName,
		 fmd.FileSize,
		 ft.FileType
  From SubmissionFiles sf
    Inner Join FileMetaData fmd
	  On fmd.FileMetaDataID = sf.FileMetaDataID
	Inner Join FileTypes ft
	  On ft.FileTypeID = fmd.FileTypeID
  Where sf.SubmissionID = _SubmissionID;
END$$

DELIMITER ;