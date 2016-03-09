USE gr_jci;

DELIMITER $$

/* Gets the List of available Email Settings */
DROP PROCEDURE IF EXISTS `spGetEmailSettings`$$
CREATE PROCEDURE `spGetEmailSettings`()
DETERMINISTIC
BEGIN
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