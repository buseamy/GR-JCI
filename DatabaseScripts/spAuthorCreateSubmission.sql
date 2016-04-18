USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spAuthorCreateSubmission`$$
CREATE PROCEDURE `spAuthorCreateSubmission`(IN _UserID int,
                                           IN _IncidentTitle varchar(150),
										   IN _Abstract varchar(5000),
										   IN _KeyWords varchar(5000),
										   IN _PreviousSubmissionID int,
										   IN _SubmissionNumber TINYINT)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a new submission record and links the author to it
   */
  Declare _SubmissionID int;
  Declare _InstitutionAffiliation varchar(100);
	
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
  
	/* Create the actual submission record */
    Insert Into Submissions (IncidentTitle,
	                         Abstract,
							 Keywords,
							 SubmissionNumber,
							 PreviousSubmissionID,
							 SubmissionDate,
							 SubmissionStatusID)
	Values (_IncidentTitle,
	        _Abstract,
			_KeyWords,
			_SubmissionNumber,
			_PreviousSubmissionID,
			CURRENT_DATE,
			1);
	
	Set _SubmissionID = last_insert_id();
	
	/* Get the user's InstitutionAffiliation */
	Select InstitutionAffiliation Into _InstitutionAffiliation
	From Users
	Where UserID = _UserID;
	
	/* Link the UserID to the SubmissionID */
	Insert Into AuthorsSubmission (UserID,
	                               SubmissionID,
	                               InstitutionAffiliation,
								   PrimaryContact,
								   AuthorSeniority)
	Values (_UserID,
	        _SubmissionID,
			_InstitutionAffiliation,
			1,
			1);
	
	Select _SubmissionID As 'SubmissionID';
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;