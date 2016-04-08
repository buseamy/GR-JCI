Use gr_jci;

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