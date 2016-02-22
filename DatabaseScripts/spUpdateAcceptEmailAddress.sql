USE gr_jci;

DELIMITER $$

/* Marks a user's email address as valid */
DROP PROCEDURE IF EXISTS `spUpdateAcceptEmailAddress`$$
CREATE PROCEDURE `spUpdateAcceptEmailAddress`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Copy the new email address into the EmailAddress field */
  Update Users
  Set EmailAddress = NewEmailAddress
  Where UserID = _UserID;
  
  /* Mark the record's email address as valid */
  Update Users
  Set EmailStatusID = 3,
      NewEmailAddress = Null,
	  EmailVerificationGUID = Null,
	  NewEmailAddressCreateDate = Null
  Where UserID = _UserID;
END$$

DELIMITER ;