/* Create ISYS489 JCI database tables */
DROP DATABASE IF EXISTS gr_jci;
CREATE DATABASE gr_jci;

USE gr_jci;

DROP USER IF EXISTS XamppUser@localhost;
CREATE USER 'XamppUser'@'localhost' IDENTIFIED BY 'XamppPassword';
GRANT EXECUTE ON gr_jci.* TO 'XamppUser'@'localhost';

/*Create Roles Table*/
CREATE TABLE Roles
(
RoleID int NOT NULL AUTO_INCREMENT,
RoleTitle varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (RoleID)
);

/*Create EmailStatus table*/
CREATE TABLE EmailStatus
(
EmailStatusID int NOT NULL AUTO_INCREMENT,
EmailStatus varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (EmailStatusID)
);

/*Create States table*/
CREATE TABLE States
(
StateID int NOT NULL AUTO_INCREMENT,
Abbr char(2) NOT NULL UNIQUE,
Name varchar(15) NOT NULL UNIQUE, 
PRIMARY KEY (StateID)
);

/*Create SubmissionStatus table*/
CREATE TABLE SubmissionStatus
(
SubmissionStatusID int NOT NULL AUTO_INCREMENT,
SubmissionStatus varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (SubmissionStatusID)
);

/*Create Categories table*/
CREATE TABLE Categories
(
CategoryID int NOT NULL AUTO_INCREMENT,
Category varchar(20) NOT NULL,
PRIMARY KEY (CategoryID)
);

/*Create Announcements table*/
CREATE TABLE Announcements
(
AnnouncementID int NOT NULL AUTO_INCREMENT,
Title varchar(100) NOT NULL UNIQUE,
Message varchar(10000) NOT NULL,
CreateDate date NOT NULL,
ExpireDate date,
PRIMARY KEY (AnnouncementID)
);

/*Create AccouncementRoles table*/
CREATE TABLE AccouncementRoles
(
AnnouncementID int NOT NULL,
RoleID int NOT NULL,
PRIMARY KEY (AnnouncementID,RoleID),
FOREIGN KEY (AnnouncementID) REFERENCES Announcements(AnnouncementID),
FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

/*Create ReviewStatus table*/
CREATE TABLE ReviewStatus
(
ReviewStatusID int NOT NULL AUTO_INCREMENT,
ReviewStatus varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (ReviewStatusID)
);

/*Create PhoneTypes table*/
CREATE TABLE PhoneTypes
(
PhoneTypeID int NOT NULL AUTO_INCREMENT,
PhoneType varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (PhoneTypeID)
);

/*Create AddressTypes table*/
CREATE TABLE AddressTypes
(
AddressTypeID int NOT NULL AUTO_INCREMENT,
AddressType varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (AddressTypeID)
);

/*Create Users table*/
CREATE TABLE Users
(
UserID int NOT NULL AUTO_INCREMENT,
EmailAddress varchar(200) NOT NULL UNIQUE,
PasswordHash varchar(200) NOT NULL,
FirstName varchar(15) NOT NULL,
LastName varchar(30) NOT NULL,
MemberCode varchar(20),
ValidMembership tinyint(1) NOT NULL DEFAULT '0',
InstitutionAffiliation varchar(100),
EmailStatusID int NOT NULL,
NewEmailAddress varchar(200),
NewEmailAddressCreateDate date,
EmailVerificationGUID varchar(32),
Active tinyint(1) NOT NULL DEFAULT '1',
NonActiveNote varchar(500) NULL,
CreateDate date NOT NULL,
RequestBecomeReviewer tinyint(1) NOT NULL DEFAULT '0',
RequestBecomeEditor tinyint(1) NOT NULL DEFAULT '0',
PRIMARY KEY (UserID),
FOREIGN KEY (EmailStatusID) REFERENCES EmailStatus(EmailStatusID)
);

/*Create UserMembershipHistory table*/
CREATE TABLE UserMembershipHistory
(
UserID int NOT NULL AUTO_INCREMENT,
Year int NOT NULL,
ValidMembership tinyint(1) NOT NULL,
PRIMARY KEY (UserID,Year),
FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

/*Create PhoneNumbers table*/
CREATE TABLE PhoneNumbers
(
PhoneNumberID int NOT NULL AUTO_INCREMENT,
UserID int NOT NULL,
PhoneTypeID int NOT NULL,
PhoneNumber char(10) NOT NULL,
PrimaryPhone tinyint(1) NOT NULL DEFAULT '0',
CreateDate date NOT NULL,
PRIMARY KEY (PhoneNumberID),
FOREIGN KEY (UserID) REFERENCES Users(UserID),
FOREIGN KEY (PhoneTypeID) REFERENCES PhoneTypes(PhoneTypeID)
);

/*Create Addresses table*/
CREATE TABLE Addresses
(
AddressID int NOT NULL AUTO_INCREMENT,
UserID int NOT NULL,
AddressTypeID int NOT NULL,
AddressLn1 varchar(100) NOT NULL,
AddressLn2 varchar(100),
City varchar(30) NOT NULL,
StateID int NOT NULL,
PostCode char(5) NOT NULL,
PrimaryAddress tinyint(1) NOT NULL DEFAULT '0',
CreateDate date NOT NULL,
PRIMARY KEY (AddressID),
FOREIGN KEY (UserID) REFERENCES Users(UserID),
FOREIGN KEY (StateID) REFERENCES States(StateID),
FOREIGN KEY (AddressTypeID) REFERENCES AddressTypes(AddressTypeID)
);

/*Create UserRoles table*/
CREATE TABLE UserRoles
(
UserID int NOT NULL,
RoleID int NOT NULL,
PRIMARY KEY (UserID, RoleID),
FOREIGN KEY (UserID) REFERENCES Users(UserID), 
FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

/*Create Submissions table*/
CREATE TABLE Submissions
(
SubmissionID int NOT NULL AUTO_INCREMENT,
EditorUserID int,
IncidentTitle varchar(150) NOT NULL,
Abstract varchar(5000),
SubmissionNumber TINYINT NOT NULL,
SubmissionDate date NOT NULL,
SubmissionStatusID int NOT NULL,
PreviousSubmissionID int,
Keywords varchar(5000),
PRIMARY KEY (SubmissionID),
FOREIGN KEY (SubmissionStatusID) REFERENCES SubmissionStatus(SubmissionStatusID),
FOREIGN KEY (EditorUserID) REFERENCES Users(UserID)
);

/*Create AuthorsSubmission table*/
CREATE TABLE AuthorsSubmission
(
UserID int NOT NULL,
SubmissionID int NOT NULL,
InstitutionAffiliation varchar(100),
PrimaryContact TINYINT NOT NULL DEFAULT '0',
AuthorSeniority TINYINT NOT NULL,
PRIMARY KEY (UserID, SubmissionID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

/*Create Reviewers table*/
CREATE TABLE Reviewers
(
ReviewerUserID int NOT NULL,
SubmissionID int NOT NULL,
ReviewCompletionDate date,
ReviewStatusID int NOT NULL,
CreateDate date NOT NULL,
LastUpdatedDate date NOT NULL,
PRIMARY KEY (ReviewerUserID, SubmissionID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (ReviewerUserID) REFERENCES Users(UserID),
FOREIGN KEY (ReviewStatusID) REFERENCES ReviewStatus(ReviewStatusID)
);

/*Create SubmissionCategories table*/
CREATE TABLE SubmissionCategories
(
SubmissionID int NOT NULL,
CategoryID int NOT NULL,
PRIMARY KEY (SubmissionID, CategoryID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

/*Create FileTypes table*/
CREATE TABLE FileTypes
(
FileTypeID int NOT NULL AUTO_INCREMENT,
RoleID int NOT NULL,
FileType varchar(30) NOT NULL,
PRIMARY KEY (FileTypeID),
FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

/*Create FileData table*/
CREATE TABLE FileMetaData
(
FileMetaDataID int NOT NULL AUTO_INCREMENT,
FileTypeID int NOT NULL,
FileMime varchar(200) NOT NULL,
FileName varchar(200) NOT NULL,
FileSize int NOT NULL,
PRIMARY KEY (FileMetaDataID),
FOREIGN KEY (FileTypeID) REFERENCES FileTypes(FileTypeID)
);

/*Create FileData table*/
CREATE TABLE FileData
(
FileDataID int NOT NULL AUTO_INCREMENT,
FileMetaDataID int NOT NULL,
SequenceNumber tinyint NOT NULL,
FileContents BLOB NOT NULL,
PRIMARY KEY (FileDataID),
FOREIGN KEY (FileMetaDataID) REFERENCES FileMetaData(FileMetaDataID)
);

/*Create ReviewerFiles table*/
CREATE TABLE ReviewerFiles
(
ReviewerFileID int NOT NULL AUTO_INCREMENT,
ReviewerUserID int NOT NULL,
SubmissionID int NOT NULL,
FileMetaDataID int NOT NULL,
PRIMARY KEY (ReviewerFileID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (ReviewerUserID) REFERENCES Users(UserID),
FOREIGN KEY (FileMetaDataID) REFERENCES FileMetaData(FileMetaDataID)
);

/*Create SubmissionFiles table*/
CREATE TABLE SubmissionFiles
(
SubmissionFileID int NOT NULL AUTO_INCREMENT,
SubmissionID int NOT NULL,
FileMetaDataID int NOT NULL,
PRIMARY KEY (SubmissionFileID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (FileMetaDataID) REFERENCES FileMetaData(FileMetaDataID)
);

/* Create the PublishedAuthors table */
CREATE TABLE PublishedAuthors (
AuthorID int NOT NULL AUTO_INCREMENT,
FirstName VarChar(15) NOT NULL,
LastName VarChar(30) NOT NULL,
EmailAddress VarChar(200) NOT NULL,
InstitutionAffiliation varchar(100),
PRIMARY KEY (AuthorID)
);

/* Create the Publications table */
CREATE TABLE Publications (
PublicationID int NOT NULL AUTO_INCREMENT,
Year int NOT NULL UNIQUE,
FileMetaDataID int NOT NULL,
PRIMARY KEY (PublicationID),
FOREIGN KEY (FileMetaDataID) REFERENCES FileMetaData(FileMetaDataID)
);

/* Create the PublishedCriticalIncidents table */
CREATE TABLE PublishedCriticalIncidents (
CriticalIncidentID int NOT NULL AUTO_INCREMENT,
PublicationID int NOT NULL,
IncidentTitle VarChar(150) NOT NULL,
Abstract VarChar(5000) NOT NULL,
Keywords VarChar(5000) NOT NULL,
FileMetaDataID int NOT NULL,
PRIMARY KEY (CriticalIncidentID),
FOREIGN KEY (PublicationID) REFERENCES Publications(PublicationID),
FOREIGN KEY (FileMetaDataID) REFERENCES FileMetaData(FileMetaDataID)
);

/* Create the PublishedIncidentsAuthors table */
CREATE TABLE PublishedIncidentsAuthors (
AuthorID int NOT NULL,
CriticalIncidentID int NOT NULL,
PRIMARY KEY (AuthorID,CriticalIncidentID),
FOREIGN KEY (AuthorID) REFERENCES PublishedAuthors(AuthorID),
FOREIGN KEY (CriticalIncidentID) REFERENCES PublishedCriticalIncidents(CriticalIncidentID)
);

/* Create the PublicationCategories table */
CREATE TABLE PublicationCategories (
CategoryID int NOT NULL AUTO_INCREMENT,
Category varchar(20) NOT NULL UNIQUE,
PRIMARY KEY (CategoryID)
);

/* Create the PublishedCriticalIncidentCategories table */
CREATE TABLE PublishedCriticalIncidentCategories (
CategoryID int NOT NULL,
CriticalIncidentID int NOT NULL,
PRIMARY KEY (CategoryID,CriticalIncidentID),
FOREIGN KEY (CategoryID) REFERENCES PublicationCategories(CategoryID),
FOREIGN KEY (CriticalIncidentID) REFERENCES PublishedCriticalIncidents(CriticalIncidentID)
);

/*Create SystemSettings_Email table*/
CREATE TABLE SystemSettings_Email
(
SettingID int AUTO_INCREMENT,
SettingName varchar(200) NOT NULL UNIQUE,
AuthorNagEmailDays int NOT NULL,
AuthorSubjectTemplate varchar(50) NOT NULL,
AuthorBodyTemplate varchar(10000) NOT NULL,
ReviewerNagEmailDays int NOT NULL,
ReviewerSubjectTemplate varchar(50) NOT NULL,
ReviewerBodyTemplate varchar(10000) NOT NULL,
Active tinyint(1) NOT NULL DEFAULT '1',
PRIMARY KEY (SettingID)
);

/*Create SystemSettings_ArticleDates table*/
CREATE TABLE SystemSettings_ArticleDates
(
Year int NOT NULL,
AuthorFirstSubmissionStartDate date NOT NULL,
AuthorFirstSubmissionDueDate date NOT NULL,
FirstReviewStartDate date NOT NULL,
FirstReviewDueDate date NOT NULL,
AuthorSecondSubmissionStartDate date NOT NULL,
AuthorSecondSubmissionDueDate date NOT NULL,
SecondReviewStartDate date NOT NULL,
SecondReviewDueDate date NOT NULL,
AuthorPublicationSubmissionStartDate date NOT NULL,
AuthorPublicationSubmissionDueDate date NOT NULL,
PublicationDate date NOT NULL,
PRIMARY KEY (Year)
);

/* Create the SystemSettings_DateDefinitions table */
CREATE TABLE SystemSettings_DateDefinitions (
ID int NOT NULL,
DefinitionText varchar(100) NOT NULL,
PRIMARY KEY (ID)
);

/* Populate the SystemSettings_DateDefinitions */
Insert Into SystemSettings_DateDefinitions (ID, DefinitionText)
Values (1,'Author First Submissions'),
       (2,'Editor Reviewing First Submissions'),
       (3,'Reviewers Reviewing First Submissions'),
       (4,'Editors Post-Reviewing First Submissions'),
       (5,'Author Second Submissions'),
       (6,'Editor Reviewing Second Submissions'),
       (7,'Reviewers Reviewing Second Submissions'),
       (8,'Editors Post-Reviewing Second Submissions'),
       (9,'Author Publication Submissions'),
       (10,'Publication Producing');

/* Populate the ArticleDates */
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
Values (2016,
        '2015-11-16',
		'2016-5-16',
		'2016-5-30',
		'2016-6-20',
		'2016-6-27',
		'2016-7-18',
		'2016-7-25',
		'2016-8-15',
		'2016-8-29',
		'2016-9-19',
		'2016-10-31');

/*Populate the States table*/
Insert Into States (Name,Abbr)
Values ('Alabama','AL'),
       ('Alaska','AK'),
       ('Arizona','AZ'),
       ('Arkansas','AR'),
       ('California','CA'),
       ('Colorado','CO'),
       ('Connecticut','CT'),
       ('Delaware','DE'),
       ('Florida','FL'),
       ('Georgia','GA'),
       ('Hawaii','HI'),
       ('Idaho','ID'),
       ('Illinois','IL'),
       ('Indiana','IN'),
       ('Iowa','IA'),
       ('Kansas','KS'),
       ('Kentucky','KY'),
       ('Louisiana','LA'),
       ('Maine','ME'),
       ('Maryland','MD'),
       ('Massachusetts','MA'),
       ('Michigan','MI'),
       ('Minnesota','MN'),
       ('Mississippi','MS'),
       ('Missouri','MO'),
       ('Montana','MT'),
       ('Nebraska','NE'),
       ('Nevada','NV'),
       ('New Hampshire','NH'),
       ('New Jersey','NJ'),
       ('New Mexico','NM'),
       ('New York','NY'),
       ('North Carolina','NC'),
       ('North Dakota','ND'),
       ('Ohio','OH'),
       ('Oklahoma','OK'),
       ('Oregon','OR'),
       ('Pennsylvania','PA'),
       ('Rhode Island','RI'),
       ('South Carolina','SC'),
       ('South Dakota','SD'),
       ('Tennessee','TN'),
       ('Texas','TX'),
       ('Utah','UT'),
       ('Vermont','VT'),
       ('Virginia','VA'),
       ('Washington','WA'),
       ('West Virginia','WV'),
       ('Wisconsin','WI'),
       ('Wyoming','WY');

/*Populate the Roles table*/
Insert Into Roles (RoleTitle)
Values ('Author'),
       ('Reviewer'),
	   ('Editor'),
	   ('Assistant Editor'),
	   ('General Assistant'),
	   ('Public');

/*Populate the Roles table*/
Insert Into FileTypes (RoleID,FileType)
Values (1,'Cover Letter'),
       (1,'Incident'),
       (1,'Summary'),
       (1,'Teaching Notes'),
       (1,'Memo'),
       (2,'Incident'),
       (2,'Summary'),
       (2,'Teaching Notes'),
       (2,'Reviewer Form'),
	   (3,'Publication'),
	   (3,'Published Incident');

/*Populate the EmailStatus table*/
Insert Into EmailStatus (EmailStatus)
Values ('Initiated'),
       ('Expired'),
       ('Accepted');

/*Populate the PhoneTypes table*/
Insert Into PhoneTypes (PhoneType)
Values ('Home'),
       ('Main'),
       ('Mobile'),
       ('Work');

/*Populate the AddressTypes table*/
Insert Into AddressTypes (AddressType)
Values ('Home'),
       ('Main'),
       ('Work');

/*Populate the SubmissionStatus table*/
Insert Into SubmissionStatus (SubmissionStatus)
Values ('Submitted'),
       ('Editor Assigned'),
       ('Editor Updated'),
       ('Reviewers Assigned'),
	   ('Reviews Completed'),
       ('Editor Reviewed'),
       ('Ready for Publish'),
       ('Revision Needed');

/*Populate the ReviewStatus table*/
Insert Into ReviewStatus (ReviewStatus)
Values ('Reviewing'),
       ('Revision Needed'),
       ('Publishable');

/*Create a test user table*/
Insert Into Users (EmailAddress,PasswordHash,FirstName,LastName,InstitutionAffiliation,EmailStatusID,CreateDate)
Values ('Author1@user.com',SHA1('Password'),'Author','One','Ferris',3,CURRENT_DATE),
       ('Author2@user.com',SHA1('Password'),'Author','Two','MSU',3,CURRENT_DATE),
       ('Author3@user.com',SHA1('Password'),'Author','Three','UofM',3,CURRENT_DATE),
       ('Reviewer1@user.com',SHA1('Password'),'Reviewer','One','Ferris',3,CURRENT_DATE),
       ('Reviewer2@user.com',SHA1('Password'),'Reviewer','Two','Ferris',3,CURRENT_DATE),
       ('Editor1@user.com',SHA1('Password'),'Editor','One','Ferris',3,CURRENT_DATE),
       ('AllRoles@user.com',SHA1('Password'),'All','Roles','Ferris',3,CURRENT_DATE);

/* Link the users to roles */
Insert Into UserRoles (UserID, RoleID)
Values (1,1),
       (2,1),
       (2,2),
	   (3,1),
	   (4,1),
	   (4,2),
	   (5,1),
	   (5,2),
	   (6,1),
	   (6,3),
	   (7,1),
	   (7,2),
	   (7,3);
/* Populate the submissions table */
Insert Into Submissions (IncidentTitle,Abstract,SubmissionNumber,SubmissionDate,SubmissionStatusID,Keywords,EditorUserID)
Values ('Title 1','Some 1bstract',1,CURRENT_DATE,4,'Key,words',6),
       ('Title 2','Some other abstract',1,CURRENT_DATE,4,'Other,words',7),
       ('Title 3','Another abstract',1,CURRENT_DATE,2,'Other,words,additional',Null);


/* Link authors to submissions */
Insert Into AuthorsSubmission (UserID,SubmissionID,InstitutionAffiliation,PrimaryContact,AuthorSeniority)
Values (1,1,'Ferris',1,1),
       (2,2,'MSU',1,1),
	   (3,2,'UofM',0,2),
	   (1,3,'Ferris',0,1),
	   (2,3,'MSU',1,2),
	   (3,3,'UofM',0,3);

/* Link some reviewers */
Insert Into Reviewers (ReviewerUserID,SubmissionID,ReviewStatusID,CreateDate,LastUpdatedDate)
Values (4,1,1,CURRENT_DATE,CURRENT_DATE),
       (4,2,1,CURRENT_DATE,CURRENT_DATE),
       (5,1,1,CURRENT_DATE,CURRENT_DATE);