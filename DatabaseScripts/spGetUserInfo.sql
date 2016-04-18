USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetUserInfo`$$
CREATE PROCEDURE `spGetUserInfo`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's info
   */
  Select FirstName,
         LastName,
		 EmailAddress,
		 MemberCode,
		 InstitutionAffiliation,
		 IF(ValidMembership, 'Y', 'N') As 'IsValidMember',
		 IF(Active, 'Y', 'N') As 'IsActive'
  From Users
  Where UserID = _UserID;
END$$

DELIMITER ;