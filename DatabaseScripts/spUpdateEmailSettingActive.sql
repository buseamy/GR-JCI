USE gr_jci;

DELIMITER $$

/* Marks an Email SettingID as active */
DROP PROCEDURE IF EXISTS `spUpdateEmailSettingActive`$$
CREATE PROCEDURE `spUpdateEmailSettingActive`(IN _SettingID int)
DETERMINISTIC
BEGIN
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