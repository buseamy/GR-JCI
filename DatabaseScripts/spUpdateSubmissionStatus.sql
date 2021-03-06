USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateSubmissionStatus`$$
CREATE PROCEDURE `spUpdateSubmissionStatus`(IN _SubmissionID int,
                                            IN _SubmissionStatusID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing Submissions' status:
   SubmissionStatusID 2 : Editor Assigned, DON'T USE, spSubmissionAssignEditor will do this automatically
   SubmissionStatusID 3 : Editor Updated
   SubmissionStatusID 4 : Reviewers Assigned
   SubmissionStatusID 5 : Reviews Completed, DON'T USE, use spReviewerUpdateReviewStatus procedure instead
   SubmissionStatusID 6 : Editor Reviewed
   SubmissionStatusID 7 : Ready for Publish
   SubmissionStatusID 8 : Revision Needed
   */
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the SubmissionStatusID exists */
    If(Select Exists(Select 1 From SubmissionStatus Where SubmissionStatusID = _SubmissionStatusID)) Then
      /* Update the Submission record */
	  Update Submissions
	  Set SubmissionStatusID = _SubmissionStatusID
	  Where SubmissionID = _SubmissionID;
    Else
      Select 'SubmissionStatusID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;