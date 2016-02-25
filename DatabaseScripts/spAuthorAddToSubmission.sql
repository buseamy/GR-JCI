USE gr_jci;

DELIMITER $$

/* Adds an Author UserID to an existing Submission */
DROP PROCEDURE IF EXISTS `spAuthorAddToSubmission`$$
CREATE PROCEDURE `spAuthorAddToSubmission`(IN _UserID int,
                                           IN _SubmissionID int)
DETERMINISTIC
BEGIN

  Declare _InstitutionAffiliation varchar(100);
	
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
	  
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
	Else
	  Select 'SubmissionID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;