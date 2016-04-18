USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spJobYearlyAddMembershipHistory`$$
CREATE PROCEDURE `spJobYearlyAddMembershipHistory`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : For every user create membership history record
   */
  /* Delete the current year's entries */
  Delete From UserMembershipHistory
  Where Year = YEAR(CURRENT_DATE);
  
  /* Insert the new records for every user for this year */
  Insert Into UserMembershipHistory (UserID,Year,ValidMembership)
  Select UserID, YEAR(CURRENT_DATE), ValidMembership
  From Users;
END$$

DELIMITER ;