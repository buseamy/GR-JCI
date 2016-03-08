USE gr_jci;

DELIMITER $$

/* Gets the list of types of addresses */
DROP PROCEDURE IF EXISTS `spGetAddressTypes`$$
CREATE PROCEDURE `spGetAddressTypes`()
DETERMINISTIC
BEGIN
  Select AddressTypeID, AddressType
  From AddressTypes
  Order By AddressType;
END$$

/* Gets the list of types of phone numbers */
DROP PROCEDURE IF EXISTS `spGetPhoneTypes`$$
CREATE PROCEDURE `spGetPhoneTypes`()
DETERMINISTIC
BEGIN
  Select PhoneTypeID, PhoneType
  From PhoneTypes
  Order By PhoneType;
END$$

/* Gets the list of states */
DROP PROCEDURE IF EXISTS `spGetStates`$$
CREATE PROCEDURE `spGetStates`()
DETERMINISTIC
BEGIN
  Select StateID, CONCAT(Abbr,' - ',Name) As FullStateName
  From States
  Order By Abbr;
END$$

/* Get the UserID (or -1) for the EmailAddress/Password combination */
DROP PROCEDURE IF EXISTS `spGetUserID`$$
CREATE PROCEDURE `spGetUserID`(IN _EmailAddress VarChar(200), IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  Declare _UserID Int;

  Select u.UserID Into _UserID
  From Users u
  Where u.EmailAddress = LOWER(_EmailAddress)
    And u.PasswordHash = SHA1(_Password);
	
  Select IfNull(_UserID, -1) As 'UserID';
END$$

/* Gets the roles associated with a UserID */
DROP PROCEDURE IF EXISTS `spGetUserRoles`$$
CREATE PROCEDURE `spGetUserRoles`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select r.RoleTitle
  From UserRoles ur
    Inner Join Roles r
      On r.RoleID = ur.RoleID
  Where ur.UserID = _UserID;
END$$

/* Get the UserID (or -1) for the EmailAddress/Password combination */
DROP PROCEDURE IF EXISTS `spLoginGetUserID`$$
CREATE PROCEDURE `spLoginGetUserID`(IN _EmailAddress VarChar(200), IN _Password VarChar(50))
DETERMINISTIC
BEGIN
  Declare _UserID Int;

  Select u.UserID Into _UserID
  From Users u
  Where u.EmailAddress = LOWER(_EmailAddress)
    And u.PasswordHash = SHA1(_Password)
	And u.Active = 1
	And u.EmailStatusID != 2;
	
  Select IfNull(_UserID, -1) As 'UserID';
END$$

/* Get the list of users, both active and inactive in alphbetical order */
DROP PROCEDURE IF EXISTS `spGetUsersList`$$
CREATE PROCEDURE `spGetUsersList`()
DETERMINISTIC
BEGIN
  Select u.UserID,
         u.EmailAddress,
		 CONCAT(u.FirstName,' ',u.LastName) As 'Name',
		 GROUP_CONCAT(r.RoleTitle) As 'Roles',
		 IF(u.Active, 'Y', 'N') As 'IsActive'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
	Inner Join Roles r
	  On r.RoleID = ur.RoleID
  Order By u.LastName,
           u.FirstName,
		   u.UserID;
END$$

/* Inserts a new user then returns the UserID & EmailVerificationGUID */
DROP PROCEDURE IF EXISTS `spCreateUser`$$
CREATE PROCEDURE `spCreateUser`(IN _EmailAddress varchar(200),
                                IN _Password varchar(50),
								IN _FirstName varchar(15),
								IN _LastName varchar(30))
DETERMINISTIC
BEGIN
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
    Select u.UserID,
           u.EmailVerificationGUID
    From Users u
    Where u.UserID = _UserID;
  End If;  
END$$

/* Inserts a new address for a user */
DROP PROCEDURE IF EXISTS `spCreateAddress`$$
CREATE PROCEDURE `spCreateAddress`(IN _UserID int,
                                   IN _AddressTypeID int,
                                   IN _AddressLn1 varchar(100),
								   IN _AddressLn2 varchar(100),
								   IN _City varchar(30),
								   IN _StateID int,
								   IN _PostCode char(5),
								   IN _PrimaryAddress tinyint
) DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the AddressTypeID exists */
    If(Select Exists(Select 1 From AddressTypes Where AddressTypeID = _AddressTypeID)) Then
	  /* Make sure the StateID exists */
	  If(Select Exists(Select 1 From States Where StateID = _StateID)) Then
	    /* Default _PrimaryAddress to 0 if null is passed in */
        Set _PrimaryAddress = IFNULL(_PrimaryAddress, 0);
		
		/* New PrimaryAddress, set others for user to 0 */
	    If (_PrimaryAddress = 1) Then
		  Update Addresses
		  Set PrimaryAddress = 0
		  Where UserID = _UserID;
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

/* Inserts a new phone number for a user */
DROP PROCEDURE IF EXISTS `spCreatePhoneNumber`$$
CREATE PROCEDURE `spCreatePhoneNumber`(IN _UserID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
								       IN _PrimaryPhone tinyint
) DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the PhoneTypeID exists */
    If(Select Exists(Select 1 From PhoneTypes Where PhoneTypeID = _PhoneTypeID)) Then
	  /* Default _PrimaryPhone to 0 if null is passed in */
      Set _PrimaryPhone = IFNULL(_PrimaryPhone, 0);
	  
	  /* New PrimaryAddress, set others for user to 0 */
	  If (_PrimaryPhone = 1) Then
		Update PhoneNumbers
		Set PrimaryPhone = 0
		Where UserID = _UserID;
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

/* Inserts a new phone number type */
DROP PROCEDURE IF EXISTS `spCreatePhoneType`$$
CREATE PROCEDURE `spCreatePhoneType`(IN _PhoneType varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the Phone Type doesn't exist */
  If(Select Exists(Select 1 From PhoneTypes Where PhoneType = _PhoneType)) Then
    Select 'Phone type already exists' As 'Error';
  Else
    Insert Into PhoneTypes(PhoneType)
	Values (_PhoneType);
	
	Select last_insert_id() As 'PhoneTypeID';
  End If; 
END$$

/* Inserts a new address type */
DROP PROCEDURE IF EXISTS `spCreateAddressType`$$
CREATE PROCEDURE `spCreateAddressType`(IN _AddressType varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the address type doesn't exist */
  If(Select Exists(Select 1 From AddressTypes Where AddressType = _AddressType)) Then
    Select 'Address type already exists' As 'Error';
  Else
    Insert Into AddressTypes(AddressType)
	Values (_AddressType);
	
	Select last_insert_id() As 'AddressTypeID';
  End If; 
END$$

/* Updates the user's account to mark them as disabled */
DROP PROCEDURE IF EXISTS `spDisableUser`$$
CREATE PROCEDURE `spDisableUser`(IN _UserID int, IN _NonActiveNote varchar(5000))
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set Active = 0, NonActiveNote = _NonActiveNote
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If; 
END$$

/* Updates the user's account to re-enable them */
DROP PROCEDURE IF EXISTS `spEnableUser`$$
CREATE PROCEDURE `spEnableUser`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set Active = 1, NonActiveNote = Null
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If; 
END$$

/* Deletes a user's address */
DROP PROCEDURE IF EXISTS `spDeleteAddress`$$
CREATE PROCEDURE `spDeleteAddress`(IN _AddressID int)
DETERMINISTIC
BEGIN
  Delete From Addresses
  Where AddressID = _AddressID;
END$$

/* Deletes a user's phone number */
DROP PROCEDURE IF EXISTS `spDeletePhoneNumber`$$
CREATE PROCEDURE `spDeletePhoneNumber`(IN _PhoneNumberID int)
DETERMINISTIC
BEGIN
  Delete From PhoneNumbers
  Where PhoneNumberID = _PhoneNumberID;
END$$

/* Marks a user's email address as valid */
DROP PROCEDURE IF EXISTS `spUpdateAcceptEmailAddress`$$
CREATE PROCEDURE `spUpdateAcceptEmailAddress`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Copy the new email address into the EmailAddress field */
  Update Users
  Set EmailAddress = NewEmailAddress
  Where UserID = _UserID;
  
  /* Mark the record's email address as valid */
  Update Users
  Set EmailStatusID = 3,
      NewEmailAddress = Null,
	  EmailVerificationGUID = Null,
	  NewEmailAddressCreateDate = Null
  Where UserID = _UserID;
END$$

/* Marks a user's email address as invalid */
DROP PROCEDURE IF EXISTS `spUpdateRejectEmailAddress`$$
CREATE PROCEDURE `spUpdateRejectEmailAddress`(IN _UserID int)
DETERMINISTIC
BEGIN
  Update Users
  Set EmailStatusID = 2
  Where UserID = _UserID;
END$$

/* Gets the List of available roles */
DROP PROCEDURE IF EXISTS `spGetRoles`$$
CREATE PROCEDURE `spGetRoles`()
DETERMINISTIC
BEGIN
  Select RoleID,
         RoleTitle
  From Roles
  Order By RoleTitle;
END$$

/* Connects a UserID with a RoleID */
DROP PROCEDURE IF EXISTS `spUserAddRole`$$
CREATE PROCEDURE `spUserAddRole`(IN _UserID int, IN _RoleID int)
DETERMINISTIC
BEGIN
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

/* For every user create membership history record */
DROP PROCEDURE IF EXISTS `spYearlyAddMembershipHistory`$$
CREATE PROCEDURE `spYearlyAddMembershipHistory`()
DETERMINISTIC
BEGIN
  /* Delete the current year's entries */
  Delete From UserMembershipHistory
  Where Year = YEAR(CURRENT_DATE);
  
  /* Insert the new records for every user for this year */
  Insert Into UserMembershipHistory (UserID,Year,ValidMembership)
  Select UserID, YEAR(CURRENT_DATE), ValidMembership
  From Users;
END$$

/* Update the password for a UserID */
DROP PROCEDURE IF EXISTS `spUpdateUserPassword`$$
CREATE PROCEDURE `spUpdateUserPassword`(IN _UserID int, IN _Password varchar(50))
DETERMINISTIC
BEGIN
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set PasswordHash = SHA1(_Password)
	Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

/* Update the EmailAddress for a UserID */
DROP PROCEDURE IF EXISTS `spUpdateUserEmailAddress`$$
CREATE PROCEDURE `spUpdateUserEmailAddress`(IN _UserID int, IN _EmailAddress varchar(50))
DETERMINISTIC
BEGIN
  /* Make sure UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    Update Users
	Set NewEmailAddress = LOWER(_EmailAddress),
	    EmailVerificationGUID = REPLACE(UUID(),'-',''),
		NewEmailAddressCreateDate = CURRENT_DATE,
		EmailStatusID = 1
	Where UserID = _UserID;
	
	/* Get the new GUID for email verification */
	Select EmailVerificationGUID
    From Users
    Where UserID = _UserID;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

/* Expire user's EmailAddress change attempts */
DROP PROCEDURE IF EXISTS `spUpdateExpireUsersEmailAddressChange`$$
CREATE PROCEDURE `spUpdateExpireUsersEmailAddressChange`()
DETERMINISTIC
BEGIN
  Update Users
  Set EmailStatusID = 2
  Where EmailStatusID = 1
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 3 DAY;
END$$

/* Removes a UserID with a RoleID */
DROP PROCEDURE IF EXISTS `spUserRemoveRole`$$
CREATE PROCEDURE `spUserRemoveRole`(IN _UserID int, IN _RoleID int)
DETERMINISTIC
BEGIN
  Delete From UserRoles
  Where UserID = _UserID
    And RoleID = _RoleID;
END$$

/* Creates a new submission record and links the author to it */
DROP PROCEDURE IF EXISTS `spAuthorCreateSubmission`$$
CREATE PROCEDURE `spAuthorCreateSubmission`(IN _UserID int,
                                            IN _IncidentTitle varchar(150),
										    IN _Abstract varchar(5000),
										    IN _KeyWords varchar(5000),
										    IN _PreviousSubmissionID int,
										    IN _SubmissionNumber TINYINT)
DETERMINISTIC
BEGIN

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

/* Updates the info for a UserID */
DROP PROCEDURE IF EXISTS `spUpdateUserInfo`$$
CREATE PROCEDURE `spUpdateUserInfo`(IN _UserID int,
                                    IN _FirstName varchar(15),
									IN _LastName varchar(30),
									IN _MemberCode varchar(20),
									IN _InstitutionAffiliation varchar(100))
DETERMINISTIC
BEGIN
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

/* Updates an existing address */
DROP PROCEDURE IF EXISTS `spUpdateAddress`$$
CREATE PROCEDURE `spUpdateAddress`(IN _AddressID int,
                                   IN _AddressTypeID int,
                                   IN _AddressLn1 varchar(100),
								   IN _AddressLn2 varchar(100),
								   IN _City varchar(30),
								   IN _StateID int,
								   IN _PostCode char(5),
								   IN _PrimaryAddress tinyint
) DETERMINISTIC
BEGIN

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

/* Updates an existing phone number for a user */
DROP PROCEDURE IF EXISTS `spUpdatePhoneNumber`$$
CREATE PROCEDURE `spUpdatePhoneNumber`(IN _PhoneNumberID int,
                                       IN _PhoneTypeID int,
                                       IN _PhoneNumber char(10),
								       IN _PrimaryPhone tinyint
) DETERMINISTIC
BEGIN

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

/* Updates an existing phone type */
DROP PROCEDURE IF EXISTS `spUpdatePhoneType`$$
CREATE PROCEDURE `spUpdatePhoneType`(IN _PhoneTypeID int,
                                     IN _PhoneType varchar(20)
) DETERMINISTIC
BEGIN
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

/* Updates an existing address type */
DROP PROCEDURE IF EXISTS `spUpdateAddressType`$$
CREATE PROCEDURE `spUpdateAddressType`(IN _AddressTypeID int,
                                       IN _AddressType varchar(20)
) DETERMINISTIC
BEGIN
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

/* Updates an existing Submissions' status */
DROP PROCEDURE IF EXISTS `spUpdateSubmissionStatus`$$
CREATE PROCEDURE `spUpdateSubmissionStatus`(IN _SubmissionID int,
                                            IN _SubmissionStatusID int
) DETERMINISTIC
BEGIN
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

/* Creates a new announcement */
DROP PROCEDURE IF EXISTS `spCreateAnnouncement`$$
CREATE PROCEDURE `spCreateAnnouncement`(IN _Title varchar(100),
                                        IN _Message varchar(10000),
										IN _ExpireDate date
) DETERMINISTIC
BEGIN
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

/* Updates an existing announcement */
DROP PROCEDURE IF EXISTS `spUpdateAnnouncement`$$
CREATE PROCEDURE `spUpdateAnnouncement`(IN _AnnouncementID int,
                                        IN _Title varchar(100),
                                        IN _Message varchar(10000),
										IN _ExpireDate date
) DETERMINISTIC
BEGIN
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

/* Deletes an existing announcement */
DROP PROCEDURE IF EXISTS `spRemoveAnnouncement`$$
CREATE PROCEDURE `spRemoveAnnouncement`(IN _AnnouncementID int) DETERMINISTIC
BEGIN
  /* Remove the Accouncement from the roles */
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID;
  
  /* Remove the Accouncement itself */
  Delete From Announcements
  Where AnnouncementID = _AnnouncementID;
END$$

/* Connects an AnnouncementID with a RoleID */
DROP PROCEDURE IF EXISTS `spAnnouncementAddRole`$$
CREATE PROCEDURE `spAnnouncementAddRole`(IN _AnnouncementID int, IN _RoleID int)
DETERMINISTIC
BEGIN
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

/* Removes an AnnouncementID with a RoleID */
DROP PROCEDURE IF EXISTS `spAnnouncementRemoveRole`$$
CREATE PROCEDURE `spAnnouncementRemoveRole`(IN _AnnouncementID int, IN _RoleID int)
DETERMINISTIC
BEGIN
  Delete From AccouncementRoles
  Where AnnouncementID = _AnnouncementID
    And RoleID = _RoleID;
END$$

/* Gets a list of announcements for a UserID */
DROP PROCEDURE IF EXISTS `spGetUserAnnouncements`$$
CREATE PROCEDURE `spGetUserAnnouncements`(IN _UserID int)
DETERMINISTIC
BEGIN
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
  Where ur.UserID = _UserID
  Group By a.Title,
           a.Message,
           a.CreateDate,
		   a.ExpireDate
  Order By a.CreateDate,
           a.Title;
END$$

/* Lists the submissions for an author for a given year */
DROP PROCEDURE IF EXISTS `spAuthorViewSubmissions`$$
CREATE PROCEDURE `spAuthorViewSubmissions`(IN _UserID int, IN _Year int)
DETERMINISTIC
BEGIN
  Select s.IncidentTitle,
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

/* Lists the submissions for a reviewer for a given year */
DROP PROCEDURE IF EXISTS `spReviewerViewSubmissions`$$
CREATE PROCEDURE `spReviewerViewSubmissions`(IN _UserID int, IN _Year int)
DETERMINISTIC
BEGIN
  Select s.IncidentTitle,
         If(Not s.EditorUserID Is Null, CONCAT(eu.LastName,', ',eu.FirstName),'') As 'EditorName',
		 ss.SubmissionStatus,
		 s.SubmissionDate
  From Submissions s
    Inner Join Reviewers r
	  On r.SubmissionID = s.SubmissionID
	Inner Join SubmissionStatus ss
	  On ss.SubmissionStatusID = s.SubmissionStatusID
	Left Join Users eu
	  On eu.UserID = s.EditorUserID
  Where r.ReviewerUserID = _UserID
    And Year(s.SubmissionDate) = _Year
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

/* Lists the submissions for an editor for a given year */
DROP PROCEDURE IF EXISTS `spEditorViewSubmissions`$$
CREATE PROCEDURE `spEditorViewSubmissions`(IN _Year int)
DETERMINISTIC
BEGIN
  Select s.IncidentTitle,
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
  Order By s.SubmissionDate,
           s.IncidentTitle;
END$$

/* Assigns an editor UserID to a Submission */
DROP PROCEDURE IF EXISTS `spSubmissionAssignEditor`$$
CREATE PROCEDURE `spSubmissionAssignEditor`(IN _SubmissionID int, IN _UserID int)
DETERMINISTIC
BEGIN
  /* Make sure the SubmissionID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
    /* Make sure the UserID exists */
	If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
	  Update Submissions
	  Set EditorUserID = _UserID
	  Where SubmissionID = _SubmissionID;
	Else
	  Select 'User doesn''t exist' As 'Error';
	End If;
  Else
    Select 'Submission doesn''t exist' As 'Error';
  End If;
END$$

/* Updates an existing submission record */
DROP PROCEDURE IF EXISTS `spAuthorUpdateSubmission`$$
CREATE PROCEDURE `spAuthorUpdateSubmission`(IN _SubmissionID int,
                                            IN _IncidentTitle varchar(150),
										    IN _Abstract varchar(5000),
										    IN _KeyWords varchar(5000))
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
  
	/* Update the submission record */
	Update Submissions
	Set IncidentTitle = _IncidentTitle,
	    Abstract = _Abstract,
		Keywords = _KeyWords
	Where SubmissionID = _SubmissionID;
  Else
    Select 'SubmissionID doesn''t exist' As 'Error';
  End If;
END$$

/* Adds a Reviewer UserID to an existing Submission */
DROP PROCEDURE IF EXISTS `spReviewerAddToSubmission`$$
CREATE PROCEDURE `spReviewerAddToSubmission`(IN _UserID int,
                                             IN _SubmissionID int)
DETERMINISTIC
BEGIN
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
    /* Make sure the SubmissionID exists */
    If(Select Exists(Select 1 From Submissions Where SubmissionID = _SubmissionID)) Then
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
	Else
	  Select 'SubmissionID doesn''t exist' As 'Error';
	End If;
  Else
    Select 'UserID doesn''t exist' As 'Error';
  End If;
END$$

/* Gets the list of active UserID and FullNames who are Editors */
DROP PROCEDURE IF EXISTS `spGetUsersEditorsList`$$
CREATE PROCEDURE `spGetUsersEditorsList`()
DETERMINISTIC
BEGIN
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
  Where ur.RoleID = 3
    And u.Active = 1
	And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

/* Gets the list of active UserID and FullNames who are Reviewers */
DROP PROCEDURE IF EXISTS `spGetUsersReviewersList`$$
CREATE PROCEDURE `spGetUsersReviewersList`()
DETERMINISTIC
BEGIN
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
  Where ur.RoleID = 2
    And u.Active = 1
	And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

/* Gets the list of active UserID and FullNames who are Authors */
DROP PROCEDURE IF EXISTS `spGetUsersAuthorsList`$$
CREATE PROCEDURE `spGetUsersAuthorsList`()
DETERMINISTIC
BEGIN
  Select u.UserID, CONCAT(u.LastName,', ',u.FirstName) As 'FullName'
  From Users u
    Inner Join UserRoles ur
	  On ur.UserID = u.UserID
  Where ur.RoleID = 1
    And u.Active = 1
	And u.EmailStatusID != 2
  Order By u.LastName, u.FirstName;
END$$

/* Deletes all expired announcements */
DROP PROCEDURE IF EXISTS `spRemoveExpiredAnnouncements`$$
CREATE PROCEDURE `spRemoveExpiredAnnouncements`() DETERMINISTIC
BEGIN

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

/* Gets the list of types of files for a role */
DROP PROCEDURE IF EXISTS `spGetFileTypes`$$
CREATE PROCEDURE `spGetFileTypes`(IN _RoleID int)
DETERMINISTIC
BEGIN
  Select FileTypeID, FileType
  From FileTypes
  Where RoleID = _RoleID
  Order By FileType;
END$$

/* Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID */
DROP PROCEDURE IF EXISTS `spCreateSubmissionFileMetaData`$$
CREATE PROCEDURE `spCreateSubmissionFileMetaData`(IN _SubmissionID int,
                                                  IN _FileTypeID int,
												  IN _FileMime varchar(200),
												  IN _sFileName varchar(200),
												  IN _sFileSize int)
DETERMINISTIC
BEGIN
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

/* Creates the Meta Data record for a file to be uploaded returns the new FileMetaDataID */
DROP PROCEDURE IF EXISTS `spCreateReviewerFileMetaData`$$
CREATE PROCEDURE `spCreateReviewerFileMetaData`(IN _SubmissionID int,
												IN _ReviewerUserID int,
                                                IN _FileTypeID int,
												IN _FileMime varchar(200),
												IN _sFileName varchar(200),
												IN _sFileSize int)
DETERMINISTIC
BEGIN
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

/* Gets the info for a SubmissionID  */
DROP PROCEDURE IF EXISTS `spSubmissionGetInfo`$$
CREATE PROCEDURE `spSubmissionGetInfo`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
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

/* Gets the file list for a SubmissionID  */
DROP PROCEDURE IF EXISTS `spSubmissionGetFilesList`$$
CREATE PROCEDURE `spSubmissionGetFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
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

/* Gets the file list for a ReviewerUserID & SubmissionID  */
DROP PROCEDURE IF EXISTS `spReviewerGetFilesList`$$
CREATE PROCEDURE `spReviewerGetFilesList`(IN _ReviewerUserID int, IN _SubmissionID int)
DETERMINISTIC
BEGIN
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

/* Gets the file info record for a FileMetaDataID  */
DROP PROCEDURE IF EXISTS `spGetFileInfo`$$
CREATE PROCEDURE `spGetFileInfo`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  Select FileName, FileMime, FileSize
  From FileMetaData
  Where FileMetaDataID = _FileMetaDataID;
END$$

/* Gets the file content records for a FileMetaDataID  */
DROP PROCEDURE IF EXISTS `spGetFileContents`$$
CREATE PROCEDURE `spGetFileContents`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  Select FileContents
  From FileData
  Where FileMetaDataID = _FileMetaDataID
  Order By SequenceNumber;
END$$

/* Inserts a file content record for a FileMetaDataID  */
DROP PROCEDURE IF EXISTS `spCreateFileContent`$$
CREATE PROCEDURE `spCreateFileContent`(IN _FileMetaDataID int,
                                       IN _FileContent blob,
									   IN _SequenceNumber int)
DETERMINISTIC
BEGIN
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

/* Update the FileMetaData record for a FileMetaDataID, also deletes the associated FileData records */
DROP PROCEDURE IF EXISTS `spUpdateFileMetaData`$$
CREATE PROCEDURE `spUpdateFileMetaData`(IN _FileMetaDataID int,
                                        IN _FileTypeID int,
										IN _FileMime varchar(200),
										IN _sFileName varchar(200),
										IN _sFileSize int)
DETERMINISTIC
BEGIN
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

/* Inserts a new Category */
DROP PROCEDURE IF EXISTS `spCreateCategory`$$
CREATE PROCEDURE `spCreateCategory`(IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the Category doesn't exist */
  If(Select Exists(Select 1 From Categories Where Category = _Category)) Then
    Select 'Category already exists' As 'Error';
  Else
    Insert Into Categories(Category)
	Values (_Category);
	
	Select last_insert_id() As 'CategoryID';
  End If; 
END$$

/* Updates an existing Category */
DROP PROCEDURE IF EXISTS `spUpdateCategory`$$
CREATE PROCEDURE `spUpdateCategory`(IN _CategoryID int,
                                    IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the Category doesn't exist */
  If(Select Exists(Select 1 From Categories Where Category = _Category And CategoryID != _CategoryID)) Then
    Select 'Category already exists' As 'Error';
  Else
    Update Categories
	Set Category = _Category
	Where CategoryID = _CategoryID;
  End If;
END$$

/* Connects a SubmissionID with a CategoryID */
DROP PROCEDURE IF EXISTS `spSubmissionAddToCategory`$$
CREATE PROCEDURE `spSubmissionAddToCategory`(IN _SubmissionID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
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

/* Removes a SubmissionID from a CategoryID */
DROP PROCEDURE IF EXISTS `spSubmissionRemoveCategory`$$
CREATE PROCEDURE `spSubmissionRemoveCategory`(IN _SubmissionID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
  Delete From SubmissionCategories
  Where SubmissionID = _SubmissionID
    And CategoryID = _CategoryID;
END$$

/* Gets the List of users by first and/or last name */
DROP PROCEDURE IF EXISTS `spSearchGetUsersNames`$$
CREATE PROCEDURE `spSearchGetUsersNames`(IN _LastName varchar(30),
                                         IN _FirstName varchar(15))
DETERMINISTIC
BEGIN
  Set _LastName = IfNull(_LastName,'%');
  Set _FirstName = IfNull(_FirstName,'%');
  
  Select UserID,
         CONCAT(LastName,', ',FirstName) As 'FullName',
		 EmailAddress,
		 MemberCode,
		 InstitutionAffiliation
  From Users
  Where LastName Like CONCAT('%',_LastName,'%')
    And FirstName Like CONCAT('%',_FirstName,'%')
  Group By UserID,
           EmailAddress,
		   MemberCode,
		   InstitutionAffiliation
  Order By LastName, FirstName;
END$$

/* Gets the List of users by email address */
DROP PROCEDURE IF EXISTS `spSearchGetUsersEmail`$$
CREATE PROCEDURE `spSearchGetUsersEmail`(IN _EmailAddress varchar(30))
DETERMINISTIC
BEGIN
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

/* Gets the list of all Announcements */
DROP PROCEDURE IF EXISTS `spGetAllAnnouncements`$$
CREATE PROCEDURE `spGetAllAnnouncements`()
DETERMINISTIC
BEGIN
  Select a.Title,
         GROUP_CONCAT(r.RoleTitle) As 'Roles',
         a.CreateDate,
		 IfNull(a.ExpireDate,'') As 'ExpireDate'
  From Announcements a
    Inner Join AccouncementRoles ar
	  On ar.AnnouncementID = a.AnnouncementID
	Inner Join Roles r
	  On r.RoleID = ar.RoleID
	Order By CreateDate,
	         Title;
END$$

/* Lists the feedback files for a submission */
DROP PROCEDURE IF EXISTS `spAuthorGetSubmissionReviewerFilesList`$$
CREATE PROCEDURE `spAuthorGetSubmissionReviewerFilesList`(IN _SubmissionID int)
DETERMINISTIC
BEGIN
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
  Where rf.SubmissionID = _SubmissionID
    And r.ReviewCompletionDate Is Not Null;
END$$

/* Update a reviewer's record to change the status */
DROP PROCEDURE IF EXISTS `spReviewerUpdateReviewStatus`$$
CREATE PROCEDURE `spReviewerUpdateReviewStatus`(IN _ReviewerUserID int,
                                                IN _SubmissionID int,
												IN _ReviewStatusID int)
DETERMINISTIC
BEGIN
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

/* Creates a new Email nagging profile */
DROP PROCEDURE IF EXISTS `spCreateEmailSettings`$$
CREATE PROCEDURE `spCreateEmailSettings`(IN _SettingName varchar(200),
                                         IN _AuthorNagDays int,
                                         IN _AuthorSubjectTemplate varchar(50),
										 IN _AuthorBodyTemplate varchar(1000),
										 IN _ReviewerNagDays int,
                                         IN _ReviewerSubjectTemplate varchar(50),
										 IN _ReviewerBodyTemplate varchar(1000))
DETERMINISTIC
BEGIN
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