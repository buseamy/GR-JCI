USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spRemoveExpiredAnnouncements`$$
DROP PROCEDURE IF EXISTS `spUpdateAcceptEmailAddress`$$
DROP PROCEDURE IF EXISTS `spUpdateExpireUsersEmailAddressChange`$$
DROP PROCEDURE IF EXISTS `spUpdateRejectEmailAddress`$$
DROP PROCEDURE IF EXISTS `spUpdateSubmissionAssignEditor`$$
DROP PROCEDURE IF EXISTS `spYearlyAddMembershipHistory`$$
DROP PROCEDURE IF EXISTS `spGetAllAnnouncements`$$

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

DROP PROCEDURE IF EXISTS `spAnnouncementRemoveRole`$$
CREATE PROCEDURE `spAnnouncementRemoveRole`(IN _AnnouncementID int,
                                            IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes an AnnouncementID with a RoleID
   */
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID
    And RoleID = _RoleID;
END$$

DROP PROCEDURE IF EXISTS `spAuthorAddToSubmission`$$
CREATE PROCEDURE `spAuthorAddToSubmission`(IN _UserID int,
                                           IN _SubmissionID int,
                                           IN _PrimaryContact tinyint)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Adds an Author UserID to an existing Submission
   */
  Declare _InstitutionAffiliation varchar(150);
  Declare _AuthorSeniority int;
    
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
      
      Set _PrimaryContact = IfNull(_PrimaryContact, 0);
      
      /* Get the user's InstitutionAffiliation */
      Select InstitutionAffiliation Into _InstitutionAffiliation
      From Users
      Where UserID = _UserID;
      
      /* Get the highest author senority for the submission */
      Select Max(AuthorSeniority) + 1 Into _AuthorSeniority
      From AuthorsSubmission
      Where SubmissionID = _SubmissionID;
      
      If (_PrimaryContact = 1) Then
        Update AuthorsSubmission
        Set PrimaryContact = 0
        Where SubmissionID = _SubmissionID;
      End If;
      
      /* Link the UserID to the SubmissionID */
      Insert Into AuthorsSubmission (UserID,
                                     SubmissionID,
                                     InstitutionAffiliation,
                                       PrimaryContact,
                                       AuthorSeniority)
      Values (_UserID,
              _SubmissionID,
                _InstitutionAffiliation,
                _PrimaryContact,
                _AuthorSeniority);
    Else
      Select 'SubmissionID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spAuthorCreateSubmission`$$
CREATE PROCEDURE `spAuthorCreateSubmission`(IN _UserID int,
                                            IN _IncidentTitle varchar(150),
                                            IN _Abstract varchar(5000),
                                            IN _KeyWords varchar(5000),
                                            IN _PreviousSubmissionID int,
                                            IN _SubmissionNumber TINYINT)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a new submission record and links the author to it
   */
  Declare _SubmissionID int;
  Declare _InstitutionAffiliation varchar(100);
    
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
  
    /* Create the actual submission record */
    Insert Into Submissions (IncidentTitle,
                             Abstract,
                             Keywords,
                             SubmissionNumber,
                             PreviousSubmissionID,
                             SubmissionDate,
                             SubmissionStatusID)
    Values (_IncidentTitle,
            _Abstract,
            _KeyWords,
            _SubmissionNumber,
            _PreviousSubmissionID,
            CURRENT_DATE,
            1);
    
    Set _SubmissionID = last_insert_id();
    
    /* Get the user's InstitutionAffiliation */
    Select InstitutionAffiliation Into _InstitutionAffiliation
    From Users
    Where UserID = _UserID;
    
    /* Link the UserID to the SubmissionID */
    Insert Into AuthorsSubmission (UserID,
                                   SubmissionID,
                                   InstitutionAffiliation,
                                   PrimaryContact,
                                   AuthorSeniority)
    Values (_UserID,
            _SubmissionID,
            _InstitutionAffiliation,
            1,
            1);
    
    Select _SubmissionID As 'SubmissionID';
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spAuthorGetSubmissionReviewerFilesList`$$
CREATE PROCEDURE `spAuthorGetSubmissionReviewerFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Lists the feedback files for a submission
   */
  Select fmd.FileMetaDataID,
         fmd.FileName,
         fmd.FileSize,
         ft.FileType
  From Reviewers r
    Inner Join ReviewerFiles rf
      On rf.ReviewerUserID = r.ReviewerUserID
        And rf.SubmissionID = r.SubmissionID
    Inner Join FileMetaData fmd
      On fmd.FileMetaDataID = rf.FileMetaDataID
    Inner Join FileTypes ft
      On ft.FileTypeID = fmd.FileTypeID
  Where rf.SubmissionID = _SubmissionID;
END$$

DROP PROCEDURE IF EXISTS `spAuthorUpdateSubmission`$$
CREATE PROCEDURE `spAuthorUpdateSubmission`(IN _SubmissionID int,
                                            IN _IncidentTitle varchar(150),
                                            IN _Abstract varchar(5000),
                                            IN _KeyWords varchar(5000),
                                            IN _SubmissionNumber TINYINT)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing submission record
   */
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
  
    /* Update the submission record */
    Update Submissions
    Set IncidentTitle = _IncidentTitle,
        Abstract = _Abstract,
        Keywords = _KeyWords,
        SubmissionNumber = _SubmissionNumber
    Where SubmissionID = _SubmissionID;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spAuthorViewSubmissions`$$
CREATE PROCEDURE `spAuthorViewSubmissions`(IN _UserID int,
                                           IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Lists the submissions for an author for a given year
   */
  Select s.SubmissionID,
         s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
         ss.SubmissionStatus,
         s.SubmissionDate
  From Submissions s
    Inner Join AuthorsSubmission a
      On a.SubmissionID = s.SubmissionID
    Inner Join SubmissionStatus ss
      On ss.SubmissionStatusID = s.SubmissionStatusID
    Left Join Users eu
      On eu.UserID = s.EditorUserID
  Where a.UserID = _UserID
    And Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DROP PROCEDURE IF EXISTS `spCreateAddress`$$
CREATE PROCEDURE `spCreateAddress`(IN _UserID int,
                                   IN _AddressTypeID int,
                                   IN _AddressLn1 varchar(100),
                                   IN _AddressLn2 varchar(100),
                                   IN _City varchar(30),
                                   IN _StateID int,
                                   IN _PostCode char(5),
                                   IN _PrimaryAddress tinyint)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new address for a user
   */
  Declare _AddressCount int;
  
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the AddressTypeID exists */
    If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
      /* Make sure the StateID exists */
      If(Select Exists(Select 1 From States Where StateID = _StateID)) Then
        /* Default _PrimaryAddress to 0 if null is passed in */
        Set _PrimaryAddress = IFNULL(_PrimaryAddress, 0);
        
        /* Get the count of PhoneNumbers for the user */
        Select Count(AddressID) Into _AddressCount
        From Addresses
        Where UserID = _UserID;
      
        /* New PrimaryAddress, set others for user to 0 */
        If (_PrimaryAddress = 1) Then
          Update Addresses
          Set PrimaryAddress = 0
          Where UserID = _UserID;
        End If;
      
        /* If this is the first address, make it the PrimaryAddress */
        If (_AddressCount = 0) Then
          Set _PrimaryAddress = 1;
        End If;
        
        /* Insert the new address record */
        Insert Into Addresses (UserID,AddressTypeID,AddressLn1,AddressLn2,City,StateID,PostCode,PrimaryAddress,CreateDate)
        Values (_UserID,_AddressTypeID,_AddressLn1,_AddressLn2,_City,_StateID,_PostCode,_PrimaryAddress,CURRENT_DATE);
          
        /* Get the new AddressID */
        Select last_insert_id() As 'AddressID';
      Else
        Select 'Invalid StateID' As 'Error';
      End If;
    Else
      Select 'Invalid AddressTypeID' As 'Error';
    End If;
  Else
    Select 'User doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreateAddressType`$$
CREATE PROCEDURE `spCreateAddressType`(IN _AddressType varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new address type
   */
  /* Make sure the address type doesn't exist */
  If(Select Exists(Select 1 From AddressTypes Where AddressType = _AddressType)) Then
    Select 'Address type already exists' As 'Error';
  Else
    Insert Into AddressTypes(AddressType)
    Values (_AddressType);
    
    Select last_insert_id() As 'AddressTypeID';
  End If; 
END$$

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

DROP PROCEDURE IF EXISTS `spCreateCategory`$$
CREATE PROCEDURE `spCreateCategory`(IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new Category
   */
  /* Make sure the Category doesn't exist */
  If(Select Exists(Select 1 From Categories Where Category = _Category)) Then
    Select 'Category already exists' As 'Error';
  Else
    Insert Into Categories(Category)
    Values (_Category);
    
    Select last_insert_id() As 'CategoryID';
  End If; 
END$$

DROP PROCEDURE IF EXISTS `spCreatePublishedCriticalIncident`$$
CREATE PROCEDURE `spCreatePublishedCriticalIncident`(IN _PublicationID int,
                                                     IN _IncidentTitle varchar(150),
                                                     IN _Abstract varchar(5000),
                                                     IN _Keywords varchar(5000),
                                                     IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a Published Critical Incident record
   */
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Make sure the PublicationID exists */
    If(Select Exists(Select 1 From Publications Where PublicationID = _PublicationID)) Then
      Insert Into PublishedCriticalIncidents (PublicationID, IncidentTitle, Abstract, Keywords, FileMetaDataID)
      Values (_PublicationID, _IncidentTitle, _Abstract, _Keywords, _FileMetaDataID);

      Select last_insert_id() As 'CriticalIncidentID';
    Else
      Select Concat('PublicationID ', _PublicationID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
  End If;
END$$

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

DROP PROCEDURE IF EXISTS `spCreateFileContent`$$
CREATE PROCEDURE `spCreateFileContent`(IN _FileMetaDataID int,
                                       IN _FileContent blob,
                                       IN _SequenceNumber int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a file content record for a FileMetaDataID
   */
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Make sure the FileMetaDataID & SequenceNumber doesn't exist */
    If(Select Exists(Select 1 From FileData Where FileMetaDataID = _FileMetaDataID And SequenceNumber = _SequenceNumber)) Then
      Select 'FileMetaDataID with this SequenceNumber already exists' As 'Error';
    Else
      Insert Into FileData (FileMetaDataID,FileContents,SequenceNumber)
      Values (_FileMetaDataID,_FileContent,_SequenceNumber);
    End If;
  Else
    Select 'FileMetaDataID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreateFileMetaData`$$
CREATE PROCEDURE `spCreateFileMetaData`(IN _FileTypeID int,
                                        IN _FileMime varchar(200),
                                        IN _sFileName varchar(200),
                                        IN _sFileSize int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID
   */
  Declare _FileMetaDataID int;
  
  /* Make sure the FileTypeID exists */
  If(Select Exists(Select 1 From FileTypes Where FileTypeID = _FileTypeID)) Then
    Insert Into FileMetaData (FileTypeID,FileMime,FileName,FileSize)
    Values (_FileTypeID,_FileMime,_sFileName,_sFileSize);
    
    /* Return the new FileMetaDataID */
    Select last_insert_id() As 'FileMetaDataID';
  Else
    Select Concat('FileTypeID ', _FileTypeID,' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreatePhoneNumber`$$
CREATE PROCEDURE `spCreatePhoneNumber`(IN _UserID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
                                       IN _PrimaryPhone tinyint)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new phone number for a user
   */
  Declare _PhoneCount int;
  
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the PhoneTypeID exists */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
      /* Default _PrimaryPhone to 0 if null is passed in */
      Set _PrimaryPhone = IFNULL(_PrimaryPhone, 0);
      
      /* Get the count of PhoneNumbers for the user */
      Select Count(PhoneNumberID) Into _PhoneCount
      From PhoneNumbers
      Where UserID = _UserID;
      
      /* New PrimaryPhone, set others for user to 0 */
      If (_PrimaryPhone = 1) Then
        Update PhoneNumbers
        Set PrimaryPhone = 0
        Where UserID = _UserID;
      End If;
      
      /* If this is the first number, make it the PrimaryPhone */
      If (_PhoneCount = 0) Then
        Set _PrimaryPhone = 1;
      End If;
      
      /* Insert the new phone number record */
      Insert Into PhoneNumbers (UserID,PhoneTypeID,PhoneNumber,PrimaryPhone,CreateDate)
      Values (_UserID,_PhoneTypeID,_PhoneNumber,_PrimaryPhone,CURRENT_DATE);
        
      /* Get the new PhoneNumberID */
      Select last_insert_id() As 'PhoneNumberID';
    Else
      Select 'Invalid PhoneTypeID' As 'Error';
    End If;
  Else
    Select 'User doesn''t exist' As 'Error';
  End If; 
END$$

DROP PROCEDURE IF EXISTS `spCreatePhoneType`$$
CREATE PROCEDURE `spCreatePhoneType`(IN _PhoneType varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new phone number type
   */
  /* Make sure the Phone Type doesn't exist */
  If(Select Exists(Select 1 From PhoneTypes Where PhoneType = _PhoneType)) Then
    Select 'Phone type already exists' As 'Error';
  Else
    Insert Into PhoneTypes(PhoneType)
    Values (_PhoneType);
    
    Select last_insert_id() As 'PhoneTypeID';
  End If; 
END$$

DROP PROCEDURE IF EXISTS `spCreatePublication`$$
CREATE PROCEDURE `spCreatePublication`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a Publication record for a year
   */
  Declare _Year int;
  Set _Year = Year(CURRENT_DATE);
  
  If(Select Exists(Select 1 From Publications Where Year = _Year)) Then
    Select Concat('Publication for year ', _Year, ' already exists') As 'Error';
  Else
    If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
      Insert Into Publications (Year, FileMetaDataID)
      Values (_Year, _FileMetaDataID);
      
      Select last_insert_id() As 'PublicationID';
    Else
      Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
    End If;
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreatePublicationCategory`$$
CREATE PROCEDURE `spCreatePublicationCategory`(IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a new category for published incidents
   */
  If(Select Exists(Select 1 From PublicationCategories Where Category = _Category)) Then
    Select Concat('Category "', _Category, '" already exists') As 'Error';
  Else
    Insert Into PublicationCategories (Category)
    Values (_Category);
    
    Select last_insert_id() As 'CategoryID';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreatePublishedAuthor`$$
CREATE PROCEDURE `spCreatePublishedAuthor`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a Published Author record from the Users table
   */
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
      Insert Into PublishedAuthors (FirstName, LastName, EmailAddress, InstitutionAffiliation)
      Select FirstName, LastName, EmailAddress, InstitutionAffiliation
      From Users
      Where UserID = _UserID;
      
      Select last_insert_id() As 'AuthorID';
  Else
    Select Concat('UserID ', _UserID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreatePublishedCriticalIncident`$$
CREATE PROCEDURE `spCreatePublishedCriticalIncident`(IN _PublicationID int,
                                                     IN _IncidentTitle varchar(150),
                                                     IN _Abstract varchar(5000),
                                                     IN _Keywords varchar(5000),
                                                     IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a Published Critical Incident record
   */
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Make sure the PublicationID exists */
    If(Select Exists(Select 1 From Publications Where PublicationID = _PublicationID)) Then
      Insert Into PublishedCriticalIncidents (PublicationID, IncidentTitle, Abstract, Keywords, FileMetaDataID)
      Values (_PublicationID, _IncidentTitle, _Abstract, _Keywords, _FileMetaDataID);

      Select last_insert_id() As 'CriticalIncidentID';
    Else
      Select Concat('PublicationID ', _PublicationID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreatePublishedIncidentAuthor`$$
CREATE PROCEDURE `spCreatePublishedIncidentAuthor`(IN _AuthorID int,
                                                   IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Links a published author to a published critical incident
   */
  /* Make sure the AuthorID exists */
  If(Select Exists(Select 1 From PublishedAuthors Where AuthorID = _AuthorID)) Then
    /* Make sure the CriticalIncidentID exists */
    If(Select Exists(Select 1 From PublishedCriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
      Insert Into PublishedIncidentsAuthors (AuthorID, CriticalIncidentID)
      Values (_AuthorID, _CriticalIncidentID);
    Else
      Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('AuthorID ', _AuthorID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreateReviewerFileMetaData`$$
CREATE PROCEDURE `spCreateReviewerFileMetaData`(IN _SubmissionID int,
                                                IN _ReviewerUserID int,
                                                IN _FileTypeID int,
                                                IN _FileMime varchar(200),
                                                IN _sFileName varchar(200),
                                                IN _sFileSize int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID
   */
  Declare _FileMetaDataID int;
  
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the ReviewerUserID exists */
    If(Select Exists(Select 1 From Users Where UserID = _ReviewerUserID)) Then
      Insert Into FileMetaData (FileTypeID,FileMime,FileName,FileSize)
      Values (_FileTypeID,_FileMime,_sFileName,_sFileSize);
      
      /* Get the new FileMetaDataID */
      Set _FileMetaDataID = last_insert_id();
      
      /* Connect the new FileMetaDataID to the SubmissionID */
      Insert Into ReviewerFiles(SubmissionID,ReviewerUserID,FileMetaDataID)
      Values (_SubmissionID,_ReviewerUserID,_FileMetaDataID);
      
      /* Output the new FileMetaDataID */
      Select _FileMetaDataID As 'FileMetaDataID';
    Else
      Select 'ReviewerUserID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreateSubmissionFileMetaData`$$
CREATE PROCEDURE `spCreateSubmissionFileMetaData`(IN _SubmissionID int,
                                                  IN _FileTypeID int,
                                                  IN _FileMime varchar(200),
                                                  IN _sFileName varchar(200),
                                                  IN _sFileSize int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID
   */
  Declare _FileMetaDataID int;
  
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    Insert Into FileMetaData (FileTypeID,FileMime,FileName,FileSize)
    Values (_FileTypeID,_FileMime,_sFileName,_sFileSize);
    
    /* Get the new FileMetaDataID */
    Set _FileMetaDataID = last_insert_id();
    
    /* Connect the new FileMetaDataID to the SubmissionID */
    Insert Into SubmissionFiles(SubmissionID,FileMetaDataID)
    Values (_SubmissionID,_FileMetaDataID);
    
    /* Output the new FileMetaDataID */
    Select _FileMetaDataID As 'FileMetaDataID';
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spCreateUser`$$
CREATE PROCEDURE `spCreateUser`(IN _EmailAddress varchar(200),
                                IN _Password varchar(50),
                                IN _FirstName varchar(15),
                                IN _LastName varchar(30))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new user then returns the UserID
   */
  Declare _UserID int;

  /* Make sure the email address doesn't already exist */
  If(Select Exists(Select 1 From Users Where EmailAddress = _EmailAddress)) Then
    Select -1 As 'UserID', 'Email address already exists' As 'Error';
  Else
    /* Insert the new User record */
    Insert Into Users (EmailAddress,
                       NewEmailAddress,
                       PasswordHash,
                       FirstName,
                       LastName,
                       EmailStatusID,
                       EmailVerificationGUID,
                       NewEmailAddressCreateDate,
                       Active,
                       CreateDate)
    Values (LOWER(_EmailAddress),
            LOWER(_EmailAddress),
            SHA1(_Password),
            _FirstName,
            _LastName,
            1,
            REPLACE(UUID(),'-',''),
            CURRENT_DATE,
            1,
            CURRENT_DATE);
    
    /* Get the new UserID */
    Set _UserID = last_insert_id();
    
    /* Set the new user to Role: Author */
    Insert Into UserRoles (UserID,RoleID)
    Values (_UserID,1);
    
    /* Return the new UserID and GUID for password verification */
    Select u.UserID
    From Users u
    Where u.UserID = _UserID;
  End If;  
END$$

DROP PROCEDURE IF EXISTS `spDeleteAddress`$$
CREATE PROCEDURE `spDeleteAddress`(IN _AddressID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes a user's address
   */
  Delete From Addresses
  Where AddressID = _AddressID;
END$$

DROP PROCEDURE IF EXISTS `spDeletePhoneNumber`$$
CREATE PROCEDURE `spDeletePhoneNumber`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes a user's phone number
   */
  Delete From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

DROP PROCEDURE IF EXISTS `spDisableUser`$$
CREATE PROCEDURE `spDisableUser`(IN _UserID int,
                                 IN _NonActiveNote varchar(5000))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates the user's account to mark them as disabled
   */
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set Active = 0, NonActiveNote = _NonActiveNote
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If; 
END$$

DROP PROCEDURE IF EXISTS `spEditorCreateUser`$$
CREATE PROCEDURE `spEditorCreateUser`(IN _EmailAddress varchar(200),
                                      IN _Password varchar(50),
                                      IN _FirstName varchar(15),
                                      IN _LastName varchar(30),
                                      IN _InstitutionAffiliation varchar(100),
                                      IN _MemberCode varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new user then returns the UserID
   */
  Declare _UserID int;

  /* Make sure the email address doesn't already exist */
  If(Select Exists(Select 1 From Users Where EmailAddress = _EmailAddress)) Then
    Select 'Email address already exists' As 'Error';
  Else
    /* Insert the new User record */
    Insert Into Users (EmailAddress,
                       NewEmailAddress,
                       PasswordHash,
                       FirstName,
                       LastName,
                       InstitutionAffiliation,
                       MemberCode,
                       EmailStatusID,
                       EmailVerificationGUID,
                       NewEmailAddressCreateDate,
                       Active,
                       CreateDate)
    Values (LOWER(_EmailAddress),
            LOWER(_EmailAddress),
            SHA1(_Password),
            _FirstName,
            _LastName,
            _InstitutionAffiliation,
            _MemberCode,
            3,
            NULL,
            NULL,
            1,
            CURRENT_DATE);
    
    /* Get the new UserID */
    Set _UserID = last_insert_id();
    
    /* Set the new user to Role: Author */
    Insert Into UserRoles (UserID,RoleID)
    Values (_UserID,1);
    
    /* Return the new UserID and GUID for password verification */
    Select u.UserID
    From Users u
    Where u.UserID = _UserID;
  End If;  
END$$

DROP PROCEDURE IF EXISTS `spEditorViewSubmissions`$$
CREATE PROCEDURE `spEditorViewSubmissions`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Lists the submissions for an editor for a given year
   */
  Select s.SubmissionID,
         s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
         GROUP_CONCAT(CONCAT('''',ua.FirstName,' ',ua.LastName,'''')) As 'Authors',
         GROUP_CONCAT(CONCAT('''',ur.FirstName,' ',ur.LastName,'''')) As 'Reviewers',
         ss.SubmissionStatus,
         s.SubmissionDate
  From Submissions s
    Left Join Users eu
      On eu.UserID = s.EditorUserID
    Inner Join Reviewers r
      On r.SubmissionID = s.SubmissionID
    Inner Join Users ur
      On ur.UserID = r.ReviewerUserID
    Inner Join AuthorsSubmission a
      On a.SubmissionID = s.SubmissionID
    Inner Join Users ua
      On ua.UserID = a.UserID
    Inner Join SubmissionStatus ss
      On ss.SubmissionStatusID = s.SubmissionStatusID
  Where Year(s.SubmissionDate) = _Year
  Group By s.SubmissionID,
           s.IncidentTitle,
           s.EditorUserID,
           ss.SubmissionStatus,
           s.SubmissionDate
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DROP PROCEDURE IF EXISTS `spEnableUser`$$
CREATE PROCEDURE `spEnableUser`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates the user's account to re-enable them
   */
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set Active = 1, NonActiveNote = Null
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If; 
END$$

DROP PROCEDURE IF EXISTS `spGetActiveEditors`$$
CREATE PROCEDURE `spGetActiveEditors`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of Editors who are active
   */
  Select u.EmailAddress
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
  Where Active = 1
    And ur.RoleID = 3;
END$$

DROP PROCEDURE IF EXISTS `spGetAddressTypes`$$
CREATE PROCEDURE `spGetAddressTypes`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of addresses
   */
  Select AddressTypeID, AddressType
  From AddressTypes
  Order By AddressType;
END$$

DROP PROCEDURE IF EXISTS `spGetAllAnnouncementsList`$$
CREATE PROCEDURE `spGetAllAnnouncementsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of all Announcements
   */
  Select a.AnnouncementID,
         a.Title,
         GROUP_CONCAT(r.RoleTitle) As 'Roles',
         a.CreateDate,
         IfNull(a.ExpireDate,'') As 'ExpireDate'
  From Announcements a
    Inner Join AccouncementRoles ar
      On ar.AnnouncementID = a.AnnouncementID
    Inner Join Roles r
      On r.RoleID = ar.RoleID
  Group By a.Title,
           a.CreateDate,
           a.ExpireDate
  Order By a.CreateDate,
           a.Title;
END$$

DROP PROCEDURE IF EXISTS `spGetAnnouncement`$$
CREATE PROCEDURE `spGetAnnouncement`(IN _AnnouncementID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the info of an announcement
   */
  Select AnnouncementID,
         Title,
         Message,
         CreateDate,
         IfNull(ExpireDate,'') As 'ExpireDate'
  From Announcements
  Where AnnouncementID = _AnnouncementID;
END$$

DROP PROCEDURE IF EXISTS `spGetAnnouncementRoles`$$
CREATE PROCEDURE `spGetAnnouncementRoles`(IN _AnnouncementID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of roles for an announcement
   */
  Select r.RoleTitle
  From AccouncementRoles ar
    Inner Join Roles r
      On r.RoleID = ar.RoleID
  Where ar.AnnouncementID = _AnnouncementID;
END$$

DROP PROCEDURE IF EXISTS `spGetAnnouncements`$$
CREATE PROCEDURE `spGetAnnouncements`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of Announcements for a UserID
   */
  Select rtn.Title,
         rtn.Message,
         rtn.CreateDate,
         IfNull(rtn.ExpireDate,'') As 'ExpireDate'
  From (
    Select Title,
           Message,
           CreateDate,
           ExpireDate
    From Announcements a
      Inner Join AccouncementRoles ar
        On ar.AnnouncementID = a.AnnouncementID 
    Where ar.RoleID = 6 /* Public announcements */
    Union All
    Select a.Title,
           a.Message,
           a.CreateDate,
           a.ExpireDate
    From Announcements a
      Inner Join AccouncementRoles ar
        On ar.AnnouncementID = a.AnnouncementID
      Inner Join Roles r
        On r.RoleID = ar.RoleID
      Inner Join UserRoles ur
        On ur.RoleID = r.RoleID
      Inner Join Users u
        On u.UserID = ur.UserID
    Where u.UserID = _UserID /* User specific (all roles) announcements */
  ) rtn
  Group By rtn.Title,
           rtn.Message,
           rtn.CreateDate,
           rtn.ExpireDate
  Order By rtn.CreateDate,
           rtn.Title;
END$$

DROP PROCEDURE IF EXISTS `spGetArticleDates`$$
CREATE PROCEDURE `spGetArticleDates`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Article Dates for a year
   */
  /* If the year is null, set it to current year */
  Set _Year = IfNull(_Year, Year(CURRENT_DATE));
  
  Select AuthorFirstSubmissionStartDate,
         AuthorFirstSubmissionDueDate,
         FirstReviewStartDate,
         FirstReviewDueDate,
         AuthorSecondSubmissionStartDate,
         AuthorSecondSubmissionDueDate,
         SecondReviewStartDate,
         SecondReviewDueDate,
         AuthorPublicationSubmissionStartDate,
         AuthorPublicationSubmissionDueDate,
         PublicationDate
  From SystemSettings_ArticleDates
  Where Year = _Year;
END$$

DROP PROCEDURE IF EXISTS `spGetEmailSettings`$$
CREATE PROCEDURE `spGetEmailSettings`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Email Settings
   */
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

DROP PROCEDURE IF EXISTS `spGetFileContents`$$
CREATE PROCEDURE `spGetFileContents`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file content records for a FileMetaDataID
   */
  Select FileContents
  From FileData
  Where FileMetaDataID = _FileMetaDataID
  Order By SequenceNumber;
END$$

DROP PROCEDURE IF EXISTS `spGetFileInfo`$$
CREATE PROCEDURE `spGetFileInfo`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file info record for a FileMetaDataID
   */
  Select FileName, FileMime, FileSize
  From FileMetaData
  Where FileMetaDataID = _FileMetaDataID;
END$$

DROP PROCEDURE IF EXISTS `spGetFileTypes`$$
CREATE PROCEDURE `spGetFileTypes`(IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of files for a role
   */
  Select FileTypeID, FileType
  From FileTypes
  Where RoleID = _RoleID
  Order By FileType;
END$$

DROP PROCEDURE IF EXISTS `spGetNextDates`$$
CREATE PROCEDURE `spGetNextDates`(IN _Number int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets next important dates
   */
  /* Store the current date */
  Declare _CurrDate date;
  Declare _AuthorFirstSubmissionStartDate date;
  Declare _AuthorFirstSubmissionDueDate date;
  Declare _FirstReviewStartDate date;
  Declare _FirstReviewDueDate date;
  Declare _AuthorSecondSubmissionStartDate date;
  Declare _AuthorSecondSubmissionDueDate date;
  Declare _SecondReviewStartDate date;
  Declare _SecondReviewDueDate date;
  Declare _AuthorPublicationSubmissionStartDate date;
  Declare _AuthorPublicationSubmissionDueDate date;
  Declare _PublicationDate date;
  
  Set _Number = IfNull(_Number, 3);
  If (_Number < 2) Then
    Set _Number = 2;
  End If;
  
  Set _CurrDate = CURRENT_DATE;
  
  /* Drop the temporary table */
  Drop Table If Exists TempEditorDates;
  
  /* Create the temporary table */
  Create Table TempEditorDates (
    Dte date NOT NULL,
    Description varchar(100) NOT NULL,
    PRIMARY KEY (Dte)
  );
  
  Select AuthorFirstSubmissionStartDate,
         AuthorFirstSubmissionDueDate,
         FirstReviewStartDate,
         FirstReviewDueDate,
         AuthorSecondSubmissionStartDate,
         AuthorSecondSubmissionDueDate,
         SecondReviewStartDate,
         SecondReviewDueDate,
         AuthorPublicationSubmissionStartDate,
         AuthorPublicationSubmissionDueDate,
         PublicationDate
  Into _AuthorFirstSubmissionStartDate,
       _AuthorFirstSubmissionDueDate,
       _FirstReviewStartDate,
       _FirstReviewDueDate,
       _AuthorSecondSubmissionStartDate,
       _AuthorSecondSubmissionDueDate,
       _SecondReviewStartDate,
       _SecondReviewDueDate,
       _AuthorPublicationSubmissionStartDate,
       _AuthorPublicationSubmissionDueDate,
       _PublicationDate
  From SystemSettings_ArticleDates
  Where Year = Year(_CurrDate);
  
  If (_CurrDate < _AuthorFirstSubmissionStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorFirstSubmissionStartDate, 'First incident article submissions begin');
  End If;
  
  If (_CurrDate < _AuthorFirstSubmissionDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorFirstSubmissionDueDate, 'First incident article submissions are due');
  End If;
  
  If (_CurrDate < _FirstReviewStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_FirstReviewStartDate, 'First submission articles are sent to the reviewers');
  End If;
  
  If (_CurrDate < _FirstReviewDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_FirstReviewDueDate, 'First submission articles reviews completed');
  End If;
  
  If (_CurrDate < _AuthorSecondSubmissionStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorSecondSubmissionStartDate, 'Second incident article submissions begin');
  End If;
  
  If (_CurrDate < _AuthorSecondSubmissionDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorSecondSubmissionDueDate, 'Second incident article submissions are due');
  End If;
  
  If (_CurrDate < _SecondReviewStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_SecondReviewStartDate, 'Second submission articles are sent to the reviewers');
  End If;
  
  If (_CurrDate < _SecondReviewDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_SecondReviewDueDate, 'Second submission articles reviews completed');
  End If;
  
  If (_CurrDate < _AuthorPublicationSubmissionStartDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorPublicationSubmissionStartDate, 'Incident publication article submissions begin');
  End If;
  
  If (_CurrDate < _AuthorPublicationSubmissionDueDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_AuthorPublicationSubmissionDueDate, 'Incident publication article submissions are due');
  End If;
  
  If (_CurrDate < _PublicationDate) Then
    Insert Into TempEditorDates (Dte, Description)
    Values (_PublicationDate, 'Publication of the Journal of Critical Incidents');
  End If;
  
  If (_Number = 2) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 2;
  ElseIf (_Number = 3) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 3;
  ElseIf (_Number = 4) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 4;
  ElseIf (_Number = 5) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 5;
  ElseIf (_Number = 6) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 6;
  ElseIf (_Number = 7) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 7;
  ElseIf (_Number = 8) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 8;
  ElseIf (_Number = 9) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 9;
  ElseIf (_Number = 10) Then
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By dte
    Limit 10;
  Else
    Select dte As 'Date',
           Description
    From TempEditorDates
    Order By Dte;
  End If;
  
  /* Drop the temporary table */
  Drop Table If Exists TempEditorDates;
END$$

DROP PROCEDURE IF EXISTS `spGetPhoneTypes`$$
CREATE PROCEDURE `spGetPhoneTypes`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of phone numbers
   */
  Select PhoneTypeID, PhoneType
  From PhoneTypes
  Order By PhoneType;
END$$

DROP PROCEDURE IF EXISTS `spGetPublicationCategories`$$
CREATE PROCEDURE `spGetPublicationCategories`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of categories for published incidents
   */
  Select CategoryID, Category
  From PublicationCategories
  Order By Category;
END$$

DROP PROCEDURE IF EXISTS `spGetPublicationsList`$$
CREATE PROCEDURE `spGetPublicationsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Publications in decending order
   */
  Select PublicationID,
         Year,
         FileMetaDataID
  From Publications
  Order By Year;
END$$

DROP PROCEDURE IF EXISTS `spGetPublicationsYearsList`$$
CREATE PROCEDURE `spGetPublicationsYearsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available years from Publications
   */
  Select Year,
         FileMetaDataID
  From Publications
  Order By Year Desc;
END$$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncident`$$
CREATE PROCEDURE `spGetPublishedCriticalIncident`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the Published Incident info
   */
  Select pci.CriticalIncidentID,
         pci.IncidentTitle,
         pci.Abstract,
         pci.Keywords,
         p.Year
  From PublishedCriticalIncidents pci
    Inner Join Publications p
      On p.PublicationID = pci.PublicationID
  Where pci.CriticalIncidentID = _CriticalIncidentID
  Order By pci.IncidentTitle;
END$$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentAuthors`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentAuthors`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the Authors for a Published Incident
   */
  Select Concat(pa.LastName, ', ', pa.FirstName) As 'FullName',
         pa.EmailAddress,
         pa.InstitutionAffiliation
  From PublishedAuthors pa
    Inner Join PublishedIncidentsAuthors pca
      On pca.AuthorID = pa.AuthorID
  Where pca.CriticalIncidentID = _CriticalIncidentID
  Order By pa.LastName, pa.FirstName;
END$$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentCategories`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentCategories`(IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the Categories for a Published Incident
   */
  Select pc.CategoryID, pc.Category
  From PublicationCategories pc
    Inner Join PublishedCriticalIncidentCategories pcic
      On pcic.CategoryID = pc.CategoryID
  Where pcic.CriticalIncidentID = _CriticalIncidentID
  Order By pc.Category;
END$$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidents`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidents`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list Published Incidents for a year for editor adding
   */
  Select pci.CriticalIncidentID,
         pci.IncidentTitle,
         pci.Abstract
  From PublishedCriticalIncidents pci
    Inner Join Publications p
      On p.PublicationID = pci.PublicationID
  Where p.Year = _Year
  Order By pci.IncidentTitle;
END$$

DROP PROCEDURE IF EXISTS `spGetPublishedCriticalIncidentsList`$$
CREATE PROCEDURE `spGetPublishedCriticalIncidentsList`(IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list Published Incidents for a year for search page
   */
  Select pci.CriticalIncidentID,
         pci.IncidentTitle,
         pci.Abstract,
         pci.Keywords,
         Group_Concat(concat(pa.LastName, ', ', pa.FirstName)) As 'Authors',
         pci.FileMetaDataID
  From PublishedCriticalIncidents pci
    Inner Join Publications p
	  On p.PublicationID = pci.PublicationID
    Right Join PublishedIncidentsAuthors pia
      On pia.CriticalIncidentID = pci.CriticalIncidentID
    Right Join PublishedAuthors pa
      On pa.AuthorID = pia.AuthorID
  Where p.Year = _Year
  Group By pci.CriticalIncidentID,
           pci.IncidentTitle,
           pci.Abstract,
           pci.Keywords,
           pci.FileMetaDataID
  Order By pci.IncidentTitle;
END$$

DROP PROCEDURE IF EXISTS `spGetReviewStatusList`$$
CREATE PROCEDURE `spGetReviewStatusList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of reviewer statuses
   */
  Select ReviewStatusID, ReviewStatus
  From ReviewStatus
  Order By ReviewStatusID;
END$$

DROP PROCEDURE IF EXISTS `spGetRoles`$$
CREATE PROCEDURE `spGetRoles`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available roles
   */
  Select RoleID,
         RoleTitle
  From Roles
  Order By RoleTitle;
END$$

DROP PROCEDURE IF EXISTS `spGetSpotInProcess`$$
CREATE PROCEDURE `spGetSpotInProcess`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the spot in the editing process by current date
   */
  /* Store the current date */
  Declare _CurrDate date;
  Declare _SpotID int;
  Set _CurrDate = CURRENT_DATE;
  
  Select Case 
    When _CurrDate Between AuthorFirstSubmissionStartDate And AuthorFirstSubmissionDueDate Then 1
    When _CurrDate Between AuthorFirstSubmissionDueDate And FirstReviewStartDate Then 2
    When _CurrDate Between FirstReviewStartDate And FirstReviewDueDate Then 3
    When _CurrDate Between FirstReviewDueDate And AuthorSecondSubmissionStartDate Then 4
    When _CurrDate Between AuthorSecondSubmissionStartDate And AuthorSecondSubmissionDueDate Then 5
    When _CurrDate Between AuthorSecondSubmissionDueDate And SecondReviewStartDate Then 6
    When _CurrDate Between SecondReviewStartDate And SecondReviewDueDate Then 7
    When _CurrDate Between SecondReviewDueDate And AuthorPublicationSubmissionStartDate Then 8
    When _CurrDate Between AuthorPublicationSubmissionStartDate And AuthorPublicationSubmissionDueDate Then 9
    When _CurrDate Between AuthorPublicationSubmissionDueDate And PublicationDate Then 10
    When _CurrDate > PublicationDate Then 1
    End Into _SpotID
  From SystemSettings_ArticleDates
  Where Year = Year(_CurrDate);
  
  Select ID, DefinitionText
  From SystemSettings_DateDefinitions
  Where ID = _SpotID;
END$$

/*  */
DROP PROCEDURE IF EXISTS `spGetStates`$$
CREATE PROCEDURE `spGetStates`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of states
   */
  Select StateID, CONCAT(Abbr,' - ',Name) As FullStateName
  From States
  Order By Abbr;
END$$

DROP PROCEDURE IF EXISTS `spGetUserAddressInfo`$$
CREATE PROCEDURE `spGetUserAddressInfo`(IN _AddressID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the address info for an id
   */
  Select AddressID,
         UserID,
         AddressTypeID,
         AddressLn1,
         AddressLn2,
         City,
         StateID,
         PostCode,
         PrimaryAddress
  From Addresses
  Where AddressID = _AddressID
  Order By CreateDate;
END$$

DROP PROCEDURE IF EXISTS `spGetUserAddressList`$$
CREATE PROCEDURE `spGetUserAddressList`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's address list
   */
  Select a.AddressID,
         t.AddressType,
         a.AddressLn1,
         a.AddressLn2,
         a.City,
         s.Abbr As 'State',
         a.PostCode,
         a.PrimaryAddress
  From Addresses a
    Inner Join AddressTypes t
      On t.AddressTypeID = a.AddressTypeID
    Inner Join States s
      On s.StateID = a.StateID
  Where UserID = _UserID
  Order By a.CreateDate;
END$$

DROP PROCEDURE IF EXISTS `spGetUserID`$$
CREATE PROCEDURE `spGetUserID`(IN _EmailAddress VarChar(200),
                               IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Get the UserID (or -1) for the EmailAddress/Password combination
   */
  Declare _UserID Int;

  Select u.UserID Into _UserID
  From Users u
  Where u.EmailAddress = LOWER(_EmailAddress)
    And u.PasswordHash = SHA1(_Password);
    
  Select IfNull(_UserID, -1) As 'UserID';
END$$

DROP PROCEDURE IF EXISTS `spGetUserInfo`$$
CREATE PROCEDURE `spGetUserInfo`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's info
   */
  Select FirstName,
         LastName,
         EmailAddress,
         MemberCode,
         InstitutionAffiliation,
         IF(ValidMembership, 'Y', 'N') As 'IsValidMember',
         IF(Active, 'Y', 'N') As 'IsActive'
  From Users
  Where UserID = _UserID;
END$$

DROP PROCEDURE IF EXISTS `spGetUserPhoneInfo`$$
CREATE PROCEDURE `spGetUserPhoneInfo`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the phone info for an id
   */
  Select PhoneNumberID,
         UserID,
         PhoneTypeID,
         PhoneNumber,
         PrimaryPhone
  From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

DROP PROCEDURE IF EXISTS `spGetUserPhoneList`$$
CREATE PROCEDURE `spGetUserPhoneList`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's phone list
   */
  Select p.PhoneNumberID,
         t.PhoneType,
         p.PhoneNumber,
         p.PrimaryPhone
  From PhoneNumbers p
    Inner Join PhoneTypes t
      On t.PhoneTypeID = p.PhoneTypeID
  Where p.UserID = _UserID
  Order By p.CreateDate;
END$$

DROP PROCEDURE IF EXISTS `spGetUserRoles`$$
CREATE PROCEDURE `spGetUserRoles`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the roles associated with a UserID
   */
  Select r.RoleTitle
  From UserRoles ur
    Inner Join Roles r
      On r.RoleID = ur.RoleID
  Where ur.UserID = _UserID;
END$$

DROP PROCEDURE IF EXISTS `spGetUsersAuthorsList`$$
CREATE PROCEDURE `spGetUsersAuthorsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of active UserID and FullNames who are Authors
   */
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
  Where ur.RoleID = 1
    And u.Active = 1
    And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

DROP PROCEDURE IF EXISTS `spGetUsersEditorsList`$$
CREATE PROCEDURE `spGetUsersEditorsList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of active UserID and FullNames who are Editors
   */
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
  Where ur.RoleID = 3
    And u.Active = 1
    And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

DROP PROCEDURE IF EXISTS `spGetUsersList`$$
CREATE PROCEDURE `spGetUsersList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Get the list of users, both active and inactive in alphbetical order
   */
  Select u.UserID,
         u.EmailAddress,
         CONCAT(u.LastName,', ',u.FirstName) As 'FullName',
         GROUP_CONCAT(r.RoleTitle) As 'Roles',
         IF(u.Active, 'Y', 'N') As 'IsActive'
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
    Inner Join Roles r
      On r.RoleID = ur.RoleID
  Group By u.UserID,
           u.EmailAddress,
           u.FirstName,
           u.LastName,
           u.Active
  Order By u.LastName,
           u.FirstName,
           u.UserID;
END$$

DROP PROCEDURE IF EXISTS `spGetUsersReviewersList`$$
CREATE PROCEDURE `spGetUsersReviewersList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of active UserID and FullNames who are Reviewers
   */
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
      On ur.UserID = u.UserID
  Where ur.RoleID = 2
    And u.Active = 1
    And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

DROP PROCEDURE IF EXISTS `spGetVerificationUserInfo`$$
CREATE PROCEDURE `spGetVerificationUserInfo`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's info for sending verification email
   */
  Select FirstName,
         LastName,
         NewEmailAddress,
         EmailVerificationGUID
  From Users
  Where UserID = _UserID;
END$$

DROP PROCEDURE IF EXISTS `spJobCreateArticleDates`$$
CREATE PROCEDURE `spJobCreateArticleDates`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates the available Article Dates for a new year
   */
  Declare _CurrYear int;
  Set _CurrYear = Year(CURRENT_DATE);
  
  Insert Into SystemSettings_ArticleDates (Year,
                                           AuthorFirstSubmissionStartDate,
                                           AuthorFirstSubmissionDueDate,
                                           FirstReviewStartDate,
                                           FirstReviewDueDate,
                                           AuthorSecondSubmissionStartDate,
                                           AuthorSecondSubmissionDueDate,
                                           SecondReviewStartDate,
                                           SecondReviewDueDate,
                                           AuthorPublicationSubmissionStartDate,
                                           AuthorPublicationSubmissionDueDate,
                                           PublicationDate)
  Select _CurrYear As 'Year',
         CONCAT(_CurrYear, RIGHT(AuthorFirstSubmissionStartDate,6)) As 'AuthorFirstSubmissionStartDate',
         CONCAT(_CurrYear, RIGHT(AuthorFirstSubmissionDueDate,6)) As 'AuthorFirstSubmissionDueDate',
         CONCAT(_CurrYear, RIGHT(FirstReviewStartDate,6)) As 'FirstReviewStartDate',
         CONCAT(_CurrYear, RIGHT(FirstReviewDueDate,6)) As 'FirstReviewDueDate',
         CONCAT(_CurrYear, RIGHT(AuthorSecondSubmissionStartDate,6)) As 'AuthorSecondSubmissionStartDate',
         CONCAT(_CurrYear, RIGHT(AuthorSecondSubmissionDueDate,6)) As 'AuthorSecondSubmissionDueDate',
         CONCAT(_CurrYear, RIGHT(SecondReviewStartDate,6)) As 'SecondReviewStartDate',
         CONCAT(_CurrYear, RIGHT(SecondReviewDueDate,6)) As 'SecondReviewDueDate',
         CONCAT(_CurrYear, RIGHT(AuthorPublicationSubmissionStartDate,6)) As 'AuthorPublicationSubmissionStartDate',
         CONCAT(_CurrYear, RIGHT(AuthorPublicationSubmissionDueDate,6)) As 'AuthorPublicationSubmissionDueDate',
         CONCAT(_CurrYear, RIGHT(PublicationDate,6)) As 'PublicationDate'
  From SystemSettings_ArticleDates
  Where Year = _CurrYear - 1;
END$$

/*  */
DROP PROCEDURE IF EXISTS `spJobPublishEndRollOver`$$
CREATE PROCEDURE `spJobPublishEndRollOver`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of available Article Dates for a year
   */
  Select IF(CURRENT_DATE >= (PublicationDate + INTERVAL 5 DAY), 1, 0) As 'RollOver'
  From SystemSettings_ArticleDates
  Where Year = Year(CURRENT_DATE);
END$$

DROP PROCEDURE IF EXISTS `spJobRemoveExpiredAnnouncements`$$
CREATE PROCEDURE `spJobRemoveExpiredAnnouncements`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes all expired announcements
   */

  /* Remove the associated roles with the expired announcements */
  Delete From AccouncementRoles
  Where AnnouncementID IN (
        Select AnnouncementID
        From Announcements
        Where IfNull(ExpireDate, CURRENT_DATE) < CURRENT_DATE
    );

  /* Remove the expired announcements */
  Delete From Announcements
  Where IfNull(ExpireDate, CURRENT_DATE) < CURRENT_DATE;
END$$

DROP PROCEDURE IF EXISTS `spJobUpdateExpireUsersEmailAddressChange`$$
CREATE PROCEDURE `spJobUpdateExpireUsersEmailAddressChange`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Expire user's EmailAddress change attempts
   */
  /* Registered user never confirmed their email address, expire it outright */
  Update Users
  Set EmailStatusID = 2,
      NewEmailAddressCreateDate = Null,
      EmailVerificationGUID = Null,
      NewEmailAddress = Null
  Where EmailStatusID = 1
    And NewEmailAddress = EmailAddress
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 5 DAY;

  /* User never confirmed their new email address, keep the old one */
  Update Users
  Set EmailStatusID = 3,
      NewEmailAddressCreateDate = Null,
      EmailVerificationGUID = Null,
      NewEmailAddress = Null
  Where EmailStatusID = 1
    And NewEmailAddress != EmailAddress
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 5 DAY;
END$$

DROP PROCEDURE IF EXISTS `spJobYearlyAddMembershipHistory`$$
CREATE PROCEDURE `spJobYearlyAddMembershipHistory`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : For every user create membership history record
   */
  /* Delete the current year's entries */
  Delete From UserMembershipHistory
  Where Year = YEAR(CURRENT_DATE);
  
  /* Insert the new records for every user for this year */
  Insert Into UserMembershipHistory (UserID,Year,ValidMembership)
  Select UserID, YEAR(CURRENT_DATE), ValidMembership
  From Users;
END$$

DROP PROCEDURE IF EXISTS `spLoginGetUserID`$$
CREATE PROCEDURE `spLoginGetUserID`(IN _EmailAddress VarChar(200),
                                    IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Get the UserID (or -1 if invalid) for the EmailAddress/Password combination
   */
  Declare _UserID Int;
  Declare _EmailStatusID Int;
  Declare _Active TinyInt;

  Select u.UserID,
         u.EmailStatusID,
         u.Active
  Into _UserID,
       _EmailStatusID,
       _Active
  From Users u
  Where u.EmailAddress = LOWER(_EmailAddress)
    And u.PasswordHash = SHA1(_Password);

  Set _UserID = IfNull(_UserID, -1);
  Set _EmailStatusID = IfNull(_EmailStatusID, -1);
  Set _Active = IfNull(_Active, -1);
  
  /* Check if a new email address reset needs to occure */    
  If (_EmailStatusID = 2 && _Active = 1) Then
    /* Reset the GUID info */
    Update Users
    Set NewEmailAddress = LOWER(_EmailAddress),
        EmailVerificationGUID = REPLACE(UUID(),'-',''),
        NewEmailAddressCreateDate = CURRENT_DATE,
        EmailStatusID = 1
    Where UserID = _UserID;
  End If;
  
  /* Return the info */
  Select _UserID As 'UserID',
         _EmailStatusID As 'EmailStatusID',
         _Active As 'Active';
END$$

DROP PROCEDURE IF EXISTS `spNagAuthorsSubTwoGetList`$$
CREATE PROCEDURE `spNagAuthorsSubTwoGetList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets list of authors who need to submit publication submission
   */
  Select Concat(u.FirstName, ' ', u.LastName) As 'FullName',
         u.EmailAddress
  From Users u
    Inner Join AuthorsSubmission aas
      On aas.UserID = u.UserID
    Inner Join Submissions s
      On s.SubmissionID = aas.SubmissionID
  Where s.SubmissionStatusID = 7
    And s.SubmissionID Not In (
           Select PreviousSubmissionID
           From Submissions
           Where Year(SubmissionDate) = Year(CURRENT_DATE)
      )
    And Year(s.SubmissionDate) = Year(CURRENT_DATE)
  Group By u.FirstName, u.LastName, u.EmailAddress;
END$$

DROP PROCEDURE IF EXISTS `spNagAuthorsSubTwoGetList`$$
CREATE PROCEDURE `spNagAuthorsSubTwoGetList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets list of authors who need to submit 2nd submission
   */
  Select Concat(u.FirstName, ' ', u.LastName) As 'FullName',
         u.EmailAddress
  From Users u
    Inner Join AuthorsSubmission aas
      On aas.UserID = u.UserID
    Inner Join Submissions s
      On s.SubmissionID = aas.SubmissionID
  Where s.SubmissionStatusID = 8
    And s.SubmissionID Not In (
           Select PreviousSubmissionID
           From Submissions
           Where Year(SubmissionDate) = Year(CURRENT_DATE)
      )
    And Year(s.SubmissionDate) = Year(CURRENT_DATE)
  Group By u.FirstName, u.LastName, u.EmailAddress;
END$$

DROP PROCEDURE IF EXISTS `spNagReviewersGetList`$$
CREATE PROCEDURE `spNagReviewersGetList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets list of reviewers who still have reviews to complete
   */
  Select Concat(u.FirstName, ' ', u.LastName) As 'FullName',
         u.EmailAddress
  From Users u
    Inner Join Reviewers r
      On r.ReviewerUserID = u.UserID
    Inner Join Submissions s
      On r.SubmissionID = s.SubmissionID
  Where r.ReviewStatusID = 1
    And Year(s.SubmissionDate) = Year(CURRENT_DATE)
  Group By u.FirstName, u.LastName, u.EmailAddress;
END$$

DROP PROCEDURE IF EXISTS `spRemoveAnnouncement`$$
CREATE PROCEDURE `spRemoveAnnouncement`(IN _AnnouncementID int) DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Deletes an existing announcement
   */
  /* Remove the Accouncement from the roles */
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID;
  
  /* Remove the Accouncement itself */
  Delete From Announcements
  Where AnnouncementID = _AnnouncementID;
END$$

DROP PROCEDURE IF EXISTS `spRemoveCriticalIncidentCategories`$$
CREATE PROCEDURE `spRemoveCriticalIncidentCategories`(IN _CriticalIncidentID int,
                                                      IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a published incident from a publication category
   */
  Delete From PublishedCriticalIncidentCategories
  Where CriticalIncidentID = _CriticalIncidentID
    And CategoryID = _CategoryID;
END$$

DROP PROCEDURE IF EXISTS `spRemovePublishedIncidentAuthor`$$
CREATE PROCEDURE `spRemovePublishedIncidentAuthor`(IN _AuthorID int,
                                                   IN _CriticalIncidentID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a published author to a published critical incident
   */
  /* Make sure the AuthorID exists */
  If(Select Exists(Select 1 From PublishedAuthors Where AuthorID = _AuthorID)) Then
    /* Make sure the CriticalIncidentID exists */
    If(Select Exists(Select 1 From PublishedCriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
      Delete From PublishedIncidentsAuthors
      Where AuthorID = _AuthorID
        And CriticalIncidentID = _CriticalIncidentID;
    Else
      Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('AuthorID ', _AuthorID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spReviewerAddToSubmission`$$
CREATE PROCEDURE `spReviewerAddToSubmission`(IN _UserID int,
                                             IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Adds a Reviewer UserID to an existing Submission
   */
  /* Make sure the UserID exists and is a reviewer */
  If(Select Exists(Select 1 From Users u Inner Join UserRoles ur On ur.UserID = u.UserID Where u.UserID = _UserID And ur.RoleID = 2)) Then
    /* Make sure the SubmissionID exists */
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
      /* Make sure the combination doesn't exist */
      If(Select Exists(Select 1 From Reviewers Where SubmissionID = _SubmissionID And ReviewerUserID = _UserID)) Then
        Select s.IncidentTitle,
               Concat(u.LastName, ', ', u.FirstName) As 'ReviewerFullName'
        From Reviewers r
          Inner Join Submissions s
            On s.SubmissionID = r.SubmissionID
          Inner Join Users u
            On u.UserID = r.ReviewerUserID
        Where r.ReviewerUserID = _UserID
          And r.SubmissionID = _SubmissionID;
      Else
        /* Link the UserID to the SubmissionID */
        Insert Into Reviewers (ReviewerUserID,
                               SubmissionID,
                               ReviewStatusID,
                               CreateDate,
                               LastUpdatedDate)
        Values (_UserID,
                _SubmissionID,
                1,
                CURRENT_DATE,
                CURRENT_DATE);
        
        Select s.IncidentTitle,
               Concat(u.LastName, ', ', u.FirstName) As 'ReviewerFullName'
        From Reviewers r
          Inner Join Submissions s
            On s.SubmissionID = r.SubmissionID
          Inner Join Users u
            On u.UserID = r.ReviewerUserID
        Where r.ReviewerUserID = _UserID
          And r.SubmissionID = _SubmissionID;
      End If;
    Else
      Select Concat('SubmissionID ', _SubmissionID,' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('UserID ', _UserID, ' doesn''t exist or isn''t a reviewer') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spReviewerGetFilesList`$$
CREATE PROCEDURE `spReviewerGetFilesList`(IN _ReviewerUserID int,
                                          IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file list for a ReviewerUserID & SubmissionID
   */
  Select fmd.FileMetaDataID,
         fmd.FileName,
         fmd.FileSize,
         ft.FileType
  From ReviewerFiles rf
    Inner Join FileMetaData fmd
      On fmd.FileMetaDataID = rf.FileMetaDataID
    Inner Join FileTypes ft
      On ft.FileTypeID = fmd.FileTypeID
  Where rf.SubmissionID = _SubmissionID
    And rf.ReviewerUserID = _ReviewerUserID;
END$$

DROP PROCEDURE IF EXISTS `spReviewerUpdateReviewStatus`$$
CREATE PROCEDURE `spReviewerUpdateReviewStatus`(IN _ReviewerUserID int,
                                                IN _SubmissionID int,
                                                IN _ReviewStatusID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update a reviewer's record to change the status
   */
  Declare _TotalReviewers int;
  Declare _ReviewCompleted int;
  
  /* Make sure the ReviewStatusID exists */
  If(Select Exists(Select 1 From ReviewStatus Where ReviewStatusID = _ReviewStatusID)) Then
    /* Make sure the ReviewerUserID and SubmissionID combination exists */
    If(Select Exists(Select 1 From Reviewers Where ReviewerUserID = _ReviewerUserID And SubmissionID = _SubmissionID)) Then
      /* Update the Reviewer record */
      Update Reviewers
      Set ReviewStatusID = _ReviewStatusID,
          ReviewCompletionDate = CURRENT_DATE,
          LastUpdatedDate = CURRENT_DATE
      Where ReviewerUserID = _ReviewerUserID
        And SubmissionID = _SubmissionID;
      
      /* Get the total Reviewers count for the submision */
      Select Count(ReviewerUserID) Into _TotalReviewers
      From Reviewers
      Where SubmissionID = _SubmissionID;
      
      /* Get the reviews completed count for the submission */
      Select Count(ReviewerUserID) Into _ReviewCompleted
      From Reviewers
      Where SubmissionID = _SubmissionID
        And ReviewCompletionDate Is Not Null;
      
      /* Update the submission status if this is last review completion */
      If (_TotalReviewers - _ReviewCompleted = 0) Then
        Update Submissions
        Set SubmissionStatusID = 5
        Where SubmissionID = _SubmissionID;
      End If;
    Else
      Select 'ReviewerUserID and SubmissionID combination doesn''t exist' As 'Error';
    End If;
  Else
    Select 'ReviewStatusID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spReviewerViewSubmissions`$$
CREATE PROCEDURE `spReviewerViewSubmissions`(IN _UserID int,
                                             IN _Year int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Lists the submissions for a reviewer for a given year
   */
  Select s.SubmissionID,
         s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 ss.SubmissionStatus,
		 s.SubmissionDate,
         rs.ReviewStatus
  From Submissions s
    Inner Join Reviewers r
	  On r.SubmissionID = s.SubmissionID
    Inner Join ReviewStatus rs
      On rs.ReviewStatusID = r.ReviewStatusID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
	Left Join Users eu
	  On eu.UserID = s.EditorUserID
  Where r.ReviewerUserID = _UserID
    And Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

DROP PROCEDURE IF EXISTS `spSearchGetUsersEmail`$$
CREATE PROCEDURE `spSearchGetUsersEmail`(IN _EmailAddress varchar(30))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of users by email address
   */
  Set _EmailAddress = IfNull(_EmailAddress,'%');
  
  Select UserID,
         CONCAT(LastName,', ',FirstName) As 'FullName',
         EmailAddress,
         MemberCode,
         InstitutionAffiliation
  From Users
  Where EmailAddress Like CONCAT('%',_EmailAddress,'%')
  Group By UserID,
           EmailAddress,
           MemberCode,
           InstitutionAffiliation
  Order By LastName, FirstName;
END$$

DROP PROCEDURE IF EXISTS `spSearchGetUsersNames`$$
CREATE PROCEDURE `spSearchGetUsersNames`(IN _LastName varchar(30),
                                         IN _FirstName varchar(15))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the List of users by first and/or last name
   */
  Set _LastName = IfNull(_LastName,'%');
  Set _FirstName = IfNull(_FirstName,'%');
  
  Select UserID,
         CONCAT(LastName,', ',FirstName) As 'FullName',
         EmailAddress,
         MemberCode,
         InstitutionAffiliation
  From Users
  Where LastName Like CONCAT('%',_LastName,'%')
    Or FirstName Like CONCAT('%',_FirstName,'%')
  Group By UserID,
           EmailAddress,
           MemberCode,
           InstitutionAffiliation
  Order By LastName, FirstName;
END$$

DROP PROCEDURE IF EXISTS `spSearchIncidents`$$
CREATE PROCEDURE `spSearchIncidents`(IN _Title varchar(100),
                                     IN _Keyword varchar(20),
                                     IN _Author varchar(30),
                                     IN _Category varchar(25))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Searches Published Incidents from multiple input parameters
   */
  /* Sanitize the inputs */
  Set _Title = Replace(Replace(Concat('%', IfNull(_Title, '%'), '%'), '%%%', '%'), '%%', '%');
  Set _Keyword = Replace(Replace(Concat('%', IfNull(_Keyword, '%'), '%'), '%%%', '%'), '%%', '%');
  Set _Author = Replace(Replace(Concat('%', IfNull(_Author, '%'), '%'), '%%%', '%'), '%%', '%');
  Set _Category = Replace(Replace(Concat('%', IfNull(_Category, '%'), '%'), '%%%', '%'), '%%', '%');
  
  Select results.CriticalIncidentID,
         results.Year,
         results.IncidentTitle,
         results.Abstract,
         results.Keywords,
         results.Authors,
         results.Categories,
         results.FileMetaDataID
  From (
    Select pci.CriticalIncidentID,
           p.Year,
           pci.IncidentTitle,
           pci.Abstract,
           pci.Keywords,
           GROUP_CONCAT(Concat(pa.LastName, ' ,', pa.FirstName) SEPARATOR '; ') As 'Authors',
           GROUP_CONCAT(pc.Category SEPARATOR '; ') As 'Categories',
           pci.FileMetaDataID
    From Publications p
      Inner Join PublishedCriticalIncidents pci
        On pci.PublicationID = p.PublicationID
      Right Join PublishedIncidentsAuthors pia
        On pia.CriticalIncidentID = pci.CriticalIncidentID
      Right Join PublishedAuthors pa
        On pa.AuthorID = pia.AuthorID
      Right Join PublishedCriticalIncidentCategories pcic
        On pcic.CriticalIncidentID = pci.CriticalIncidentID
      Right Join PublicationCategories pc
        On pc.CategoryID = pcic.CategoryID
    Where pci.IncidentTitle Like _Title
      And pci.Keywords Like _Keyword
      And (pa.LastName Like _Author
        Or pa.FirstName Like _Author)
      And pc.Category Like _Category
    Group By pci.CriticalIncidentID,
             p.Year,
             pci.IncidentTitle,
             pci.Abstract,
             pci.Keywords) As results
  Group By results.CriticalIncidentID,
           results.Year,
           results.IncidentTitle,
           results.Abstract,
           results.Keywords,
           results.Authors,
           results.Categories
  Order By results.IncidentTitle Asc,
           results.Year Desc;
END$$

DROP PROCEDURE IF EXISTS `spSearchIncidentsSingleInput`$$
CREATE PROCEDURE `spSearchIncidentsSingleInput`(IN _SearchTerm varchar(100))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Searches Published Incidents from a single input parameter
   */
  /* Make sure there's something to search for */
  If ((_SearchTerm Is Not Null) And (Char_Length(_SearchTerm) > 0)) Then
    /* Make sure the SearchTerm has wildcard chars around it */
    Set _SearchTerm = Concat('%', _SearchTerm, '%');
    
    Select results.CriticalIncidentID,
           results.Year,
           results.IncidentTitle,
           results.Abstract,
           results.Keywords,
           results.Authors,
           results.Categories,
           results.FileMetaDataID
    From (
      Select pci.CriticalIncidentID,
             p.Year,
             pci.IncidentTitle,
             pci.Abstract,
             pci.Keywords,
             GROUP_CONCAT(Concat(pa.LastName, ' ,', pa.FirstName) SEPARATOR '; ') As 'Authors',
             GROUP_CONCAT(pc.Category SEPARATOR '; ') As 'Categories',
             pci.FileMetaDataID
      From Publications p
        Inner Join PublishedCriticalIncidents pci
          On pci.PublicationID = p.PublicationID
        Right Join PublishedIncidentsAuthors pia
          On pia.CriticalIncidentID = pci.CriticalIncidentID
        Right Join PublishedAuthors pa
          On pa.AuthorID = pia.AuthorID
        Right Join PublishedCriticalIncidentCategories pcic
          On pcic.CriticalIncidentID = pci.CriticalIncidentID
        Right Join PublicationCategories pc
          On pc.CategoryID = pcic.CategoryID
      Where p.Year Like _SearchTerm
        Or pci.IncidentTitle Like _SearchTerm
        Or pci.Abstract Like _SearchTerm
        Or pci.Keywords Like _SearchTerm
        Or pa.LastName Like _SearchTerm
        Or pa.FirstName Like _SearchTerm
        Or pc.Category Like _SearchTerm
      Group By pci.CriticalIncidentID,
               p.Year,
               pci.IncidentTitle,
               pci.Abstract,
               pci.Keywords) As results
    Group By results.CriticalIncidentID,
             results.Year,
             results.IncidentTitle,
             results.Abstract,
             results.Keywords,
             results.Authors,
             results.Categories
    Order By results.IncidentTitle Asc,
             results.Year Desc;
  End If;
END$$

DROP PROCEDURE IF EXISTS `spSubmissionAddToCategory`$$
CREATE PROCEDURE `spSubmissionAddToCategory`(IN _SubmissionID int,
                                             IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Connects a SubmissionID with a CategoryID
   */
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure CategoryID exists */
    If(Select Exists(Select 1 From Categories Where CategoryID = _CategoryID)) Then
      /* Make sure SubmissionID and CategoryID combination doesn't exist */
      If(Select Exists(Select 1 From SubmissionCategories Where SubmissionID = _SubmissionID And CategoryID = _CategoryID)) Then
        Select 'Submission already has that Category' As 'Error';
      Else
        /* Make the connection */
        Insert Into SubmissionCategories (SubmissionID,CategoryID)
        Values (_SubmissionID,_CategoryID);
      End If;
    Else
      Select 'CategoryID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spSubmissionAddToCategory`$$
CREATE PROCEDURE `spSubmissionAddToCategory`(IN _SubmissionID int,
                                             IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Connects a Submission to a Category
   */
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure CategoryID exists */
    If(Select Exists(Select 1 From Categories Where CategoryID = _CategoryID)) Then
      /* Make sure SubmissionID and CategoryID combination doesn't exist */
      If(Select Exists(Select 1 From SubmissionCategories Where SubmissionID = _SubmissionID And CategoryID = _CategoryID)) Then
        Select 'Submission already has that Category' As 'Error';
      Else
        /* Make the connection */
        Insert Into SubmissionCategories (SubmissionID,CategoryID)
        Values (_SubmissionID,_CategoryID);
      End If;
    Else
      Select 'CategoryID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spSubmissionAssignEditor`$$
CREATE PROCEDURE `spSubmissionAssignEditor`(IN _SubmissionID int,
                                            IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Assigns an editor UserID to a Submission
   */
  /* Make sure SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure UserID exists and is an editor */
	If(Select Exists(Select 1 From Users u Inner Join UserRoles ur On ur.UserID = u.UserID Where u.UserID = _UserID And ur.RoleID = 3)) Then
	  Update Submissions
	  Set EditorUserID = _UserID
	  Where SubmissionID = _SubmissionID;
      
      Select s.IncidentTitle,
             Concat(u.LastName, ', ', u.FirstName) As 'EditorFullName'
      From Submissions s
        Inner Join Users u
          On u.UserID = s.EditorUserID
      Where s.SubmissionID = _SubmissionID;
	Else
	  Select Concat('UserID ', _UserID, ' doesn''t exist or isn''t an editor') As 'Error';
	End If;
  Else
    Select Concat('SubmissionID ', _SubmissionID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spSubmissionGetFilesList`$$
CREATE PROCEDURE `spSubmissionGetFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file list for a SubmissionID
   */
  Select fmd.FileMetaDataID,
         fmd.FileName,
         fmd.FileSize,
         ft.FileType
  From SubmissionFiles sf
    Inner Join FileMetaData fmd
      On fmd.FileMetaDataID = sf.FileMetaDataID
    Inner Join FileTypes ft
      On ft.FileTypeID = fmd.FileTypeID
  Where sf.SubmissionID = _SubmissionID;
END$$

DROP PROCEDURE IF EXISTS `spSubmissionGetInfo`$$
CREATE PROCEDURE `spSubmissionGetInfo`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the info for a SubmissionID
   */
  Select s.IncidentTitle,
         s.Abstract,
         s.Keywords,
         s.SubmissionDate,
         s.SubmissionNumber,
         ss.SubmissionStatus
  From Submissions s
    Inner Join SubmissionStatus ss
      On ss.SubmissionStatusID = s.SubmissionStatusID
  Where s.SubmissionID = _SubmissionID;
END$$

DROP PROCEDURE IF EXISTS `spSubmissionRemoveCategory`$$
CREATE PROCEDURE `spSubmissionRemoveCategory`(IN _SubmissionID int,
                                              IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a SubmissionID from a CategoryID
   */
  Delete From SubmissionCategories
  Where SubmissionID = _SubmissionID
    And CategoryID = _CategoryID;
END$$

DROP PROCEDURE IF EXISTS `spUpdateAddress`$$
CREATE PROCEDURE `spUpdateAddress`(IN _AddressID int,
                                   IN _AddressTypeID int,
                                   IN _AddressLn1 varchar(100),
                                   IN _AddressLn2 varchar(100),
                                   IN _City varchar(30),
                                   IN _StateID int,
                                   IN _PostCode char(5),
                                   IN _PrimaryAddress tinyint)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing address
   */

  Declare _UserID int;
  
  /* Make sure the AddressID exists */
  If(Select Exists(Select 1 From Addresses Where AddressID = _AddressID)) Then
    /* Make sure the AddressTypeID exists */
    If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
      /* Make sure the StateID exists */
      If(Select Exists(Select 1 From States Where StateID = _StateID)) Then
        /* Default _PrimaryAddress to 0 if null is passed in */
        Set _PrimaryAddress = IFNULL(_PrimaryAddress, 0);
        
        /* Get the UserID for this address */
        Select UserID Into _UserID
        From Addresses
        Where AddressID = _AddressID;
        
        /* New PrimaryAddress, set others for user to 0 */
        If (_PrimaryAddress = 1) Then
          Update Addresses
          Set PrimaryAddress = 0
          Where UserID = _UserID;
        End If;
        
        /* Updates the address record */
        Update Addresses
        Set AddressTypeID = _AddressTypeID,
            AddressLn1 = _AddressLn1,
            AddressLn2 = _AddressLn2,
            City = _City,
            StateID = _StateID,
            PostCode = _PostCode,
            PrimaryAddress = _PrimaryAddress
        Where AddressID = _AddressID;
      Else
        Select 'Invalid StateID' As 'Error';
      End If;
    Else
      Select 'Invalid AddressTypeID' As 'Error';
    End If;
  Else
    Select 'Address doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdateAddressMakePrimary`$$
CREATE PROCEDURE `spUpdateAddressMakePrimary`(IN _AddressID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing address, sets it to be the primary
   */
  Declare _UserID int;
  
  /* Make sure the AddressID exists */
  If(Select Exists(Select 1 From Addresses Where AddressID = _AddressID)) Then
    /* Get the UserID for this address */
    Select UserID Into _UserID
    From Addresses
    Where AddressID = _AddressID;
    
    /* Set all user's addresses primary to 0 */
    Update Addresses
    Set PrimaryAddress = 0
    Where UserID = _UserID;
    
    /* Updates the address record */
    Update Addresses
    Set PrimaryAddress = 1
    Where AddressID = _AddressID;
  Else
    Select 'Address doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdateAddressType`$$
CREATE PROCEDURE `spUpdateAddressType`(IN _AddressTypeID int,
                                       IN _AddressType varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing address type
   */
  /* Make sure the AddressTypeID exists */
  If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
    /* Make sure the new PhoneType doesn't already exist */
    If(Select Exists(Select 1 From AddressTypes Where AddressType = _AddressType)) Then
      Select 'AddressType already exists' As 'Error';
    Else
      /* Update the Address Type record */
      Update AddressTypes
      Set AddressType = _AddressType
      Where AddressTypeID = _AddressTypeID;
    End If;
  Else
    Select 'AddressTypeID doesn''t exist' As 'Error';
  End If;
END$$

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

DROP PROCEDURE IF EXISTS `spUpdateArticleDates`$$
CREATE PROCEDURE `spUpdateArticleDates`(IN _Year int,
                                        IN _AuthorFirstSubmissionStartDate date,
                                        IN _AuthorFirstSubmissionDueDate date,
                                        IN _FirstReviewStartDate date,
                                        IN _FirstReviewDueDate date,
                                        IN _AuthorSecondSubmissionStartDate date,
                                        IN _AuthorSecondSubmissionDueDate date,
                                        IN _SecondReviewStartDate date,
                                        IN _SecondReviewDueDate date,
                                        IN _AuthorPublicationSubmissionStartDate date,
                                        IN _AuthorPublicationSubmissionDueDate date,
                                        IN _PublicationDate date)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates the available Article Dates for a year
   */
  Update SystemSettings_ArticleDates
  Set AuthorFirstSubmissionStartDate = _AuthorFirstSubmissionStartDate,
      AuthorFirstSubmissionDueDate = _AuthorFirstSubmissionDueDate,
      FirstReviewStartDate = _FirstReviewStartDate,
      FirstReviewDueDate = _FirstReviewDueDate,
      AuthorSecondSubmissionStartDate = _AuthorSecondSubmissionStartDate, 
      AuthorSecondSubmissionDueDate = _AuthorSecondSubmissionDueDate, 
      SecondReviewStartDate = _SecondReviewStartDate, 
      SecondReviewDueDate = _SecondReviewDueDate, 
      AuthorPublicationSubmissionStartDate = _AuthorPublicationSubmissionStartDate, 
      AuthorPublicationSubmissionDueDate = _AuthorPublicationSubmissionDueDate, 
      PublicationDate = _PublicationDate
  Where Year = _Year;
END$$

DROP PROCEDURE IF EXISTS `spUpdateCategory`$$
CREATE PROCEDURE `spUpdateCategory`(IN _CategoryID int,
                                    IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing Category
   */
  /* Make sure the Category doesn't exist */
  If(Select Exists(Select 1 From Categories Where Category = _Category And CategoryID != _CategoryID)) Then
    Select 'Category already exists' As 'Error';
  Else
    Update Categories
    Set Category = _Category
    Where CategoryID = _CategoryID;
  End If;
END$$

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

DROP PROCEDURE IF EXISTS `spUpdateEmailSettings`$$
CREATE PROCEDURE `spUpdateEmailSettings`(IN _SettingID int,
                                         IN _SettingName varchar(200),
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
   * Purpose    : Updates an existing Email nagging profile
   */
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

DROP PROCEDURE IF EXISTS `spUpdateFileMetaData`$$
CREATE PROCEDURE `spUpdateFileMetaData`(IN _FileMetaDataID int,
                                        IN _FileTypeID int,
                                        IN _FileMime varchar(200),
                                        IN _sFileName varchar(200),
                                        IN _sFileSize int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the FileMetaData record for a FileMetaDataID, also deletes the associated FileData records
   */
  /* Make sure the FileMetaDataID exists */
  If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
    /* Deletes the Contents records */
    Delete From FileData
    Where FileMetaDataID = _FileMetaDataID;
    
    /* Set's the new meta data info */
    Update FileMetaData
    Set FileTypeID = _FileTypeID,
        FileMime = _FileMime,
        FileName = _sFileName,
        FileSize = _sFileSize
    Where FileMetaDataID = _FileMetaDataID;
  Else
    Select 'FileMetaDataID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdatePhoneMakePrimary`$$
CREATE PROCEDURE `spUpdatePhoneMakePrimary`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing phone number, sets it to be the primary
   */
  Declare _UserID int;
  
  /* Make sure the PhoneNumberID exists */
  If(Select Exists(Select 1 From PhoneNumbers Where PhoneNumberID = _PhoneNumberID)) Then
    /* Get the UserID for this phone */
    Select UserID Into _UserID
    From PhoneNumbers
    Where PhoneNumberID = _PhoneNumberID;
    
    /* Set all user's phones primary to 0 */
    Update PhoneNumbers
    Set PrimaryPhone = 0
    Where UserID = _UserID;
    
    /* Updates the phone record */
    Update PhoneNumbers
    Set PrimaryPhone = 1
    Where PhoneNumberID = _PhoneNumberID;
  Else
    Select 'Phone number doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdatePhoneNumber`$$
CREATE PROCEDURE `spUpdatePhoneNumber`(IN _PhoneNumberID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
                                       IN _PrimaryPhone tinyint)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing phone number for a user
   */

  Declare _UserID int;
  
  /* Make sure the PhoneNumberID exists */
  If(Select Exists(Select 1 From PhoneNumbers Where PhoneNumberID = _PhoneNumberID)) Then
    /* Make sure the PhoneTypeID exists */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
      /* Default _PrimaryPhone to 0 if null is passed in */
      Set _PrimaryPhone = IFNULL(_PrimaryPhone, 0);
        
        /* Get the UserID for this phone number */
        Select UserID Into _UserID
        From PhoneNumbers
        Where PhoneNumberID = _PhoneNumberID;
      
      /* New PrimaryPhone, set others for user to 0 */
      If (_PrimaryPhone = 1) Then
        Update PhoneNumbers
        Set PrimaryPhone = 0
        Where UserID = _UserID;
      End If;
      
      /* Update the phone number record */
      Update PhoneNumbers
      Set PhoneTypeID = _PhoneTypeID,
          PhoneNumber = _PhoneNumber,
          PrimaryPhone = _PrimaryPhone
      Where PhoneNumberID = _PhoneNumberID;
    Else
      Select 'Invalid PhoneTypeID' As 'Error';
    End If;
  Else
    Select 'Phone Number doesn''t exist' As 'Error';
  End If;
END$$

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

DROP PROCEDURE IF EXISTS `spUpdatePublication`$$
CREATE PROCEDURE `spUpdatePublication`(IN _Year int,
                                       IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a Publication record for a year
   */
  /* Make sure the year exists */
  If(Select Exists(Select 1 From Publications Where Year = _Year)) Then
    /* Make sure the FileMetaDataID exists */
    If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
      Update Publications
      Set FileMetaDataID = _FileMetaDataID
      Where Year = _Year;
    Else
      Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('Publication for year ', _Year, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdatePublicationCategory`$$
CREATE PROCEDURE `spUpdatePublicationCategory`(IN _CategoryID int,
                                               IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a category for published incidents
   */
  If(Select Exists(Select 1 From PublicationCategories Where Category = _Category And CategoryID != _CategoryID)) Then
    Select Concat('Category "', _Category, '" already exists') As 'Error';
  Else
    Update PublicationCategories
    Set Category = _Category
    Where CategoryID = _CategoryID;
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdatePublishedAuthor`$$
CREATE PROCEDURE `spUpdatePublishedAuthor`(IN _AuthorID int,
                                           IN _FirstName varchar(15),
                                           IN _LastName varchar(30),
                                           IN _EmailAddress varchar(200),
                                           IN _InstitutionAffiliation varchar(100))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a Published Author record
   */
  /* Make sure the AuthorID exists */
  If(Select Exists(Select 1 From PublishedAuthors Where AuthorID = _AuthorID)) Then
    Update PublishedAuthors
    Set FirstName = _FirstName,
        LastName = _LastName,
        EmailAddress = _EmailAddress,
        InstitutionAffiliation = _InstitutionAffiliation
    Where AuthorID = _AuthorID;
  Else
    Select Concat('AuthorID ', _AuthorID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdatePublishedCriticalIncident`$$
CREATE PROCEDURE `spUpdatePublishedCriticalIncident`(IN _CriticalIncidentID int,
                                                     IN _PublicationID int,
                                                     IN _IncidentTitle varchar(150),
                                                     IN _Abstract varchar(5000),
                                                     IN _Keywords varchar(5000),
                                                     IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a Published Critical Incident record
   */
  /* Make sure the CriticalIncidentID exists */
  If(Select Exists(Select 1 From CriticalIncidents Where CriticalIncidentID = _CriticalIncidentID)) Then
    /* Make sure the FileMetaDataID exists */
    If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
      /* Make sure the PublicationID exists */
      If(Select Exists(Select 1 From Publications Where PublicationID = _PublicationID)) Then
        Update CriticalIncidents
        Set PublicationID = _PublicationID,
            IncidentTitle = _IncidentTitle,
            Abstract = _Abstract,
            Keywords = _Keywords,
            FileMetaDataID = _FileMetaDataID
        Where CriticalIncidentID = _CriticalIncidentID;
      Else
        Select Concat('PublicationID ', _PublicationID, ' doesn''t exist') As 'Error';
      End If;
    Else
      Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
    End If;
  Else
    Select Concat('CriticalIncidentID ', _CriticalIncidentID, ' doesn''t exist') As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdateSubmissionStatus`$$
CREATE PROCEDURE `spUpdateSubmissionStatus`(IN _SubmissionID int,
                                            IN _SubmissionStatusID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates an existing Submissions' status:
   SubmissionStatusID 2 : Editor Assigned, DON'T USE, spSubmissionAssignEditor will do this automatically
   SubmissionStatusID 3 : Editor Updated
   SubmissionStatusID 4 : Reviewers Assigned
   SubmissionStatusID 5 : Reviews Completed, DON'T USE, use spReviewerUpdateReviewStatus procedure instead
   SubmissionStatusID 6 : Editor Reviewed
   SubmissionStatusID 7 : Ready for Publish
   SubmissionStatusID 8 : Revision Needed
   */
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the SubmissionStatusID exists */
    If(Select Exists(Select 1 From SubmissionStatus Where SubmissionStatusID = _SubmissionStatusID)) Then
      /* Update the Submission record */
      Update Submissions
      Set SubmissionStatusID = _SubmissionStatusID
      Where SubmissionID = _SubmissionID;
    Else
      Select 'SubmissionStatusID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdateUserEmailAddress`$$
CREATE PROCEDURE `spUpdateUserEmailAddress`(IN _UserID int,
                                            IN _EmailAddress varchar(200))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the EmailAddress for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set NewEmailAddress = LOWER(_EmailAddress),
        EmailVerificationGUID = REPLACE(UUID(),'-',''),
        NewEmailAddressCreateDate = CURRENT_DATE,
        EmailStatusID = 1
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdateUserInfo`$$
CREATE PROCEDURE `spUpdateUserInfo`(IN _UserID int,
                                    IN _FirstName varchar(15),
                                    IN _LastName varchar(30),
                                    IN _MemberCode varchar(20),
                                    IN _InstitutionAffiliation varchar(100))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates the info for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set FirstName = _FirstName,
        LastName = _LastName,
        MemberCode = _MemberCode,
        InstitutionAffiliation = _InstitutionAffiliation
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUpdateUserPassword`$$
CREATE PROCEDURE `spUpdateUserPassword`(IN _UserID int,
                                        IN _Password varchar(50))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the password for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set PasswordHash = SHA1(_Password)
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUserAddRequestEditor`$$
CREATE PROCEDURE `spUserAddRequestEditor`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the RequestBecomeEditor for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From UserRoles Where UserID = _UserID And RoleID = 3)) Then
      Select 'UserID is already an editor' As 'Error';
    Else
      Update Users
      Set RequestBecomeEditor = 1
      Where UserID = _UserID;
    End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUserAddRequestReviewer`$$
CREATE PROCEDURE `spUserAddRequestReviewer`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the RequestBecomeReviewer for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    If(Select Exists(Select 1 From UserRoles Where UserID = _UserID And RoleID = 2)) Then
      Select 'UserID is already a reviewer' As 'Error';
    Else
      Update Users
      Set RequestBecomeReviewer = 1
      Where UserID = _UserID;
    End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUserAddRole`$$
CREATE PROCEDURE `spUserAddRole`(IN _UserID int,
                                 IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Connects a UserID with a RoleID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure RoleID exists */
    If(Select Exists(Select 1 From Roles Where RoleID = _RoleID)) Then
      /* Make sure UserID and RoleID combination doesn't exist */
      If(Select Exists(Select 1 From UserRoles Where UserID = _UserID And RoleID = _RoleID)) Then
        Select 'User already has that role' As 'Error';
      Else
        /* Make the connection */
        Insert Into UserRoles (UserID,RoleID)
        Values (_UserID,_RoleID);
      End If;
    Else
      Select 'RoleID doesn''t exist' As 'Error';
    End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUserRemoveRequestEditor`$$
CREATE PROCEDURE `spUserRemoveRequestEditor`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the RequestBecomeEditor for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set RequestBecomeEditor = 0
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUserRemoveRequestReviewer`$$
CREATE PROCEDURE `spUserRemoveRequestReviewer`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Update the RequestBecomeReviewer for a UserID
   */
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
    Set RequestBecomeReviewer = 0
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

DROP PROCEDURE IF EXISTS `spUserRemoveRole`$$
CREATE PROCEDURE `spUserRemoveRole`(IN _UserID int,
                                    IN _RoleID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a UserID with a RoleID
   */
  Delete From UserRoles
  Where UserID = _UserID
    And RoleID = _RoleID;
END$$

DROP PROCEDURE IF EXISTS `spVerifyEmailAddress`$$
CREATE PROCEDURE `spVerifyEmailAddress`(IN _GUID varchar(32))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Marks a user's email address as valid
   */
  Declare _UserID int;
  
  /* Get the UserID from the GUID */
  Select UserID Into _UserID
  From Users
  Where EmailVerificationGUID = _GUID;
  
  Set _UserID = IfNull(_UserID, -1);
  
  If (_UserID > -1) Then
    /* Copy the new email address into the EmailAddress field and clear out the changing fields */
    Update Users
    Set EmailAddress = NewEmailAddress,
        EmailStatusID = 3,
        EmailVerificationGUID = Null,
        NewEmailAddressCreateDate = Null
    Where UserID = _UserID;

    /* Clear out the NewEmailAddress field */
    Update Users
    Set NewEmailAddress = Null
    Where UserID = _UserID;
  End If;
  
  /* Return the UserID */
  Select _UserID As 'UserID';
END$$

DELIMITER ;