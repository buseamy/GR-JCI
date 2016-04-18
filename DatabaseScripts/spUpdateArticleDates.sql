USE gr_jci;

DELIMITER $$

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
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates the available Article Dates for a year
   */
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