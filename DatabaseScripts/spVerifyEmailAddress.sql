USE gr_jci;

DELIMITER $$

/* Marks a user's email address as valid */
DROP PROCEDURE IF EXISTS `spVerifyEmailAddress`$$
CREATE PROCEDURE `spVerifyEmailAddress`(IN _GUID varchar(32))
DETERMINISTIC
BEGIN
  Declare _UserID int;
  
  /* Get the UserID from the GUID */
  Select UserID Into _UserID
  From Users
  Where EmailVerificationGUID = _GUID;
  
  Set _UserID = IfNull(_UserID, -1);
  
  If (_UserID > -1) Then
    /* Copy the new email address into the EmailAddress field and clear out the changing fields */
    Update Users
    Set EmailAddress = NewEmailAddress,
	    EmailStatusID = 3,
		EmailVerificationGUID = Null,
		NewEmailAddressCreateDate = Null
    Where UserID = _UserID;

	/* Clear out the NewEmailAddress field */
    Update Users
    Set NewEmailAddress = Null
    Where UserID = _UserID;
  End If;
  
  /* Return the UserID */
  Select _UserID As 'UserID';
END$$

DELIMITER ;