USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spReviewerGetFilesList`$$
CREATE PROCEDURE `spReviewerGetFilesList`(IN _ReviewerUserID int, IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file list for a ReviewerUserID & SubmissionID
   */
  Select fmd.FileMetaDataID,
         fmd.FileName,
		 fmd.FileSize,
		 ft.FileType
  From ReviewerFiles rf
    Inner Join FileMetaData fmd
	  On fmd.FileMetaDataID = rf.FileMetaDataID
	Inner Join FileTypes ft
	  On ft.FileTypeID = fmd.FileTypeID
  Where rf.SubmissionID = _SubmissionID
    And rf.ReviewerUserID = _ReviewerUserID;
END$$

DELIMITER ;