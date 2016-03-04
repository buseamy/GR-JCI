USE gr_jci;

DELIMITER $$

/* Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID */
DROP PROCEDURE IF EXISTS `spCreateReviewerFileMetaData`$$
CREATE PROCEDURE `spCreateReviewerFileMetaData`(IN _SubmissionID int,
												IN _ReviewerUserID int,
                                                IN _FileTypeID int,
												IN _FileMime varchar(200),
												IN _sFileName varchar(200),
												IN _sFileSize int)
DETERMINISTIC
BEGIN
  Declare _FileMetaDataID int;
  
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the ReviewerUserID exists */
    If(Select Exists(Select 1 From Users Where UserID = _ReviewerUserID)) Then
      Insert Into FileMetaData (FileTypeID,FileMime,FileName,FileSize)
      Values (_FileTypeID,_FileMime,_sFileName,_sFileSize);
      
      /* Get the new FileMetaDataID */
      Set _FileMetaDataID = last_insert_id();
      
      /* Connect the new FileMetaDataID to the SubmissionID */
      Insert Into ReviewerFiles(SubmissionID,ReviewerUserID,FileMetaDataID)
      Values (_SubmissionID,_ReviewerUserID,_FileMetaDataID);
      
      /* Output the new FileMetaDataID */
      Select _FileMetaDataID As 'FileMetaDataID';
	Else
	  Select 'ReviewerUserID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;