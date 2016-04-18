USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreateCategory`$$
CREATE PROCEDURE `spCreateCategory`(IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Inserts a new Category
   */
  /* Make sure the Category doesn't exist */
  If(Select Exists(Select 1 From Categories Where Category = _Category)) Then
    Select 'Category already exists' As 'Error';
  Else
    Insert Into Categories(Category)
	Values (_Category);
	
	Select last_insert_id() As 'CategoryID';
  End If; 
END$$

DELIMITER ;