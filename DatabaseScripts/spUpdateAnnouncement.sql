USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdateAnnouncement`$$
CREATE PROCEDURE `spUpdateAnnouncement`(IN _AnnouncementID int,
                                        IN _Title varchar(100),
                                        IN _Message varchar(10000),
										IN _ExpireDate date)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing announcement
   */
  /* Make sure the AnnouncementID exists */
  If(Select Exists(Select 1 From Announcements Where AnnouncementID = _AnnouncementID)) Then
    /* Make sure the Title doesn't exists, omitting the current ID */
    If(Select Exists(Select 1 From Announcements Where Title = _Title And AnnouncementID != _AnnouncementID)) Then
      Select 'Title already exists' As 'Error';
    Else
      /* Create the announcement record */
      Update Announcements
      Set Title = _Title,
	      Message = _Message,
		  ExpireDate = _ExpireDate
	  Where AnnouncementID = _AnnouncementID;
    End If;
  Else
    Select 'AnnouncementID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;