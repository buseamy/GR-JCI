USE gr_jci;

DELIMITER $$

/* Inserts a new address for a user */
DROP PROCEDURE IF EXISTS `spCreateAddress`$$
CREATE PROCEDURE `spCreateAddress`(IN _UserID int,
                                   IN _AddressTypeID int,
                                   IN _AddressLn1 varchar(100),
								   IN _AddressLn2 varchar(100),
								   IN _City varchar(30),
								   IN _StateID int,
								   IN _PostCode char(5),
								   IN _PrimaryAddress tinyint
) DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the AddressTypeID exists */
    If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
	  /* Make sure the StateID exists */
	  If(Select Exists(Select 1 From States Where StateID = _StateID)) Then
	    /* Default _PrimaryAddress to 0 if null is passed in */
        Set _PrimaryAddress = IFNULL(_PrimaryAddress, 0);
	    
        /* Insert the new address record */
        Insert Into Addresses (UserID,AddressTypeID,AddressLn1,AddressLn2,City,StateID,PostCode,PrimaryAddress,CreateDate)
        Values (_UserID,_AddressTypeID,_AddressLn1,_AddressLn2,_City,_StateID,_PostCode,_PrimaryAddress,CURRENT_DATE);
          
        /* Get the new AddressID */
        Select last_insert_id() As 'AddressID';
	  Else
	    Select 'Invalid StateID' As 'Error';
	  End If;
	Else
	  Select 'Invalid AddressTypeID' As 'Error';
	End If;
  Else
    Select 'User doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;