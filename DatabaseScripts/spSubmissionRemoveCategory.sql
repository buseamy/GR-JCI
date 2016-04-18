USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spSubmissionRemoveCategory`$$
CREATE PROCEDURE `spSubmissionRemoveCategory`(IN _SubmissionID int, IN _CategoryID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Removes a SubmissionID from a CategoryID
   */
  Delete From SubmissionCategories
  Where SubmissionID = _SubmissionID
    And CategoryID = _CategoryID;
END$$

DELIMITER ;