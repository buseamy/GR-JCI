USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spAuthorGetSubmissionReviewerFilesList`$$
CREATE PROCEDURE `spAuthorGetSubmissionReviewerFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Lists the feedback files for a submission
   */
  Select fmd.FileMetaDataID,
         fmd.FileName,
		 fmd.FileSize,
		 ft.FileType
  From Reviewers r
    Inner Join ReviewerFiles rf
	  On rf.ReviewerUserID = r.ReviewerUserID
	    And rf.SubmissionID = r.SubmissionID
    Inner Join FileMetaData fmd
	  On fmd.FileMetaDataID = rf.FileMetaDataID
	Inner Join FileTypes ft
	  On ft.FileTypeID = fmd.FileTypeID
  Where rf.SubmissionID = _SubmissionID;
END$$

DELIMITER ;