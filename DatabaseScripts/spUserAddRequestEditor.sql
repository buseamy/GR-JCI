USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUserAddRequestEditor`$$
CREATE PROCEDURE `spUserAddRequestEditor`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the RequestBecomeEditor for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From UserRoles Where UserID = _UserID And RoleID = 3)) Then
	  Select 'UserID is already an editor' As 'Error';
	Else
      Update Users
	  Set RequestBecomeEditor = 1
	  Where UserID = _UserID;
	End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;