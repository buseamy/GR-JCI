Use gr_jci;

Insert Into Announcements (Title, Message,CreateDate,ExpireDate)
Values ('Public Announcement','Testing public announcement',CURRENT_DATE,Null),
       ('Author Announcement','Testing author only',CURRENT_DATE,Null),
       ('Reviewer Announcement','Testing reviewer only',CURRENT_DATE,Null),
       ('Author & Reviewer Announcement','Testing authors & reviewers',CURRENT_DATE,'2016-10-31');

Insert Into AccouncementRoles (AnnouncementID,RoleID)
Values (1,6), /* public */
       (2,1), /* author only */
       (3,2), /* reviewer only */
       (4,1),(4,2);