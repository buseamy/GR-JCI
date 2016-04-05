USE gr_jci;

DELIMITER $$

/* Gets the list of types of categories for published incidents */
DROP PROCEDURE IF EXISTS `spGetPublicationCategories`$$
CREATE PROCEDURE `spGetPublicationCategories`()
DETERMINISTIC
BEGIN
  Select CategoryID, Category
  From PublicationCategories
  Order By Category;
END$$

DELIMITER ;