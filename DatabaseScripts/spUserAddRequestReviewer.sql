USE gr_jci;

DELIMITER $$

/* Update the RequestBecomeReviewer for a UserID */
DROP PROCEDURE IF EXISTS `spUserAddRequestReviewer`$$
CREATE PROCEDURE `spUserAddRequestReviewer`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From UserRoles Where UserID = _UserID And RoleID = 2)) Then
	  Select 'UserID is already a reviewer' As 'Error';
	Else
      Update Users
	  Set RequestBecomeReviewer = 1
	  Where UserID = _UserID;
	End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;