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