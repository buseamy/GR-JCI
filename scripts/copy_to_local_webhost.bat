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

REM remembering the bug/feature noted at the top, replace the expected execution directory
REM using the host-public directory in the repo
SET SrcDir=%SrcDir:\scripts=\public_html%

ECHO %SrcDir% %HostDir%
ROBOCOPY %SrcDir% %HostDir% *.* /E /SL /XD .git

REM copy testing files for developers
SET SrcDir=%SrcDir:\public_html=\test_files%
SET HostDir=%HostDir:\htdocs=\htdocs\test_files%
ECHO %SrcDir% %HostDir%
ROBOCOPY %SrcDir% %HostDir% *.* /E /SL /XD .git
PAUSE
