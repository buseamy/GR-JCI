USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetFileTypes`$$
CREATE PROCEDURE `spGetFileTypes`(IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of files for a role
   */
  Select FileTypeID, FileType
  From FileTypes
  Where RoleID = _RoleID
  Order By FileType;
END$$

DELIMITER ;