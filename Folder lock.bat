Check the signs (more than)

cls
@ECHO OFF
title Folder KratoSkills
if EXIST "HTG Locker" goto UNLOCK
if NOT EXIST KratoSkills goto MDLOCKER
:CONFIRM
echo Are you sure you want to lock the folder(Y/N)
set/p "cho=(more than)"
if %cho%==Y goto LOCK
if %cho%==y goto LOCK
if %cho%==n goto END
if %cho%==N goto END
echo Invalid choice.
goto CONFIRM
:LOCK
ren KratoSkills "HTG Locker"
attrib +h +s "HTG Locker"
echo Folder locked
goto End
:UNLOCK
echo Enter password to unlock folder
set/p "pass=(more than)"
if NOT %pass%== H4ck3r goto FAIL
attrib -h -s "HTG Locker"
ren "HTG Locker" KratoSkills
echo Folder Unlocked successfully
goto End
:FAIL
echo Invalid password
goto end
:MDLOCKER
md KratoSkills
echo KratoSkills created successfully
goto End
:End