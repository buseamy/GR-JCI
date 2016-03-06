USE gr_jci;

DELIMITER $$

/* Updates an existing Category */
DROP PROCEDURE IF EXISTS `spUpdateCategory`$$
CREATE PROCEDURE `spUpdateCategory`(IN _CategoryID int,
                                    IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Make sure the Category doesn't exist */
  If(Select Exists(Select 1 From Categories Where Category = _Category And CategoryID != _CategoryID)) Then
    Select 'Category already exists' As 'Error';
  Else
    Update Categories
	Set Category = _Category
	Where CategoryID = _CategoryID;
  End If;
END$$

DELIMITER ;