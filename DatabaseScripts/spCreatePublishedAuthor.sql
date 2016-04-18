USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreatePublishedAuthor`$$
CREATE PROCEDURE `spCreatePublishedAuthor`(IN _UserID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a Published Author record from the Users table
   */
  /* Make sure the UserID exists */
  If(Select Exists(Select 1 From Users Where UserID = _UserID)) Then
      Insert Into PublishedAuthors (FirstName, LastName, EmailAddress, InstitutionAffiliation)
      Select FirstName, LastName, EmailAddress, InstitutionAffiliation
      From Users
      Where UserID = _UserID;
      
      Select last_insert_id() As 'AuthorID';
  Else
    Select Concat('UserID ', _UserID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;