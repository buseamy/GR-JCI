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
                                           SeasonStartDate,
                                           FirstSubmissionEndDate,
										   FirstReviewEndDate,
										   SecondSubmissionEndDate,
										   SecondReviewEndDate,
										   PublicationSubmissionEndDate)
  Select _CurrYear As 'Year',
         CONCAT(_CurrYear, RIGHT(SeasonStartDate,6)) As 'SeasonStartDate',
         CONCAT(_CurrYear, RIGHT(FirstSubmissionEndDate,6)) As 'FirstSubmissionEndDate',
		 CONCAT(_CurrYear, RIGHT(FirstReviewEndDate,6)) As 'FirstReviewEndDate',
		 CONCAT(_CurrYear, RIGHT(SecondSubmissionEndDate,6)) As 'SecondSubmissionEndDate',
		 CONCAT(_CurrYear, RIGHT(SecondReviewEndDate,6)) As 'SecondReviewEndDate',
		 CONCAT(_CurrYear, RIGHT(PublicationSubmissionEndDate,6)) As 'PublicationSubmissionEndDate'
  From SystemSettings_ArticleDates
  Where Year = _CurrYear - 1;
END$$

DELIMITER ;