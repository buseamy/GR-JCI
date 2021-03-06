USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateUserEmailAddress`$$
CREATE PROCEDURE `spUpdateUserEmailAddress`(IN _UserID int,
                                            IN _EmailAddress varchar(200))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the EmailAddress for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set NewEmailAddress = LOWER(_EmailAddress),
	    EmailVerificationGUID = REPLACE(UUID(),'-',''),
		NewEmailAddressCreateDate = CURRENT_DATE,
		EmailStatusID = 1
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;