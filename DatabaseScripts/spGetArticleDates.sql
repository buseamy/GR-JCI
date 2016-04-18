USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetArticleDates`$$
CREATE PROCEDURE `spGetArticleDates`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Article Dates for a year
   */
  /* If the year is null, set it to current year */
  Set _Year = IfNull(_Year, Year(CURRENT_DATE));
  
  Select AuthorFirstSubmissionStartDate,
         AuthorFirstSubmissionDueDate,
         FirstReviewStartDate,
         FirstReviewDueDate,
         AuthorSecondSubmissionStartDate,
         AuthorSecondSubmissionDueDate,
         SecondReviewStartDate,
         SecondReviewDueDate,
         AuthorPublicationSubmissionStartDate,
         AuthorPublicationSubmissionDueDate,
         PublicationDate
  From SystemSettings_ArticleDates
  Where Year = _Year;
END$$

DELIMITER ;