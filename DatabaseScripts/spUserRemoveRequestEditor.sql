USE gr_jci;

DELIMITER $$

/* Update the RequestBecomeEditor for a UserID */
DROP PROCEDURE IF EXISTS `spUserRemoveRequestEditor`$$
CREATE PROCEDURE `spUserRemoveRequestEditor`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set RequestBecomeEditor = 0
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;