USE gr_jci;

DELIMITER $$

/* Gets the List of available Article Dates for a year */
DROP PROCEDURE IF EXISTS `spGetArticleDates`$$
CREATE PROCEDURE `spGetArticleDates`(IN _Year int)
DETERMINISTIC
BEGIN
  /* If the year is null, set it to current year */
  Set _Year = IfNull(_Year, Year(CURRENT_DATE));
  
  Select SeasonStartDate,
         FirstSubmissionEndDate,
         FirstReviewEndDate,
         SecondSubmissionEndDate,
         SecondReviewEndDate, 
         PublicationSubmissionEndDate
  From SystemSettings_ArticleDates
  Where Year = _Year;
END$$

DELIMITER ;