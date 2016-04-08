USE gr_jci;

DELIMITER $$

/* Gets the spot in the editing process by current date */
DROP PROCEDURE IF EXISTS `spGetSpotInProcess`$$
CREATE PROCEDURE `spGetSpotInProcess`()
DETERMINISTIC
BEGIN
  /* Store the current date */
  Declare _CurrDate date;
  Declare _SpotID int;
  Set _CurrDate = CURRENT_DATE;
  
  Select Case 
    When _CurrDate Between AuthorFirstSubmissionStartDate And AuthorFirstSubmissionDueDate Then 1
    When _CurrDate Between AuthorFirstSubmissionDueDate And FirstReviewStartDate Then 2
    When _CurrDate Between FirstReviewStartDate And FirstReviewDueDate Then 3
    When _CurrDate Between FirstReviewDueDate And AuthorSecondSubmissionStartDate Then 4
    When _CurrDate Between AuthorSecondSubmissionStartDate And AuthorSecondSubmissionDueDate Then 5
    When _CurrDate Between AuthorSecondSubmissionDueDate And SecondReviewStartDate Then 6
    When _CurrDate Between SecondReviewStartDate And SecondReviewDueDate Then 7
    When _CurrDate Between SecondReviewDueDate And AuthorPublicationSubmissionStartDate Then 8
    When _CurrDate Between AuthorPublicationSubmissionStartDate And AuthorPublicationSubmissionDueDate Then 9
    When _CurrDate Between AuthorPublicationSubmissionDueDate And PublicationDate Then 10
    When _CurrDate > PublicationDate Then 1
    End Into _SpotID
  From SystemSettings_ArticleDates
  Where Year = Year(_CurrDate);
  
  Select ID, DefinitionText
  From SystemSettings_DateDefinitions
  Where ID = _SpotID;
END$$

DELIMITER ;