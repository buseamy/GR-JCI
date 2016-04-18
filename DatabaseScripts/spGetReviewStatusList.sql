USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetReviewStatusList`$$
CREATE PROCEDURE `spGetReviewStatusList`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of reviewer statuses
   */
  Select ReviewStatusID, ReviewStatus
  From ReviewStatus
  Order By ReviewStatusID;
END$$

DELIMITER ;