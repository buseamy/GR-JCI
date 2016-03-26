USE gr_jci;

DELIMITER $$

/* Gets the user's info for sending verification email */
DROP PROCEDURE IF EXISTS `spGetVerificationUserInfo`$$
CREATE PROCEDURE `spGetVerificationUserInfo`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select FirstName,
         LastName,
		 NewEmailAddress,
		 EmailVerificationGUID
  From Users
  Where UserID = _UserID;
END$$

DELIMITER ;