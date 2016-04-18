USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateUserInfo`$$
CREATE PROCEDURE `spUpdateUserInfo`(IN _UserID int,
                                    IN _FirstName varchar(15),
									IN _LastName varchar(30),
									IN _MemberCode varchar(20),
									IN _InstitutionAffiliation varchar(100))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates the info for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set FirstName = _FirstName,
	    LastName = _LastName,
		MemberCode = _MemberCode,
		InstitutionAffiliation = _InstitutionAffiliation
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;