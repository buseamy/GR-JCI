USE gr_jci;

DELIMITER $$

DROP PROCEDURE IF EXISTS `spGetFileInfo`$$
CREATE PROCEDURE `spGetFileInfo`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  /* Created By : Jeff Ballard
   * Create Date: 18-Apr-2016
   * Purpose    : Gets the file info record for a FileMetaDataID
   */
  Select FileName, FileMime, FileSize
  From FileMetaData
  Where FileMetaDataID = _FileMetaDataID;
END$$

DELIMITER ;