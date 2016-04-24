USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreateUser`$$
CREATE PROCEDURE `spCreateUser`(IN _EmailAddress varchar(200),
                                IN _Password varchar(50),
								IN _FirstName varchar(15),
								IN _LastName varchar(30))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new user then returns the UserID
   */
  Declare _UserID int;

  /* Make sure the email address doesn't already exist */
  If(Select Exists(Select 1 From Users Where EmailAddress = _EmailAddress)) Then
    Select -1 As 'UserID', 'Email address already exists' As 'Error';
  Else
    /* Insert the new User record */
    Insert Into Users (EmailAddress,
					   NewEmailAddress,
	                   PasswordHash,
					   FirstName,
					   LastName,
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
			1,
			REPLACE(UUID(),'-',''),
			CURRENT_DATE,
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