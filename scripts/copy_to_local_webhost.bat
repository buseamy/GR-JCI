@echo off
REM Robocopy features a bug where a quoted path requires a space before the closing quote
REM XAMPP_DIR and JCI_REPO can be set as environment variables
SET HostDir="%XAMPP_DIR% "
SET SrcDir="%JCI_REPO% "

REM set hostdir and srcdir here if you wish to override them
REM SET HostDir="C:\xampp\htdocs "
REM SET SrcDir="C:\xampp\htdocs "

IF %HostDir%==" " (
	SET HostDir="C:\xampp\htdocs " )
IF %SrcDir%==" " (
	SET SrcDir="%~dp0 " )
If %SrcDir%==" " (
	ECHO "This can't happen - ~dp0 gets the execution directory" )

SET SrcDir=%SrcDir:\scripts=%

ECHO %SrcDir% %HostDir%
ROBOCOPY %SrcDir% %HostDir% *.* /E /SL
PAUSE
