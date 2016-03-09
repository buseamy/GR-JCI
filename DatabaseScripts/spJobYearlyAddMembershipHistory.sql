USE gr_jci;

DELIMITER $$

/* For every user create membership history record */
DROP PROCEDURE IF EXISTS `spJobYearlyAddMembershipHistory`$$
CREATE PROCEDURE `spJobYearlyAddMembershipHistory`()
DETERMINISTIC
BEGIN
  /* Delete the current year's entries */
  Delete From UserMembershipHistory
  Where Year = YEAR(CURRENT_DATE);
  
  /* Insert the new records for every user for this year */
  Insert Into UserMembershipHistory (UserID,Year,ValidMembership)
  Select UserID, YEAR(CURRENT_DATE), ValidMembership
  From Users;
END$$

DELIMITER ;