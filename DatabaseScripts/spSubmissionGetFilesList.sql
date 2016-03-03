USE gr_jci;

DELIMITER $$

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