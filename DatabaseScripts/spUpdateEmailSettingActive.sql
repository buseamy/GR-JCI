USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateEmailSettingActive`$$
CREATE PROCEDURE `spUpdateEmailSettingActive`(IN _SettingID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Marks an Email SettingID as active
   */
  /* Make sure the SettingID exists */
  If(Select Exists(Select 1 From SystemSettings_Email Where SettingID = _SettingID)) Then
    /* Mark all settings as inactive */
	Update SystemSettings_Email
	Set Active = 0;
	
	/* Mark the specific ID as active */
	Update SystemSettings_Email
	Set Active = 0
	Where SettingID = _SettingID;
  Else
    Select 'SettingID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;