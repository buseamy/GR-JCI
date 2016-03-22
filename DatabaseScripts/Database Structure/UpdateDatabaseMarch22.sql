ALTER TABLE `Users` DROP `ReviewerNumber`;
ALTER TABLE `Users` ADD `RequestBecomeReviewer` TINYINT(1) NOT NULL DEFAULT '0' AFTER `CreateDate`;
ALTER TABLE `Users` ADD `RequestBecomeEditor` TINYINT(1) NOT NULL DEFAULT '0' AFTER `CreateDate`;

Drop Table SystemSettings_ArticleDates;

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