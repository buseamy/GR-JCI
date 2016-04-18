USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetPublicationCategories`$$
CREATE PROCEDURE `spGetPublicationCategories`()
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the list of types of categories for published incidents
   */
  Select CategoryID, Category
  From PublicationCategories
  Order By Category;
END$$

DELIMITER ;