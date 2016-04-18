USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetFileContents`$$
CREATE PROCEDURE `spGetFileContents`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file content records for a FileMetaDataID
   */
  Select FileContents
  From FileData
  Where FileMetaDataID = _FileMetaDataID
  Order By SequenceNumber;
END$$

DELIMITER ;