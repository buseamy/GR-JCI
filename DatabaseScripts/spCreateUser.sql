USE gr_jci;

DELIMITER $$

/* Inserts a new user then returns the userid */
DROP PROCEDURE IF EXISTS `spCreateUser`$$
CREATE PROCEDURE `spCreateUser`(IN _EmailAddress varchar(200), IN _Password varchar(50), IN _FirstName varchar(15), IN _LastName varchar(30))
DETERMINISTIC
BEGIN
  Declare _UserID int;

  /* Make sure the email address doesn't already exist */
  If(Select Exists(Select 1 From Users Where EmailAddress = _EmailAddress)) Then
    Select 'Email address already exists' As 'Error';
  Else
    /* Insert the new User record */
    Insert Into Users (EmailAddress,PasswordHash,FirstName,LastName,EmailStatusID,EmailVerificationGUID,Active,CreateDate)
    Values (_EmailAddress,SHA1(_Password),_FirstName,_LastName,1,REPLACE(UUID(),'-',''),1,CURRENT_DATE);
    
    /* Get the new UserID */
    Set _UserID = last_insert_id();
    
    /* Set the new user to Role: Author */
    Insert Into UserRoles (UserID, RoleID)
    Values (_UserID,1);
    
    /* Return the new UserID and GUID for password verification */
    Select u.UserID,
           u.EmailVerificationGUID
    From Users u
    Where u.UserID = _UserID;
  End If;  
END$$

DELIMITER ;