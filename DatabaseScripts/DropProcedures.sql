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