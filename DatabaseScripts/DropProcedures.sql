USE gr_jci;

DROP PROCEDURE IF EXISTS `spGetAddressTypes`;
DROP PROCEDURE IF EXISTS `spGetPhoneTypes`;
DROP PROCEDURE IF EXISTS `spGetStates`;
DROP PROCEDURE IF EXISTS `spGetUserID`;
DROP PROCEDURE IF EXISTS `spGetUserRoles`;
DROP PROCEDURE IF EXISTS `spLoginGetUserID`;
DROP PROCEDURE IF EXISTS `spGetUsersList`;
DROP PROCEDURE IF EXISTS `spCreateUser`;
DROP PROCEDURE IF EXISTS `spCreateAddress`;
DROP PROCEDURE IF EXISTS `spCreatePhoneNumber`;
DROP PROCEDURE IF EXISTS `spCreatePhoneType`;
DROP PROCEDURE IF EXISTS `spCreateAddressType`;
DROP PROCEDURE IF EXISTS `spDisableUser`;
DROP PROCEDURE IF EXISTS `spEnableUser`;
DROP PROCEDURE IF EXISTS `spDeleteAddress`;
DROP PROCEDURE IF EXISTS `spDeletePhoneNumber`;
DROP PROCEDURE IF EXISTS `spUpdateAcceptEmailAddress`;
DROP PROCEDURE IF EXISTS `spUpdateRejectEmailAddress`;
DROP PROCEDURE IF EXISTS `spGetRoles`;
DROP PROCEDURE IF EXISTS `spUserAddRole`;
DROP PROCEDURE IF EXISTS `spUserRemoveRole`;
DROP PROCEDURE IF EXISTS `spYearlyAddMembershipHistory`;
DROP PROCEDURE IF EXISTS `spUpdateUserPassword`;
DROP PROCEDURE IF EXISTS `spUpdateUserEmailAddress`;
DROP PROCEDURE IF EXISTS `spAuthorCreateSubmission`;
DROP PROCEDURE IF EXISTS `spAuthorAddToSubmission`;
DROP PROCEDURE IF EXISTS `spUpdateUserInfo`;
DROP PROCEDURE IF EXISTS `spUpdateAddress`;
DROP PROCEDURE IF EXISTS `spUpdatePhoneNumber`;
DROP PROCEDURE IF EXISTS `spUpdatePhoneType`;
DROP PROCEDURE IF EXISTS `spUpdateAddressType`;
DROP PROCEDURE IF EXISTS `spUpdateSubmissionStatus`;
DROP PROCEDURE IF EXISTS `spCreateAnnouncement`;
DROP PROCEDURE IF EXISTS `spUpdateAnnouncement`;
DROP PROCEDURE IF EXISTS `spRemoveAnnouncement`;
DROP PROCEDURE IF EXISTS `spRemoveExpiredAnnouncements`;
DROP PROCEDURE IF EXISTS `spAnnouncementAddRole`;
DROP PROCEDURE IF EXISTS `spAuthorViewSubmissions`;
DROP PROCEDURE IF EXISTS `spReviewerViewSubmissions`;
DROP PROCEDURE IF EXISTS `spEditorViewSubmissions`;
DROP PROCEDURE IF EXISTS `spUpdateSubmissionAssignEditor`;
DROP PROCEDURE IF EXISTS `spAuthorUpdateSubmission`;
DROP PROCEDURE IF EXISTS `spReviewerAddToSubmission`;
DROP PROCEDURE IF EXISTS `spAnnouncementRemoveRole`;
DROP PROCEDURE IF EXISTS `spGetUserAnnouncements`;
DROP PROCEDURE IF EXISTS `spSubmissionAssignEditor`;
DROP PROCEDURE IF EXISTS `spUpdateExpireUsersEmailAddressChange`;
DROP PROCEDURE IF EXISTS `spGetUsersEditorsList`;
DROP PROCEDURE IF EXISTS `spGetUsersReviewersList`;
DROP PROCEDURE IF EXISTS `spGetUsersAuthorsList`;
DROP PROCEDURE IF EXISTS `spGetFileTypes`;
DROP PROCEDURE IF EXISTS `spSubmissionGetInfo`;
DROP PROCEDURE IF EXISTS `spSubmissionGetFilesList`;
DROP PROCEDURE IF EXISTS `spReviewerGetFilesList`;
DROP PROCEDURE IF EXISTS `spGetFileInfo`;
DROP PROCEDURE IF EXISTS `spGetFileContents`;
DROP PROCEDURE IF EXISTS `spCreateSubmissionFileMetaData`;
DROP PROCEDURE IF EXISTS `spCreateReviewerFileMetaData`;
DROP PROCEDURE IF EXISTS `spCreateFileContent`;
DROP PROCEDURE IF EXISTS `spUpdateFileMetaData`;
DROP PROCEDURE IF EXISTS `spCreateCategory`;
DROP PROCEDURE IF EXISTS `spUpdateCategory`;