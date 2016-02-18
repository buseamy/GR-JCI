USE gr_jci;

DELIMITER $$

/* Updates the user's account to re-enable them */
DROP PROCEDURE IF EXISTS `spEnableUser`$$
CREATE PROCEDURE `spEnableUser`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set Active = 1, NonActiveNote = Null
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If; 
END$$

DELIMITER ;