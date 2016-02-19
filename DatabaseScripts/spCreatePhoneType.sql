USE gr_jci;

DELIMITER $$

/* Inserts a new phone number type */
DROP PROCEDURE IF EXISTS `spCreatePhoneType`$$
CREATE PROCEDURE `spCreatePhoneType`(IN _PhoneType varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the Phone Type doesn't exist */
  If(Select Exists(Select 1 From PhoneTypes Where PhoneType = _PhoneType)) Then
    Select 'Phone type already exists' As 'Error';
  Else
    Insert Into PhoneTypes(PhoneType)
	Values (_PhoneType);
	
	Select last_insert_id() As 'PhoneTypeID';
  End If; 
END$$

DELIMITER ;