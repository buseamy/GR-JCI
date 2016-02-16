USE gr_jci;

DELIMITER $$

/* Gets the list of states */
DROP PROCEDURE IF EXISTS `spGetStates`$$
CREATE PROCEDURE `spGetStates`(IN _UserID int)
DETERMINISTIC
BEGIN
  Select StateID, Abbr + ' - ' + Name
  From States
  Order By Abbr;
END$$

DELIMITER ;
