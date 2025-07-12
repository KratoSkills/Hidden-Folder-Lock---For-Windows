@ECHO OFF
cls
color 0A
title Folder "KratoSkills"

:: Failsafe: create if both folders are missing
if NOT EXIST "krX-lock" if NOT EXIST "KratoSkills" goto MDLOCKER

:: Main flow
if EXIST "krX-lock" goto UNLOCK
if NOT EXIST "KratoSkills" goto MDLOCKER

:CONFIRM
echo Are you sure you want to lock the folder (Y/N)?
for /f "delims=" %%p in ('powershell -Command "$cho = Read-Host -AsSecureString 'Your Choice'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($cho))"') do set "cho=%%p"
if /I "%cho%"=="Y" goto LOCK
if /I "%cho%"=="N" goto END
echo Invalid choice.
goto CONFIRM

:LOCK
ren "KratoSkills" "krX-lock"
attrib +h +s "krX-lock"
echo Folder locked
goto END

:UNLOCK
echo Enter password to unlock folder:
for /f "delims=" %%p in ('powershell -Command "$pass = Read-Host -AsSecureString 'Password'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"') do set "pass=%%p"
if NOT "%pass%"=="H4ck3r" goto FAIL
attrib -h -s "krX-lock"
ren "krX-lock" "KratoSkills"
echo Folder unlocked successfully
goto END

:FAIL
echo Invalid password. Exiting...
timeout /t 1 >nul
goto END

:MDLOCKER
md "KratoSkills"
echo Folder '"KratoSkills"' created successfully
goto END

:END
exit
