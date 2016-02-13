USE gr_jci;

DELIMITER $$

/* Get the UserID (or -1) for the EmailAddress/Password combination */
DROP PROCEDURE IF EXISTS `spGetUserID`$$
CREATE PROCEDURE `spGetUserID`(IN _EmailAddress VarChar(200), IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  Declare _UserID Int;

  Select u.UserID Into _UserID
  From Users u
  Where u.EmailAddress = _EmailAddress
    And u.PasswordHash = SHA1(_Password) 
    And u.Active = 1;
	
  Select IfNull(_UserID, -1) As 'UserID';
END$$

DELIMITER ;
