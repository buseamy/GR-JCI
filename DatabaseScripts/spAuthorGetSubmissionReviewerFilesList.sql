USE gr_jci;

DELIMITER $$

/* Lists the feedback files for a submission */
DROP PROCEDURE IF EXISTS `spAuthorGetSubmissionReviewerFilesList`$$
CREATE PROCEDURE `spAuthorGetSubmissionReviewerFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
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
  Where rf.SubmissionID = _SubmissionID
    And r.ReviewCompletionDate Is Not Null;
END$$

DELIMITER ;