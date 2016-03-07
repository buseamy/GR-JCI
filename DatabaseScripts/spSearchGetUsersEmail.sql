USE gr_jci;

DELIMITER $$

/* Gets the List of users by email address */
DROP PROCEDURE IF EXISTS `spSearchGetUsersEmail`$$
CREATE PROCEDURE `spSearchGetUsersEmail`(IN _EmailAddress varchar(30))
DETERMINISTIC
BEGIN
  Set _EmailAddress = IfNull(_EmailAddress,'%');
  
  Select UserID,
         CONCAT(LastName,', ',FirstName) As 'FullName',
		 EmailAddress,
		 MemberCode,
		 InstitutionAffiliation
  From Users
  Where EmailAddress Like CONCAT('%',_EmailAddress,'%')
  Group By UserID,
           EmailAddress,
		   MemberCode,
		   InstitutionAffiliation
  Order By LastName, FirstName;
END$$

DELIMITER ;