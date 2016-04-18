USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSearchGetUsersNames`$$
CREATE PROCEDURE `spSearchGetUsersNames`(IN _LastName varchar(30),
                                         IN _FirstName varchar(15))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of users by first and/or last name
   */
  Set _LastName = IfNull(_LastName,'%');
  Set _FirstName = IfNull(_FirstName,'%');
  
  Select UserID,
         CONCAT(LastName,', ',FirstName) As 'FullName',
		 EmailAddress,
		 MemberCode,
		 InstitutionAffiliation
  From Users
  Where LastName Like CONCAT('%',_LastName,'%')
    Or FirstName Like CONCAT('%',_FirstName,'%')
  Group By UserID,
           EmailAddress,
		   MemberCode,
		   InstitutionAffiliation
  Order By LastName, FirstName;
END$$

DELIMITER ;