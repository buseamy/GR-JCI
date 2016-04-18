USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSubmissionGetFilesList`$$
CREATE PROCEDURE `spSubmissionGetFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file list for a SubmissionID
   */
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