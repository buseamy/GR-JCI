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
Year int NOT NULL,
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