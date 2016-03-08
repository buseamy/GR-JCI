USE gr_jci;

DELIMITER $$

/* Update a reviewer's record to change the status */
DROP PROCEDURE IF EXISTS `spReviewerUpdateReviewStatus`$$
CREATE PROCEDURE `spReviewerUpdateReviewStatus`(IN _ReviewerUserID int,
                                                IN _SubmissionID int,
												IN _ReviewStatusID int)
DETERMINISTIC
BEGIN
  Declare _TotalReviewers int;
  Declare _ReviewCompleted int;
  
  /* Make sure the ReviewStatusID exists */
  If(Select Exists(Select 1 From ReviewStatus Where ReviewStatusID = _ReviewStatusID)) Then
    /* Make sure the ReviewerUserID and SubmissionID combination exists */
    If(Select Exists(Select 1 From Reviewers Where ReviewerUserID = _ReviewerUserID And SubmissionID = _SubmissionID)) Then
	  /* Update the Reviewer record */
	  Update Reviewers
	  Set ReviewStatusID = _ReviewStatusID,
	      ReviewCompletionDate = CURRENT_DATE,
		  LastUpdatedDate = CURRENT_DATE
	  Where ReviewerUserID = _ReviewerUserID
	    And SubmissionID = _SubmissionID;
	  
	  /* Get the total Reviewers count for the submision */
	  Select Count(ReviewerUserID) Into _TotalReviewers
	  From Reviewers
	  Where SubmissionID = _SubmissionID;
	  
	  /* Get the reviews completed count for the submission */
	  Select Count(ReviewerUserID) Into _ReviewCompleted
	  From Reviewers
	  Where SubmissionID = _SubmissionID
	    And ReviewCompletionDate Is Not Null;
	  
	  /* Update the submission status if this is last review completion */
	  If (_TotalReviewers - _ReviewCompleted = 0) Then
	    Update Submissions
	    Set SubmissionStatusID = 5
	    Where SubmissionID = _SubmissionID;
	  End If;
	Else
	  Select 'ReviewerUserID and SubmissionID combination doesn''t exist' As 'Error';
	End If;
  Else
    Select 'ReviewStatusID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;