USE gr_jci;

DELIMITER $$

/* Updates an existing phone number for a user */
DROP PROCEDURE IF EXISTS `spUpdatePhoneNumber`$$
CREATE PROCEDURE `spUpdatePhoneNumber`(IN _PhoneNumberID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
								       IN _PrimaryPhone tinyint
) DETERMINISTIC
BEGIN

  Declare _UserID int;
  
  /* Make sure the PhoneNumberID exists */
  If(Select Exists(Select 1 From PhoneNumbers Where PhoneNumberID = _PhoneNumberID)) Then
    /* Make sure the PhoneTypeID exists */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
	  /* Default _PrimaryPhone to 0 if null is passed in */
      Set _PrimaryPhone = IFNULL(_PrimaryPhone, 0);
		
		/* Get the UserID for this phone number */
		Select UserID Into _UserID
		From PhoneNumbers
		Where PhoneNumberID = _PhoneNumberID;
	  
	  /* New PrimaryPhone, set others for user to 0 */
	  If (_PrimaryPhone = 1) Then
		Update PhoneNumbers
		Set PrimaryPhone = 0
		Where UserID = _UserID;
	  End If;
	  
      /* Update the phone number record */
	  Update PhoneNumbers
	  Set PhoneTypeID = _PhoneTypeID,
	      PhoneNumber = _PhoneNumber,
		  PrimaryPhone = _PrimaryPhone
	  Where PhoneNumberID = _PhoneNumberID;
	Else
	  Select 'Invalid PhoneTypeID' As 'Error';
	End If;
  Else
    Select 'Phone Number doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;