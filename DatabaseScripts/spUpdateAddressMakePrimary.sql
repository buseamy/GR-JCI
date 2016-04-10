USE gr_jci;

DELIMITER $$

/* Updates an existing address, sets it to be the primary */
DROP PROCEDURE IF EXISTS `spUpdateAddressMakePrimary`$$
CREATE PROCEDURE `spUpdateAddressMakePrimary`(IN _AddressID int)
DETERMINISTIC
BEGIN
  Declare _UserID int;
  
  /* Make sure the AddressID exists */
  If(Select Exists(Select 1 From Addresses Where AddressID = _AddressID)) Then
    /* Get the UserID for this address */
    Select UserID Into _UserID
    From Addresses
    Where AddressID = _AddressID;
    
    /* Set all user's addresses primary to 0 */
    Update Addresses
    Set PrimaryAddress = 0
    Where UserID = _UserID;
    
    /* Updates the address record */
    Update Addresses
    Set PrimaryAddress = 1
    Where AddressID = _AddressID;
  Else
    Select 'Address doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;