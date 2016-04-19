USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spNagReviewersGetList`$$
CREATE PROCEDURE `spNagReviewersGetList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets list of reviewers who still have reviews to complete
   */
  Select Concat(u.FirstName, ' ', u.LastName) As 'FullName',
         u.EmailAddress
  From Users u
    Inner Join Reviewers r
      On r.ReviewerUserID = u.UserID
    Inner Join Submissions s
      On r.SubmissionID = s.SubmissionID
  Where r.ReviewStatusID = 1
    And Year(s.SubmissionDate) = Year(CURRENT_DATE)
  Group By u.FirstName, u.LastName, u.EmailAddress;
END$$

DELIMITER ;