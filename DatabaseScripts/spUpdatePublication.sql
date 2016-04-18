USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spUpdatePublication`$$
CREATE PROCEDURE `spUpdatePublication`(IN _Year int,
                                       IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Updates a Publication record for a year
   */
  /* Make sure the year exists */
  If(Select Exists(Select 1 From Publications Where Year = _Year)) Then
    /* Make sure the FileMetaDataID exists */
    If(Select Exists(Select 1 From FileMetaData Where FileMetaDataID = _FileMetaDataID)) Then
	  Update Publications
	  Set FileMetaDataID = _FileMetaDataID
	  Where Year = _Year;
	Else
	  Select Concat('FileMetaDataID ', _FileMetaDataID, ' doesn''t exist') As 'Error';
	End If;
  Else
    Select Concat('Publication for year ', _Year, ' doesn''t exist') As 'Error';
  End If;
END$$

DELIMITER ;