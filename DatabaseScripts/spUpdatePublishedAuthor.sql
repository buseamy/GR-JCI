USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdatePublishedAuthor`$$
CREATE PROCEDURE `spUpdatePublishedAuthor`(IN _AuthorID int,
                                           IN _FirstName varchar(15),
                                           IN _LastName varchar(30),
                                           IN _EmailAddress varchar(200),
                                           IN _InstitutionAffiliation varchar(100))
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a Published Author record
   */
  /* Make sure the AuthorID exists */
  If(Select Exists(Select 1 From PublishedAuthors Where AuthorID = _AuthorID)) Then
    Update PublishedAuthors
    Set FirstName = _FirstName,
        LastName = _LastName,
        EmailAddress = _EmailAddress,
        InstitutionAffiliation = _InstitutionAffiliation
    Where AuthorID = _AuthorID;
  Else
    Select Concat('AuthorID ', _AuthorID, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;