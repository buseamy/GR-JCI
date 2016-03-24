USE gr_jci;

DELIMITER $$

/* Updates the available Article Dates for a year  */
DROP PROCEDURE IF EXISTS `spUpdateArticleDates`$$
CREATE PROCEDURE `spUpdateArticleDates`(IN _Year int,
                                        IN _AuthorFirstSubmissionStartDate date,
										IN _AuthorFirstSubmissionDueDate date,
										IN _FirstReviewStartDate date,
										IN _FirstReviewDueDate date,
										IN _AuthorSecondSubmissionStartDate date,
										IN _AuthorSecondSubmissionDueDate date,
										IN _SecondReviewStartDate date,
										IN _SecondReviewDueDate date,
										IN _AuthorPublicationSubmissionStartDate date,
										IN _AuthorPublicationSubmissionDueDate date,
										IN _PublicationDate date)
DETERMINISTIC
BEGIN
  Update SystemSettings_ArticleDates
  Set AuthorFirstSubmissionStartDate = _AuthorFirstSubmissionStartDate,
      AuthorFirstSubmissionDueDate = _AuthorFirstSubmissionDueDate,
      FirstReviewStartDate = _FirstReviewStartDate,
      FirstReviewDueDate = _FirstReviewDueDate,
      AuthorSecondSubmissionStartDate = _AuthorSecondSubmissionStartDate, 
      AuthorSecondSubmissionDueDate = _AuthorSecondSubmissionDueDate, 
      SecondReviewStartDate = _SecondReviewStartDate, 
      SecondReviewDueDate = _SecondReviewDueDate, 
      AuthorPublicationSubmissionStartDate = _AuthorPublicationSubmissionStartDate, 
      AuthorPublicationSubmissionDueDate = _AuthorPublicationSubmissionDueDate, 
      PublicationDate = _PublicationDate
  Where Year = _Year;
END$$

DELIMITER ;