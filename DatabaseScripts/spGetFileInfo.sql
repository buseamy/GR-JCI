USE gr_jci;

DELIMITER $$

/* Gets the file info record for a FileMetaDataID  */
DROP PROCEDURE IF EXISTS `spGetFileInfo`$$
CREATE PROCEDURE `spGetFileInfo`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  Select FileName, FileMime, FileSize
  From FileMetaData
  Where FileMetaDataID = _FileMetaDataID;
END$$

DELIMITER ;