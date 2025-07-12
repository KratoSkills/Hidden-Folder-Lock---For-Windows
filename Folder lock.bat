@ECHO OFF
cls
color 0A
title Folder ".nomedia"

:: Ensure variables are up to date from the system environment
FOR /F "tokens=2*" %%A IN ('REG QUERY "HKCU\Environment" /v "krX-lock-pass" 2^>nul') DO set "krX-lock-pass=%%B"
FOR /F "tokens=2*" %%A IN ('REG QUERY "HKCU\Environment" /v "krX-lock-rec" 2^>nul') DO set "krX-lock-rec=%%B"

:: Failsafe: Create folder and ask for password + recovery setup
if NOT EXIST "krX-lock" if NOT EXIST ".nomedia" goto SETUP

:: Main flow
if EXIST "krX-lock" goto UNLOCK
if NOT EXIST ".nomedia" goto SETUP

:CONFIRM
echo Are you sure you want to lock the folder (Y/N)?
for /f "delims=" %%p in ('powershell -Command "$cho = Read-Host -AsSecureString 'Your Choice'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($cho))"') do set "cho=%%p"
if /I "%cho%"=="Y" goto LOCK
if /I "%cho%"=="N" goto END
echo Invalid choice.
goto CONFIRM

:LOCK
ren ".nomedia" "krX-lock"
attrib +h +s "krX-lock"
echo Folder locked
goto END

:UNLOCK
echo Enter password to unlock folder or type RECOVER to recover password:
for /f "delims=" %%p in ('powershell -Command "$input = Read-Host -AsSecureString 'Password or RECOVER'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($input))"') do set "pass=%%p"

if /I "%pass%"=="RECOVER" goto RECOVER

if NOT "%pass%"=="%krX-lock-pass%" goto FAIL
attrib -h -s "krX-lock"
ren "krX-lock" ".nomedia"
echo Folder unlocked successfully
goto END

:RECOVER
cls
echo Enter your Recovery String:
for /f "delims=" %%p in ('powershell -Command "$rec = Read-Host -AsSecureString 'Recovery String'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($rec))"') do set "rec=%%p"

if "%rec%"=="%krX-lock-rec%" (
    echo Password Recovery Successful. Your Password is: [33m%krX-lock-pass%[92m
	timeout /t 5
) else (
    echo Incorrect Recovery String. Cannot Recover Password.
)
goto END

:SETUP
cls
echo INITIAL SETUP: Set Password and Recovery String to Create the Folder

:: Ask for password
echo SET A PASSWORD:
for /f "delims=" %%p in ('powershell -Command "$pw = Read-Host -AsSecureString 'New Password'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw))"') do (
    set "krX-lock-pass=%%p"
    setx krX-lock-pass "%%p" >nul
)

:: Ask for recovery string
echo SET A RECOVERY STRING (used to recover password):
for /f "delims=" %%p in ('powershell -Command "$rec = Read-Host -AsSecureString 'Recovery String'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($rec))"') do (
    set "krX-lock-rec=%%p"
    setx krX-lock-rec "%%p" >nul
)

md ".nomedia"
echo Setup complete. Folder ".nomedia" created successfully.
goto END

:FAIL
echo Invalid Password. Exiting...
timeout /t 1 >nul
goto END

:END
exit /b
