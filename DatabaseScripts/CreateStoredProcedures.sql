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
											IN _PreviousSubmissionID int)
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
							 PreviousSubmissionID,
							 SubmissionDate,
							 SubmissionStatusID)
	Values (_IncidentTitle,
	        _Abstract,
			_KeyWords,
			_PreviousSubmissionID,
			CURRENT_DATE,
			1);
	
	Set _SubmissionID = last_insert_id();
	
	Select InstitutionAffiliation Into _InstitutionAffiliation
	From Users
	Where UserID = _UserID;
	
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
      /* Update the phone number record */
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

DELIMITER ;