USE gr_jci;

DELIMITER $$

/* Gets the list of states */
DROP PROCEDURE IF EXISTS `spGetStates`$$
CREATE PROCEDURE `spGetStates`()
DETERMINISTIC
BEGIN
  Select StateID, CONCAT(Abbr,' - ',Name) As FullStateName
  From States
  Order By Abbr;
END$$

DELIMITER ;