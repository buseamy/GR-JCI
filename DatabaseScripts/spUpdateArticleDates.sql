USE gr_jci;

DELIMITER $$

/* Updates the available Article Dates for a year  */
DROP PROCEDURE IF EXISTS `spUpdateArticleDates`$$
CREATE PROCEDURE `spUpdateArticleDates`(IN _Year int,
                                        IN _SeasonStartDate date,
										IN _FirstSubmissionEndDate date,
										IN _FirstReviewEndDate date,
										IN _SecondSubmissionEndDate date,
										IN _SecondReviewEndDate date,
										IN _PublicationSubmissionEndDate date)
DETERMINISTIC
BEGIN
  Update SystemSettings_ArticleDates
  Set SeasonStartDate = _SeasonStartDate,
      FirstSubmissionEndDate = _FirstSubmissionEndDate,
      FirstReviewEndDate = _FirstReviewEndDate,
      SecondSubmissionEndDate = _SecondSubmissionEndDate,
      SecondReviewEndDate = _SecondReviewEndDate, 
      PublicationSubmissionEndDate = _PublicationSubmissionEndDate
  Where Year = _Year;
END$$

DELIMITER ;