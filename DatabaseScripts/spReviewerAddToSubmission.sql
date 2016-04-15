USE gr_jci;

DELIMITER $$

/* Adds a Reviewer UserID to an existing Submission */
DROP PROCEDURE IF EXISTS `spReviewerAddToSubmission`$$
CREATE PROCEDURE `spReviewerAddToSubmission`(IN _UserID int,
                                             IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the SubmissionID exists */
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
      /* Link the UserID to the SubmissionID */
      Insert Into Reviewers (ReviewerUserID,
                             SubmissionID,
                             ReviewStatusID,
                             CreateDate,
                             LastUpdatedDate)
      Values (_UserID,
              _SubmissionID,
              1,
              CURRENT_DATE,
              CURRENT_DATE);

      Select s.IncidentTitle,
             Concat(u.LastName, ', ', u.FirstName) As 'ReviewerFullName'
      From Reviewers r
        Inner Join Submissions s
          On s.SubmissionID = r.SubmissionID
        Inner Join Users u
          On u.UserID = r.ReviewerUserID
      Where r.ReviewerUserID = _UserID
        And r.SubmissionID = _SubmissionID;
    Else
      Select 'SubmissionID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;