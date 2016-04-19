USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetEmailSettingsActive`$$
CREATE PROCEDURE `spGetEmailSettingsActive`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the active Email Settings record
   */
  Select SettingID,
         SettingName,
         AuthorNagEmailDays,
         AuthorSubjectTemplate,
         AuthorBodyTemplate,
         ReviewerNagEmailDays,
         ReviewerSubjectTemplate,
         ReviewerBodyTemplate
  From SystemSettings_Email
  Where Active = 1
  Limit 0,1;
END$$

DELIMITER ;