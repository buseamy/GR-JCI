USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spReviewerAddToSubmission`$$
CREATE PROCEDURE `spReviewerAddToSubmission`(IN _UserID int,
                                             IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Adds a Reviewer UserID to an existing Submission
   */
  /* Make sure the UserID exists and is a reviewer */
  If(Select Exists(Select 1 From Users u Inner Join UserRoles ur On ur.UserID = u.UserID Where u.UserID = _UserID And ur.RoleID = 2)) Then
    /* Make sure the SubmissionID exists */
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
      /* Make sure the combination doesn't exist */
      If(Select Exists(Select 1 From Reviewers Where SubmissionID = _SubmissionID And ReviewerUserID = _UserID)) Then
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
      End If;
    Else
      Select Concat('SubmissionID ', _SubmissionID,' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('UserID ', _UserID, ' doesn''t exist or isn''t a reviewer') As 'Error';
  End If;
END$$

DELIMITER ;