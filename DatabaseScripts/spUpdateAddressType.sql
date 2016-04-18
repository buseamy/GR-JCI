USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateAddressType`$$
CREATE PROCEDURE `spUpdateAddressType`(IN _AddressTypeID int,
                                       IN _AddressType varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing address type
   */
  /* Make sure the AddressTypeID exists */
  If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
    /* Make sure the new PhoneType doesn't already exist */
    If(Select Exists(Select 1 From AddressTypes Where AddressType = _AddressType)) Then
	  Select 'AddressType already exists' As 'Error';
	Else
      /* Update the Address Type record */
	  Update AddressTypes
	  Set AddressType = _AddressType
	  Where AddressTypeID = _AddressTypeID;
	End If;
  Else
    Select 'AddressTypeID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;