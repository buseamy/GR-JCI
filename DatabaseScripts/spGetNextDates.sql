USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetNextDates`$$
CREATE PROCEDURE `spGetNextDates`(IN _Number int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets next important dates
   */
  /* Store the current date */
  Declare _CurrDate date;
  Declare _AuthorFirstSubmissionStartDate date;
  Declare _AuthorFirstSubmissionDueDate date;
  Declare _FirstReviewStartDate date;
  Declare _FirstReviewDueDate date;
  Declare _AuthorSecondSubmissionStartDate date;
  Declare _AuthorSecondSubmissionDueDate date;
  Declare _SecondReviewStartDate date;
  Declare _SecondReviewDueDate date;
  Declare _AuthorPublicationSubmissionStartDate date;
  Declare _AuthorPublicationSubmissionDueDate date;
  Declare _PublicationDate date;
  
  Set _Number = IfNull(_Number, 3);
  If (_Number < 2) Then
    Set _Number = 2;
  End If;
  
  Set _CurrDate = CURRENT_DATE;
  
  /* Drop the temporary table */
  Drop Table If Exists TempEditorDates;
  
  /* Create the temporary table */
  Create Table TempEditorDates (
    Dte date NOT NULL,
    Description varchar(100) NOT NULL,
    PRIMARY KEY (Dte)
  );
  
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
  Into _AuthorFirstSubmissionStartDate,
       _AuthorFirstSubmissionDueDate,
       _FirstReviewStartDate,
       _FirstReviewDueDate,
       _AuthorSecondSubmissionStartDate,
       _AuthorSecondSubmissionDueDate,
       _SecondReviewStartDate,
       _SecondReviewDueDate,
       _AuthorPublicationSubmissionStartDate,
       _AuthorPublicationSubmissionDueDate,
       _PublicationDate
  From SystemSettings_ArticleDates
  Where Year = Year(_CurrDate);
  
  If (_CurrDate < _AuthorFirstSubmissionStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorFirstSubmissionStartDate, 'First incident article submissions begin');
  End If;
  
  If (_CurrDate < _AuthorFirstSubmissionDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorFirstSubmissionDueDate, 'First incident article submissions are due');
  End If;
  
  If (_CurrDate < _FirstReviewStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_FirstReviewStartDate, 'First submission articles are sent to the reviewers');
  End If;
  
  If (_CurrDate < _FirstReviewDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_FirstReviewDueDate, 'First submission articles reviews completed');
  End If;
  
  If (_CurrDate < _AuthorSecondSubmissionStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorSecondSubmissionStartDate, 'Second incident article submissions begin');
  End If;
  
  If (_CurrDate < _AuthorSecondSubmissionDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorSecondSubmissionDueDate, 'Second incident article submissions are due');
  End If;
  
  If (_CurrDate < _SecondReviewStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_SecondReviewStartDate, 'Second submission articles are sent to the reviewers');
  End If;
  
  If (_CurrDate < _SecondReviewDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_SecondReviewDueDate, 'Second submission articles reviews completed');
  End If;
  
  If (_CurrDate < _AuthorPublicationSubmissionStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorPublicationSubmissionStartDate, 'Incident publication article submissions begin');
  End If;
  
  If (_CurrDate < _AuthorPublicationSubmissionDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorPublicationSubmissionDueDate, 'Incident publication article submissions are due');
  End If;
  
  If (_CurrDate < _PublicationDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_PublicationDate, 'Publication of the Journal of Critical Incidents');
  End If;
  
  If (_Number = 2) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 2;
  ElseIf (_Number = 3) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 3;
  ElseIf (_Number = 4) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 4;
  ElseIf (_Number = 5) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 5;
  ElseIf (_Number = 6) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 6;
  ElseIf (_Number = 7) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 7;
  ElseIf (_Number = 8) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 8;
  ElseIf (_Number = 9) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 9;
  ElseIf (_Number = 10) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 10;
  Else
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By Dte;
  End If;
  
  /* Drop the temporary table */
  Drop Table If Exists TempEditorDates;
END$$

DELIMITER ;