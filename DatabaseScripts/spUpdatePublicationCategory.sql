USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdatePublicationCategory`$$
CREATE PROCEDURE `spUpdatePublicationCategory`(IN _CategoryID int,
                                               IN _Category varchar(20))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a category for published incidents
   */
  If(Select Exists(Select 1 From PublicationCategories Where Category = _Category And CategoryID != _CategoryID)) Then
    Select Concat('Category "', _Category, '" already exists') As 'Error';
  Else
    Update PublicationCategories
    Set Category = _Category
    Where CategoryID = _CategoryID;
  End If;
END$$

DELIMITER ;