USE gr_jci;

DELIMITER $$

/* Connects a UserID with a RoleID */
DROP PROCEDURE IF EXISTS `spUserAddRole`$$
CREATE PROCEDURE `spUserAddRole`(IN _UserID int, IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure RoleID exists */
    If(Select Exists(Select 1 From Roles Where RoleID = _RoleID)) Then
	  /* Make sure UserID and RoleID combination doesn't exist */
      If(Select Exists(Select 1 From UserRoles Where UserID = _UserID And RoleID = _RoleID)) Then
        Select 'User already has that role' As 'Error';
      Else
	    /* Make the connection */
        Insert Into UserRoles (UserID,RoleID)
	    Values (_UserID,_RoleID);
      End If;
	Else
	  Select 'RoleID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;