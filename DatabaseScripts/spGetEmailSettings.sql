USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetEmailSettings`$$
CREATE PROCEDURE `spGetEmailSettings`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Email Settings
   */
  Select SettingID,
         SettingName,
         AuthorNagEmailDays,
         AuthorSubjectTemplate,
         AuthorBodyTemplate,
         ReviewerNagEmailDays,
         ReviewerSubjectTemplate,
         ReviewerBodyTemplate,
         Active
  From SystemSettings_Email
  Order By SettingName;
END$$

DELIMITER ;