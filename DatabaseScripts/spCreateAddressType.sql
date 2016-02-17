USE gr_jci;

DELIMITER $$

/* Inserts a new phone number type */
DROP PROCEDURE IF EXISTS `spCreateAddressType`$$
CREATE PROCEDURE `spCreateAddressType`(IN _AddressType varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the Phone Type doesn't exist */
  If(Select Exists(Select 1 From AddressTypes Where AddressType = _AddressType)) Then
    Select 'Address type already exists' As 'Error';
  Else
    Insert Into AddressTypes(AddressType)
	Values (_AddressType);
	
	Select last_insert_id() As 'AddressTypeID';
  End If; 
END$$

DELIMITER ;