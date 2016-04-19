USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spNagAuthorsSubTwoGetList`$$
CREATE PROCEDURE `spNagAuthorsSubTwoGetList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets list of authors who need to submit 2nd submission
   */
  Select Concat(u.FirstName, ' ', u.LastName) As 'FullName',
         u.EmailAddress
  From Users u
    Inner Join AuthorsSubmission aas
      On aas.UserID = u.UserID
    Inner Join Submissions s
      On s.SubmissionID = aas.SubmissionID
  Where s.SubmissionStatusID = 8
    And s.SubmissionID Not In (
           Select PreviousSubmissionID
           From Submissions
           Where Year(SubmissionDate) = Year(CURRENT_DATE)
      )
    And Year(s.SubmissionDate) = Year(CURRENT_DATE)
  Group By u.FirstName, u.LastName, u.EmailAddress;
END$$

DELIMITER ;