USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreateAnnouncement`$$
CREATE PROCEDURE `spCreateAnnouncement`(IN _Title varchar(100),
                                        IN _Message varchar(10000),
										IN _ExpireDate date)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a new announcement
   */
  /* Make sure the Title doesn't exist */
  If(Select Exists(Select 1 From Announcements Where Title = _Title)) Then
    Select 'Title already exists' As 'Error';
  Else
    /* Create the announcement record */
    Insert Into Announcements (Title,
	                           Message,
							   CreateDate,
							   ExpireDate)
    Values (_Title,
	        _Message,
			CURRENT_DATE,
			_ExpireDate);

	/* Return the new AnnouncementID */
    Select last_insert_id() As 'AnnouncementID';
  End If;
END$$

DELIMITER ;