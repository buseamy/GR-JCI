USE gr_jci;

DELIMITER $$

/* Updates an existing phone number, sets it to be the primary */
DROP PROCEDURE IF EXISTS `spUpdatePhoneMakePrimary`$$
CREATE PROCEDURE `spUpdatePhoneMakePrimary`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  Declare _UserID int;
  
  /* Make sure the PhoneNumberID exists */
  If(Select Exists(Select 1 From PhoneNumbers Where PhoneNumberID = _PhoneNumberID)) Then
    /* Get the UserID for this phone */
    Select UserID Into _UserID
    From PhoneNumbers
    Where PhoneNumberID = _PhoneNumberID;
    
    /* Set all user's phones primary to 0 */
    Update PhoneNumbers
    Set PrimaryPhone = 0
    Where UserID = _UserID;
    
    /* Updates the phone record */
    Update PhoneNumbers
    Set PrimaryPhone = 1
    Where PhoneNumberID = _PhoneNumberID;
  Else
    Select 'Phone number doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;