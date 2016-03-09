USE gr_jci;

Drop Table SystemSettings_CaseDates;
Drop Table SystemSettings_Email;

/*Create SystemSettings_ArticleDates table*/
CREATE TABLE SystemSettings_ArticleDates
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