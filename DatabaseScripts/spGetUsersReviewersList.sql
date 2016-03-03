USE gr_jci;

DELIMITER $$

/* Gets the list of active UserID and FullNames who are Reviewers */
DROP PROCEDURE IF EXISTS `spGetUsersReviewersList`$$
CREATE PROCEDURE `spGetUsersReviewersList`()
DETERMINISTIC
BEGIN
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
  Where ur.RoleID = 2
    And u.Active = 1
	And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

DELIMITER ;