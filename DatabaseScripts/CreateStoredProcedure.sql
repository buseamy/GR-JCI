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

DELIMITER ;