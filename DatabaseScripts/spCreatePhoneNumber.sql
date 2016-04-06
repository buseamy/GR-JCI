USE gr_jci;

DELIMITER $$

/* Inserts a new phone number for a user */
DROP PROCEDURE IF EXISTS `spCreatePhoneNumber`$$
CREATE PROCEDURE `spCreatePhoneNumber`(IN _UserID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
								       IN _PrimaryPhone tinyint
) DETERMINISTIC
BEGIN
  Declare _PhoneCount int;
  
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the PhoneTypeID exists */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
	  /* Default _PrimaryPhone to 0 if null is passed in */
      Set _PrimaryPhone = IFNULL(_PrimaryPhone, 0);
      
      /* Get the count of PhoneNumbers for the user */
      Select Count(PhoneNumberID) Into _PhoneCount
      From PhoneNumbers
      Where UserID = _UserID;
	  
	  /* New PrimaryPhone, set others for user to 0 */
	  If (_PrimaryPhone = 1) Then
		Update PhoneNumbers
		Set PrimaryPhone = 0
		Where UserID = _UserID;
	  End If;
      
      /* If this is the first number, make it the PrimaryPhone */
      If (_PhoneCount = 0) Then
        Set _PrimaryPhone = 1;
      End If;
	  
      /* Insert the new phone number record */
      Insert Into PhoneNumbers (UserID,PhoneTypeID,PhoneNumber,PrimaryPhone,CreateDate)
      Values (_UserID,_PhoneTypeID,_PhoneNumber,_PrimaryPhone,CURRENT_DATE);
        
      /* Get the new PhoneNumberID */
      Select last_insert_id() As 'PhoneNumberID';
	Else
	  Select 'Invalid PhoneTypeID' As 'Error';
	End If;
  Else
    Select 'User doesn''t exist' As 'Error';
  End If; 
END$$

DELIMITER ;