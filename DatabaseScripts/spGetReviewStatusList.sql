USE gr_jci;

DELIMITER $$

/* Gets the list of reviewer statuses */
DROP PROCEDURE IF EXISTS `spGetReviewStatusList`$$
CREATE PROCEDURE `spGetReviewStatusList`()
DETERMINISTIC
BEGIN
  Select ReviewStatusID, ReviewStatus
  From ReviewStatus
  Order By ReviewStatusID;
END$$

DELIMITER ;