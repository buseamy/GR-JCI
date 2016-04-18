USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreateSubmissionFileMetaData`$$
CREATE PROCEDURE `spCreateSubmissionFileMetaData`(IN _SubmissionID int,
                                                  IN _FileTypeID int,
												  IN _FileMime varchar(200),
												  IN _sFileName varchar(200),
												  IN _sFileSize int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID
   */
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

DELIMITER ;