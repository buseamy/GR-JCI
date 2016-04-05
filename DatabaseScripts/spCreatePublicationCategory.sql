USE gr_jci;

DELIMITER $$

/* Creates a new category for published incidents */
DROP PROCEDURE IF EXISTS `spCreatePublicationCategory`$$
CREATE PROCEDURE `spCreatePublicationCategory`(IN _Category varchar(20))
DETERMINISTIC
BEGIN
  If(Select Exists(Select 1 From PublicationCategories Where Category = _Category)) Then
    Select Concat('Category "', _Category, '" already exists') As 'Error';
  Else
    Insert Into PublicationCategories (Category)
    Values (_Category);
    
    Select last_insert_id() As 'CategoryID';
  End If;
END$$

DELIMITER ;