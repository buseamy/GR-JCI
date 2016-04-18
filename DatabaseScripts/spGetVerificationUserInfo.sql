USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetVerificationUserInfo`$$
CREATE PROCEDURE `spGetVerificationUserInfo`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the user's info for sending verification email
   */
  Select FirstName,
         LastName,
		 NewEmailAddress,
		 EmailVerificationGUID
  From Users
  Where UserID = _UserID;
END$$

DELIMITER ;