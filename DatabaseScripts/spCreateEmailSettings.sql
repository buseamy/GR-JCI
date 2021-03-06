USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreateEmailSettings`$$
CREATE PROCEDURE `spCreateEmailSettings`(IN _SettingName varchar(200),
                                         IN _AuthorNagDays int,
                                         IN _AuthorSubjectTemplate varchar(50),
										 IN _AuthorBodyTemplate varchar(10000),
										 IN _ReviewerNagDays int,
                                         IN _ReviewerSubjectTemplate varchar(50),
										 IN _ReviewerBodyTemplate varchar(10000))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a new Email nagging profile
   */
  Declare _SettingID int;
  
  /* Make sure the SettingName doesn't already exist */
  If(Select Exists(Select 1 From SystemSettings_Email Where SettingName = _SettingName)) Then
    Select 'SettingName already exists' As 'Error';
  Else
    /* Deactivate all other records */
    Update SystemSettings_Email
    Set Active = 0;
    
    /* Create the new record */
    Insert Into SystemSettings_Email (SettingName,
                                      AuthorNagEmailDays,
                                      AuthorSubjectTemplate,
	  								  AuthorBodyTemplate,
	  								  ReviewerNagEmailDays,
	  								  ReviewerSubjectTemplate,
	  								  ReviewerBodyTemplate,
	  								  Active)
    Values (_SettingName,
			_AuthorNagDays,
            _AuthorSubjectTemplate,
	  	    _AuthorBodyTemplate,
	  	    _ReviewerNagDays,
	  	    _ReviewerSubjectTemplate,
	  	    _ReviewerBodyTemplate,
	  	    1);
    
    /* Grab the new SettingID */
    Set _SettingID = last_insert_id();
    
    /* Return the SettingID */
    Select _SettingID As 'SettingID';
  End If;
END$$

DELIMITER ;