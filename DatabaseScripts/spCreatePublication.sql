USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spCreatePublication`$$
CREATE PROCEDURE `spCreatePublication`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Creates a Publication record for a year
   */
  Declare _Year int;
  Set _Year = Year(CURRENT_DATE);
  
  If(Select Exists(Select 1 From Publications Where Year = _Year)) Then
    Select Concat('Publication for year ', _Year, ' already exists') As 'Error';
  Else
    If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
	  Insert Into Publications (Year, FileMetaDataID)
	  Values (_Year, _FileMetaDataID);
	  
	  Select last_insert_id() As 'PublicationID';
	Else
	  Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
	End If;
  End If;
END$$

DELIMITER ;