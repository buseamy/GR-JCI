USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdatePhoneType`$$
CREATE PROCEDURE `spUpdatePhoneType`(IN _PhoneTypeID int,
                                     IN _PhoneType varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing phone type
   */
  /* Make sure the PhoneTypeID exists */
  If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
    /* Make sure the new PhoneType doesn't already exist */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneType = _PhoneType)) Then
	  Select 'PhoneType already exists' As 'Error';
	Else
      /* Update the phone number record */
	  Update PhoneTypes
	  Set PhoneType = _PhoneType
	  Where PhoneTypeID = _PhoneTypeID;
	End If;
  Else
    Select 'PhoneTypeID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;