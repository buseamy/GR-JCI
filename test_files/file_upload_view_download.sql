-- DROP DATABASE Test_DB;
-- DROP USER 'Test_DB_Admin'@'localhost';
-- DROP USER 'Test_DB_Admin'@'%';

-- uncomment above lines to remove an existing database and user
-- for instances like testing this script the second-and-onwards time 

CREATE DATABASE Test_DB;
USE Test_DB;

CREATE USER 'Test_DB_Admin'@'localhost' IDENTIFIED BY 'php$qld6!';
CREATE USER 'Test_DB_Admin'@'%' IDENTIFIED BY 'php$qld6!';

GRANT SELECT, INSERT, UPDATE, EXECUTE ON Test_DB.* TO 'Test_DB_Admin'@'localhost' IDENTIFIED BY 'php$qld6!';
GRANT SELECT, INSERT, UPDATE, EXECUTE ON Test_DB.* TO 'Test_DB_Admin'@'%' IDENTIFIED BY 'php$qld6!';

CREATE TABLE FileType (
    filetype_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    filetype_name VARCHAR(60) NOT NULL default 'application/octet-stream',
    PRIMARY KEY (filetype_id)
    );

CREATE TABLE Files (
    files_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    files_type INT UNSIGNED NOT NULL,
    files_name VARCHAR(60) NOT NULL,
    files_size INT UNSIGNED NOT NULL,
    files_data BLOB,
    PRIMARY KEY (files_id),
    FOREIGN KEY (files_type) REFERENCES FileType (filetype_id) ON DELETE NO ACTION ON UPDATE NO ACTION
    );

delimiter //
USE Test_DB//

CREATE PROCEDURE UploadFile (
    FileName VARCHAR(60),
    FileMime VARCHAR(60),
    FileSize INT,
    FileData BLOB
    )
BEGIN
    IF (NOT EXISTS(SELECT 1 FROM FileType WHERE filetype_name = FileMime)) THEN
        INSERT INTO FileType (filetype_name) VALUES (FileMime);
    END IF;
    IF (NOT EXISTS(SELECT 1 FROM Files WHERE files_name = FileName)) THEN
        INSERT INTO Files (files_type, files_name, files_size, files_data) VALUES ((SELECT filetype_id FROM FileType WHERE filetype_name = FileMime), FileName, FileSize, FileData);
    END IF;
END//

CREATE PROCEDURE GetFileList ()
BEGIN
    SELECT files_name FROM Files;
END//

CREATE PROCEDURE GetFile (
    FileName VARCHAR(60)
    )
BEGIN
    SELECT F.files_name, F.files_size, F.files_data, FT.filetype_name FROM Files AS F INNER JOIN FileType AS FT ON (F.files_type = FT.filetype_id) WHERE files_name = FileName;
END//

delimiter ;
