USE gr_jci;

DELIMITER $$

/* Updates an existing Email nagging profile */
DROP PROCEDURE IF EXISTS `spUpdateEmailSettings`$$
CREATE PROCEDURE `spUpdateEmailSettings`(IN _SettingID int,
                                         IN _SettingName varchar(200),
                                         IN _AuthorNagDays int,
                                         IN _AuthorSubjectTemplate varchar(50),
                                         IN _AuthorBodyTemplate varchar(1000),
                                         IN _ReviewerNagDays int,
                                         IN _ReviewerSubjectTemplate varchar(50),
                                         IN _ReviewerBodyTemplate varchar(1000))
DETERMINISTIC
BEGIN
  /* Make sure the SettingID exists */
  If(Select Exists(Select 1 From SystemSettings_Email Where SettingID = _SettingID)) Then
    /* Make sure the SettingName doesn't already exist */
    If(Select Exists(Select 1 From SystemSettings_Email Where SettingName = _SettingName And SettingID != _SettingID)) Then
	  Select 'SettingName already exists' As 'Error';
    Else
      /* Deactivate all other records */
      Update SystemSettings_Email
      Set Active = 0;
      
      /* Update the record */
	  Update SystemSettings_Email
	  Set SettingName = _SettingName,
	      AuthorNagEmailDays = _AuthorNagDays,
		  AuthorSubjectTemplate = _AuthorSubjectTemplate,
		  AuthorBodyTemplate = _AuthorBodyTemplate,
		  ReviewerNagEmailDays = _ReviewerNagDays,
		  ReviewerSubjectTemplate = _ReviewerSubjectTemplate,
		  ReviewerBodyTemplate = _ReviewerBodyTemplate,
		  Active = 1;
    End If;
  Else
    Select 'SettingName doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;