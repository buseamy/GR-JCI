Use gr_jci;

Insert Into SystemSettings_Email (SettingName,
                                  AuthorNagEmailDays,
                                  AuthorSubjectTemplate,
                                  AuthorBodyTemplate,
                                  ReviewerNagEmailDays,
                                  ReviewerSubjectTemplate,
                                  ReviewerBodyTemplate,
                                  Active)
Values ('Initial Settings',
        3,
        'Reminder from JCI, critical incident submissions due soon',
        '{0},<br />&nbsp;&nbsp;The Journal of Critical Incidents are only accepting article submissions for a couple more days, please log in and submit yours.<br /><br />&nbsp;&nbsp;To login please visit <a href="http://www.sfcrjci.org">http://www.sfcrjci.org</a>',
        3,
        'Reminder from JCI, you have a review outstanding',
        '{0},<br />&nbsp;&nbsp;You have the following articles awaiting your review:<br />&nbsp;&nbsp;{1}<br /><br />&nbsp;&nbsp;To login please visit <a href="http://www.sfcrjci.org">http://www.sfcrjci.org</a>',
        1);