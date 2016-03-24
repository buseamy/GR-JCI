USE gr_jci;

DELIMITER $$

/* Creates the available Article Dates for a new year  */
DROP PROCEDURE IF EXISTS `spJobCreateArticleDates`$$
CREATE PROCEDURE `spJobCreateArticleDates`()
DETERMINISTIC
BEGIN
  Declare _CurrYear int;
  Set _CurrYear = Year(CURRENT_DATE);
  
  Insert Into SystemSettings_ArticleDates (Year,
                                           AuthorFirstSubmissionStartDate,
                                           AuthorFirstSubmissionDueDate,
										   FirstReviewStartDate,
										   FirstReviewDueDate,
										   AuthorSecondSubmissionStartDate,
										   AuthorSecondSubmissionDueDate,
										   SecondReviewStartDate,
										   SecondReviewDueDate,
										   AuthorPublicationSubmissionStartDate,
										   AuthorPublicationSubmissionDueDate,
										   PublicationDate)
  Select _CurrYear As 'Year',
         CONCAT(_CurrYear, RIGHT(AuthorFirstSubmissionStartDate,6)) As 'AuthorFirstSubmissionStartDate',
         CONCAT(_CurrYear, RIGHT(AuthorFirstSubmissionDueDate,6)) As 'AuthorFirstSubmissionDueDate',
		 CONCAT(_CurrYear, RIGHT(FirstReviewStartDate,6)) As 'FirstReviewStartDate',
		 CONCAT(_CurrYear, RIGHT(FirstReviewDueDate,6)) As 'FirstReviewDueDate',
		 CONCAT(_CurrYear, RIGHT(AuthorSecondSubmissionStartDate,6)) As 'AuthorSecondSubmissionStartDate',
		 CONCAT(_CurrYear, RIGHT(AuthorSecondSubmissionDueDate,6)) As 'AuthorSecondSubmissionDueDate',
		 CONCAT(_CurrYear, RIGHT(SecondReviewStartDate,6)) As 'SecondReviewStartDate',
		 CONCAT(_CurrYear, RIGHT(SecondReviewDueDate,6)) As 'SecondReviewDueDate',
		 CONCAT(_CurrYear, RIGHT(AuthorPublicationSubmissionStartDate,6)) As 'AuthorPublicationSubmissionStartDate',
		 CONCAT(_CurrYear, RIGHT(AuthorPublicationSubmissionDueDate,6)) As 'AuthorPublicationSubmissionDueDate',
		 CONCAT(_CurrYear, RIGHT(PublicationDate,6)) As 'PublicationDate'
  From SystemSettings_ArticleDates
  Where Year = _CurrYear - 1;
END$$

DELIMITER ;