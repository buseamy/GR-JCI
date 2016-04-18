USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateAddress`$$
CREATE PROCEDURE `spUpdateAddress`(IN _AddressID int,
                                   IN _AddressTypeID int,
                                   IN _AddressLn1 varchar(100),
								   IN _AddressLn2 varchar(100),
								   IN _City varchar(30),
								   IN _StateID int,
								   IN _PostCode char(5),
								   IN _PrimaryAddress tinyint)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing address
   */

  Declare _UserID int;
  
  /* Make sure the AddressID exists */
  If(Select Exists(Select 1 From Addresses Where AddressID = _AddressID)) Then
    /* Make sure the AddressTypeID exists */
    If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
	  /* Make sure the StateID exists */
	  If(Select Exists(Select 1 From States Where StateID = _StateID)) Then
	    /* Default _PrimaryAddress to 0 if null is passed in */
        Set _PrimaryAddress = IFNULL(_PrimaryAddress, 0);
		
		/* Get the UserID for this address */
		Select UserID Into _UserID
		From Addresses
		Where AddressID = _AddressID;
		
	    /* New PrimaryAddress, set others for user to 0 */
	    If (_PrimaryAddress = 1) Then
		  Update Addresses
		  Set PrimaryAddress = 0
		  Where UserID = _UserID;
		End If;
		
        /* Updates the address record */
		Update Addresses
		Set AddressTypeID = _AddressTypeID,
		    AddressLn1 = _AddressLn1,
			AddressLn2 = _AddressLn2,
			City = _City,
			StateID = _StateID,
			PostCode = _PostCode,
			PrimaryAddress = _PrimaryAddress
		Where AddressID = _AddressID;
	  Else
	    Select 'Invalid StateID' As 'Error';
	  End If;
	Else
	  Select 'Invalid AddressTypeID' As 'Error';
	End If;
  Else
    Select 'Address doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;