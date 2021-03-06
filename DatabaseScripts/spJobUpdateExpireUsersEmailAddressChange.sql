USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spJobUpdateExpireUsersEmailAddressChange`$$
CREATE PROCEDURE `spJobUpdateExpireUsersEmailAddressChange`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Expire user's EmailAddress change attempts
   */
  /* Registered user never confirmed their email address, expire it outright */
  Update Users
  Set EmailStatusID = 2,
      NewEmailAddressCreateDate = Null,
	  EmailVerificationGUID = Null,
	  NewEmailAddress = Null
  Where EmailStatusID = 1
    And NewEmailAddress = EmailAddress
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 5 DAY;

  /* User never confirmed their new email address, keep the old one */
  Update Users
  Set EmailStatusID = 3,
      NewEmailAddressCreateDate = Null,
	  EmailVerificationGUID = Null,
	  NewEmailAddress = Null
  Where EmailStatusID = 1
    And NewEmailAddress != EmailAddress
    And NewEmailAddressCreateDate < CURRENT_DATE - INTERVAL 5 DAY;
END$$

DELIMITER ;