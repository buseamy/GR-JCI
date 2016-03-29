USE gr_jci;

DELIMITER $$

/* Adds an Author UserID to an existing Submission */
DROP PROCEDURE IF EXISTS `spAuthorAddToSubmission`$$
CREATE PROCEDURE `spAuthorAddToSubmission`(IN _UserID int,
                                           IN _SubmissionID int,
										   IN _PrimaryContact tinyint)
DETERMINISTIC
BEGIN
  Declare _InstitutionAffiliation varchar(150);
  Declare _AuthorSeniority int;
	
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
	  
	  Set _PrimaryContact = IfNull(_PrimaryContact, 0);
	  
	  /* Get the user's InstitutionAffiliation */
	  Select InstitutionAffiliation Into _InstitutionAffiliation
	  From Users
	  Where UserID = _UserID;
	  
	  /* Get the highest author senority for the submission */
	  Select Max(AuthorSeniority) + 1 Into _AuthorSeniority
	  From AuthorsSubmission
	  Where SubmissionID = _SubmissionID;
	  
	  If (_PrimaryContact = 1) Then
	    Update AuthorsSubmission
		Set PrimaryContact = 0
		Where SubmissionID = _SubmissionID;
	  End If;
	  
	  /* Link the UserID to the SubmissionID */
	  Insert Into AuthorsSubmission (UserID,
	                                 SubmissionID,
	                                 InstitutionAffiliation,
	  							     PrimaryContact,
	  							     AuthorSeniority)
	  Values (_UserID,
	          _SubmissionID,
	  		  _InstitutionAffiliation,
	  		  _PrimaryContact,
	  		  _AuthorSeniority);
	Else
	  Select 'SubmissionID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;