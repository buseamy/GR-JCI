USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUserRemoveRole`$$
CREATE PROCEDURE `spUserRemoveRole`(IN _UserID int,
                                    IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a UserID with a RoleID
   */
  Delete From UserRoles
  Where UserID = _UserID
    And RoleID = _RoleID;
END$$

DELIMITER ;