USE gr_jci;

DELIMITER $$

/* Gets the list of types of files for a role */
DROP PROCEDURE IF EXISTS `spGetFileTypes`$$
CREATE PROCEDURE `spGetFileTypes`(IN _RoleID int)
DETERMINISTIC
BEGIN
  Select FileTypeID, FileType
  From FileTypes
  Where RoleID = _RoleID
  Order By FileType;
END$$

DELIMITER ;