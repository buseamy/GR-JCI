USE gr_jci;

DELIMITER $$

/* Gets the file content records for a FileMetaDataID  */
DROP PROCEDURE IF EXISTS `spGetFileContents`$$
CREATE PROCEDURE `spGetFileContents`(IN _FileMetaDataID int)
DETERMINISTIC
BEGIN
  Select FileContents
  From FileData
  Where FileMetaDataID = _FileMetaDataID
  Order By SequenceNumber;
END$$

DELIMITER ;