USE gr_jci;

DELIMITER $$

/* Gets the list of types of addresses */
DROP PROCEDURE IF EXISTS `spGetAddressTypes`$$
CREATE PROCEDURE `spGetAddressTypes`()
DETERMINISTIC
BEGIN
  Select AddressTypeID, AddressType
  From AddressTypes
  Order By AddressType;
END$$

/* Gets the list of types of phone numbers */
DROP PROCEDURE IF EXISTS `spGetPhoneTypes`$$
CREATE PROCEDURE `spGetPhoneTypes`()
DETERMINISTIC
BEGIN
  Select PhoneTypeID, PhoneType
  From PhoneTypes
  Order By PhoneType;
END$$

/* Gets the list of states */
DROP PROCEDURE IF EXISTS `spGetStates`$$
CREATE PROCEDURE `spGetStates`()
DETERMINISTIC
BEGIN
  Select StateID, CONCAT(Abbr,' - ',Name) As FullStateName
  From States
  Order By Abbr;
END$$

/* Get the UserID (or -1) for the EmailAddress/Password combination */
DROP PROCEDURE IF EXISTS `spGetUserID`$$
CREATE PROCEDURE `spGetUserID`(IN _EmailAddress VarChar(200), IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  Declare _UserID Int;

  Select u.UserID Into _UserID
  From Users u
  Where u.EmailAddress = _EmailAddress
    And u.PasswordHash = SHA1(_Password);
	
  Select IfNull(_UserID, -1) As 'UserID';
END$$

/* Gets the roles associated with a UserID */
DROP PROCEDURE IF EXISTS `spGetUserRoles`$$
CREATE PROCEDURE `spGetUserRoles`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select r.RoleTitle
  From UserRoles ur
    Inner Join Roles r
      On r.RoleID = ur.RoleID
  Where ur.UserID = _UserID;
END$$

/* Get the UserID (or -1) for the EmailAddress/Password combination */
DROP PROCEDURE IF EXISTS `spLoginGetUserID`$$
CREATE PROCEDURE `spLoginGetUserID`(IN _EmailAddress VarChar(200), IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  Declare _UserID Int;

  Select u.UserID Into _UserID
  From Users u
  Where u.EmailAddress = _EmailAddress
    And u.PasswordHash = SHA1(_Password)
	And u.Active = 1
	And u.EmailStatusID = 3;
	
  Select IfNull(_UserID, -1) As 'UserID';
END$$

/* Get the list of users, both active and inactive in alphbetical order */
DROP PROCEDURE IF EXISTS `spGetUsersList`$$
CREATE PROCEDURE `spGetUsersList`()
DETERMINISTIC
BEGIN
  Select u.UserID,
         u.EmailAddress,
		 CONCAT(u.FirstName,' ',u.LastName) As 'Name',
		 GROUP_CONCAT(r.RoleTitle) As 'Roles',
		 IF(u.Active, 'Y', 'N') As 'IsActive'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
	Inner Join Roles r
	  On r.RoleID = ur.RoleID
  Order By u.LastName,
           u.FirstName,
		   u.UserID;
END$$

/* Inserts a new user then returns the userid */
DROP PROCEDURE IF EXISTS `spCreateUser`$$
CREATE PROCEDURE `spCreateUser`(IN _EmailAddress varchar(200), IN _Password varchar(50), IN _FirstName varchar(15), IN _LastName varchar(30))
DETERMINISTIC
BEGIN
  Declare _UserID int;

  /* Make sure the email address doesn't already exist */
  If(Select Exists(Select 1 From Users Where EmailAddress = _EmailAddress)) Then
    Select 'Email address already exists' As 'Error';
  Else
    /* Insert the new User record */
    Insert Into Users (EmailAddress,PasswordHash,FirstName,LastName,EmailStatusID,EmailVerificationGUID,Active,CreateDate)
    Values (_EmailAddress,SHA1(_Password),_FirstName,_LastName,1,REPLACE(UUID(),'-',''),1,CURRENT_DATE);
    
    /* Get the new UserID */
    Set _UserID = last_insert_id();
    
    /* Set the new user to Role: Author */
    Insert Into UserRoles (UserID, RoleID)
    Values (_UserID,1);
    
    /* Return the new UserID and GUID for password verification */
    Select u.UserID,
           u.EmailVerificationGUID
    From Users u
    Where u.UserID = _UserID;
  End If;
END$$

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

/* Inserts a new address for a user */
DROP PROCEDURE IF EXISTS `spCreatePhoneNumber`$$
CREATE PROCEDURE `spCreatePhoneNumber`(IN _UserID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
								       IN _PrimaryPhone tinyint
) DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the PhoneTypeID exists */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
	  /* Default _PrimaryPhone to 0 if null is passed in */
      Set _PrimaryPhone = IFNULL(_PrimaryPhone, 0);
	  
      /* Insert the new address record */
      Insert Into PhoneNumbers (UserID,PhoneTypeID,PhoneNumber,PrimaryPhone,CreateDate)
      Values (_UserID,_PhoneTypeID,_PhoneNumber,_PrimaryPhone,CURRENT_DATE);
        
      /* Get the new AddressID */
      Select last_insert_id() As 'PhoneNumberID';
	Else
	  Select 'Invalid PhoneTypeID' As 'Error';
	End If;
  Else
    Select 'User doesn''t exist' As 'Error';
  End If; 
END$$

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