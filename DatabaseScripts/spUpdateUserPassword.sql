USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateUserPassword`$$
CREATE PROCEDURE `spUpdateUserPassword`(IN _UserID int,
                                        IN _Password varchar(50))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the password for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set PasswordHash = SHA1(_Password)
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;