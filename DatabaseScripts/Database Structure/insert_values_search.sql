USE gr_jci;


insert into filetypes (RoleID, FileType)
values (3, 'Publication');

insert into filetypes (RoleID, FileType)
values (3, 'Published Incident');

insert into FileMetaData (FileTypeID, FileMime,FileName, FileSize)
values (10, 'application/text' ,'journal1' , 0 );

insert into FileMetaData (FileTypeID, FileMime,FileName, FileSize)
values (11, 'application/text' ,'case1' , 0 );

insert into Publications (Year,FileMetaDataID) 
values (2016,5);


insert into PublishedCriticalIncidents(PublicationID, IncidentTitle, Abstract, Keywords, FileMetaDataID)
values (4, 'testcase' , 'testAbstract' , 'testKeyword' , 6);

insert into PublishedAuthors(FirstName, LastName, EmailAddress, InstitutionAffiliation)
values ('Author', 'One' ,'Author1@user.com', 'Ferris');

insert into PublishedIncidentsAuthors(AuthorID, CriticalIncidentID)
values (1, 3);

insert into PublicationCategories (Category)
values ('testcategory');

insert into PublishedCriticalIncidentCategories (CategoryID, CriticalIncidentID)
values (1,3);
