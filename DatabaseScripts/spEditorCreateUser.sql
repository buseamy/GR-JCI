USE gr_jci;

DELIMITER $$

/* Inserts a new user then returns the UserID */
DROP PROCEDURE IF EXISTS `spEditorCreateUser`$$
CREATE PROCEDURE `spEditorCreateUser`(IN _EmailAddress varchar(200),
                                IN _Password varchar(50),
								IN _FirstName varchar(15),
								IN _LastName varchar(30),
								IN _InstitutionAffiliation varchar(100),
								IN _MemberCode varchar(20))
DETERMINISTIC
BEGIN
  Declare _UserID int;

  /* Make sure the email address doesn't already exist */
  If(Select Exists(Select 1 From Users Where EmailAddress = _EmailAddress)) Then
    Select 'Email address already exists' As 'Error';
  Else
    /* Insert the new User record */
    Insert Into Users (EmailAddress,
					   NewEmailAddress,
	                   PasswordHash,
					   FirstName,
					   LastName,
					   InstitutionAffiliation,
					   MemberCode,
					   EmailStatusID,
					   EmailVerificationGUID,
					   NewEmailAddressCreateDate,
					   Active,
					   CreateDate)
    Values (LOWER(_EmailAddress),
			LOWER(_EmailAddress),
	        SHA1(_Password),
			_FirstName,
			_LastName,
			_InstitutionAffiliation,
			_MemberCode,
			3,
			NULL,
			NULL,
			1,
			CURRENT_DATE);
    
    /* Get the new UserID */
    Set _UserID = last_insert_id();
    
    /* Set the new user to Role: Author */
    Insert Into UserRoles (UserID,RoleID)
    Values (_UserID,1);
    
    /* Return the new UserID and GUID for password verification */
    Select u.UserID
    From Users u
    Where u.UserID = _UserID;
  End If;  
END$$

DELIMITER ;