/* Create ISYS489 JCI database tables */
DROP DATABASE IF EXISTS gr_jci;
CREATE DATABASE gr_jci;

USE gr_jci;

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
Title varchar(100),
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
ReviewerNumber varchar(3),
InstitutionAffiliation varchar(100),
EmailStatusID int NOT NULL,
NewEmailAddress varchar(200),
EmailVerificationGUID varchar(32),
Active tinyint(1) NOT NULL DEFAULT '1',
NonActiveNote varchar(500) NULL,
CreateDate date NOT NULL,
PRIMARY KEY (UserID),
FOREIGN KEY (EmailStatusID) REFERENCES EmailStatus(EmailStatusID)
);

/*Create UserMembershipHistory table*/
CREATE TABLE UserMembershipHistory
(
UserID int NOT NULL AUTO_INCREMENT,
Year TINYINT NOT NULL,
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
CaseTitle varchar(150) NOT NULL,
Abstract varchar(5000),
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
FileDataID int NOT NULL,
PRIMARY KEY (ReviewerFileID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (ReviewerUserID) REFERENCES Users(UserID),
FOREIGN KEY (FileDataID) REFERENCES FileData(FileDataID)
);

/*Create SubmissionFiles table*/
CREATE TABLE SubmissionFiles
(
SubmissionFileID int NOT NULL AUTO_INCREMENT,
SubmissionID int NOT NULL,
FileDataID int NOT NULL,
PRIMARY KEY (SubmissionFileID),
FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID),
FOREIGN KEY (FileDataID) REFERENCES FileData(FileDataID)
);

/*Create SystemSettings_CaseDates table*/
CREATE TABLE SystemSettings_CaseDates
(
Year int NOT NULL,
SeasonStartDate date NOT NULL,
FirstSubmissionEndDate date NOT NULL,
FirstReviewEndDate date NOT NULL,
SecondSubmissionEndDate date NOT NULL,
SecondReviewEndDate date NOT NULL, 
PublicationSubmissionEndDate date NOT NULL,
PRIMARY KEY (Year)
);

/*Create SystemSettings_Email table*/
CREATE TABLE SystemSettings_Email
(
SettingID int AUTO_INCREMENT,
AuthorNagEmailDays int NOT NULL,
AuthorSubjectTemplate varchar(50) NOT NULL,
AuthorBodyTemplate varchar(1000) NOT NULL,
ReviewerNagEmailDays int NOT NULL,
ReviewerSubjectTemplate varchar(50) NOT NULL,
ReviewerBodyTemplate varchar(1000) NOT NULL,
Active tinyint(1) NOT NULL DEFAULT '1',
PRIMARY KEY (SettingID)
);

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
	   ('General Assistant');

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
       ('Reviwers Assigned'),
       ('Reviews Completed');

/*Populate the ReviewStatus table*/
Insert Into ReviewStatus (ReviewStatus)
Values ('Reviewing'),
       ('Revision Needed'),
       ('Publishable');

/*Create a test user table*/
Insert Into Users (EmailAddress,PasswordHash,FirstName,LastName,InstitutionAffiliation,EmailStatusID,CreateDate)
Values ('test@user.com',SHA1('Password'),'Test','User','Ferris',3,CURRENT_DATE);

Insert Into UserRoles (UserID, RoleID)
Values (1,1),
       (1,2);