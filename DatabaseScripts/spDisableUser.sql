USE gr_jci;

DELIMITER $$

/* Updates the user's account to mark them as disabled */
DROP PROCEDURE IF EXISTS `spDisableUser`$$
CREATE PROCEDURE `spDisableUser`(IN _UserID int, IN _NonActiveNote varchar(5000))
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set Active = 0, NonActiveNote = _NonActiveNote
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If; 
END$$

DELIMITER ;