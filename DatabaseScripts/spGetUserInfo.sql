USE gr_jci;

DELIMITER $$

/* Gets the user's info */
DROP PROCEDURE IF EXISTS `spGetUserInfo`$$
CREATE PROCEDURE `spGetUserInfo`(IN _UserID int)
DETERMINISTIC
BEGIN
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