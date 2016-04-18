USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spAnnouncementAddRole`$$
CREATE PROCEDURE `spAnnouncementAddRole`(IN _AnnouncementID int,
                                         IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Connects an AnnouncementID with a RoleID
   */
  /* Make sure AnnouncementID exists */
  If(Select Exists(Select 1 From Announcements Where AnnouncementID = _AnnouncementID)) Then
    /* Make sure RoleID exists */
    If(Select Exists(Select 1 From Roles Where RoleID = _RoleID)) Then
	  /* Make sure AnnouncementID and RoleID combination doesn't exist */
      If(Select Exists(Select 1 From AccouncementRoles Where AnnouncementID = _AnnouncementID And RoleID = _RoleID)) Then
        Select 'User already has that role' As 'Error';
      Else
	    /* Make the connection */
        Insert Into AccouncementRoles (AnnouncementID,RoleID)
	    Values (_AnnouncementID,_RoleID);
      End If;
	Else
	  Select 'RoleID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'AnnouncementID doesn''t exist' As 'Error';
  End If;
END$$

DELIMITER ;