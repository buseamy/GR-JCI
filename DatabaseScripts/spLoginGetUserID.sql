USE gr_jci;

DELIMITER $$

/* Get the UserID (or -1 if invalid) for the EmailAddress/Password combination */
DROP PROCEDURE IF EXISTS `spLoginGetUserID`$$
CREATE PROCEDURE `spLoginGetUserID`(IN _EmailAddress VarChar(200), IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  Declare _UserID Int;
  Declare _EmailStatusID Int;
  Declare _Active TinyInt;

  Select u.UserID,
         u.EmailStatusID,
		 u.Active
  Into _UserID,
       _EmailStatusID,
	   _Active
  From Users u
  Where u.EmailAddress = LOWER(_EmailAddress)
    And u.PasswordHash = SHA1(_Password);

  Set _UserID = IfNull(_UserID, -1);
  Set _EmailStatusID = IfNull(_EmailStatusID, -1);
  Set _Active = IfNull(_Active, -1);
  
  /* Check if a new email address reset needs to occure */	
  If (_EmailStatusID = 2 && _Active = 1) Then
    /* Reset the GUID info */
    Update Users
	Set NewEmailAddress = LOWER(_EmailAddress),
	    EmailVerificationGUID = REPLACE(UUID(),'-',''),
		NewEmailAddressCreateDate = CURRENT_DATE,
		EmailStatusID = 1
	Where UserID = _UserID;
  End If;
  
  /* Return the info */
  Select _UserID As 'UserID',
         _EmailStatusID As 'EmailStatusID',
		 _Active As 'Active';
END$$

DELIMITER ;