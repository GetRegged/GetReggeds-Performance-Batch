@echo off
title GetRegged's Performance Batch

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ███╗   ██╗███████╗ ██████╗███████╗███████╗███████╗██╗████████╗██╗███████╗███████╗
:: ████╗  ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝██║╚══██╔══╝██║██╔════╝██╔════╝
:: ██╔██╗ ██║█████╗  ██║     █████╗  ███████╗███████╗██║   ██║   ██║█████╗  ███████╗
:: ██║╚██╗██║██╔══╝  ██║     ██╔══╝  ╚════██║╚════██║██║   ██║   ██║██╔══╝  ╚════██║
:: ██║ ╚████║███████╗╚██████╗███████╗███████║███████║██║   ██║   ██║███████╗███████║
:: ╚═╝  ╚═══╝╚══════╝ ╚═════╝╚══════╝╚══════╝╚══════╝╚═╝   ╚═╝   ╚═╝╚══════╝╚══════╝                                                                           
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: Set Release Version #
Set Version=1.0-beta

:: Enable Delayed Expansion
setlocal enabledelayedexpansion >nul 2>&1

:: Set Powershell Execution Policy to Unrestricted
powershell "Set-ExecutionPolicy Unrestricted" >nul 2>&1

:: Enable ANSI Escape Sequences
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable User Account Control
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f >nul 2>&1

:: Getting Admin Permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" ( >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system" ) ELSE ( >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" )
IF '%errorlevel%' NEQ '0' (goto UACPrompt) ELSE (goto GotAdmin)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:GotAdmin
pushd "%CD%"
CD /D "%~dp0"

::Get Device Information
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID') do set "editionID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion') do set "versionID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') do set "buildID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKCU\Volatile Environment" /v USERNAME') do set "userID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName') do set "computerID=%%b"
for /f "tokens=5*" %%a in ('powercfg -list ^| findstr \*') do set powerplanID=%%a
for /f "tokens=2 delims=()" %%a in ('wmic timezone get caption /value') do set tzone1=%%a
for /f "tokens=3 delims=()" %%a in ('wmic timezone get caption /value') do set tzone2=%%a

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ███╗   ███╗ █████╗ ██╗███╗   ██╗    ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
:: ████╗ ████║██╔══██╗██║████╗  ██║    ████╗ ████║██╔════╝████╗  ██║██║   ██║
:: ██╔████╔██║███████║██║██╔██╗ ██║    ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
:: ██║╚██╔╝██║██╔══██║██║██║╚██╗██║    ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
:: ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║    ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
:: ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ 
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:Menu
chcp 65001 >nul 2>&1
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo                           %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Windows Activation%t%                 		  %w%[%y% %c%%u%2%q% %t%%w%]%y% %c%Windows Optimization%t%
echo. 
echo.
echo                           %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%Windows Updates%t%					  %w%[%y% %c%%u%4%q% %t%%w%]%y% %c%Windows PowerPlan%t%
echo.
echo.
echo                           %w%[%y% %c%%u%5%q%%t% %w%]%y% %c%Windows TempCleaner%t%                           	  %w%[%y% %c%%u%6%q%%t% %w%]%y% %c%Option6%t%
echo.
echo.
echo								%w%[%y% %c%%u%0%q%%t% %w%]%y% %c%Exit%t%
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='0' goto Exit
if '%choice%'=='1' goto WindowsActivation
if '%choice%'=='2' goto WindowsOptimization
if '%choice%'=='3' goto WindowsUpdates
if '%choice%'=='4' goto WindowsPowerPlan
if '%choice%'=='5' goto WindowsTempCleaner
if '%choice%'=='6' goto Option6

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗     █████╗  ██████╗████████╗██╗██╗   ██╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
:: ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ██╔══██╗██╔════╝╚══██╔══╝██║██║   ██║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
:: ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ███████║██║        ██║   ██║██║   ██║███████║   ██║   ██║██║   ██║██╔██╗ ██║
:: ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║    ██╔══██║██║        ██║   ██║╚██╗ ██╔╝██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
:: ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║    ██║  ██║╚██████╗   ██║   ██║ ╚████╔╝ ██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
::  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝  ╚═══╝  ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:WindowsActivation
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.					
echo							      System: Windows 10/11
echo							     Edition: %editionID%
echo							     Version: %versionID%
echo							       Build: %buildID%
echo.
echo.
echo                                       %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Activate%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%Deactivate%t%
echo.
echo.
echo.
echo.
echo								%w%[%y% %c%%u%0%q%%t% %w%]%y% %c%Menu%t%
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='0' goto menu
if '%choice%'=='1' goto activate
if '%choice%'=='2' goto deactivate

:activate
cls
cscript //B "%windir%\system32\slmgr.vbs" /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
cscript //B "%windir%\system32\slmgr.vbs" /skms kms8.msguides.com >nul 2>&1
echo Windows activated
timeout /t 2 /nobreak >nul 2>&1
goto menuorexit

:deactivate
cls
cscript //B "%windir%\system32\slmgr.vbs" -upk
cscript //B "%windir%\system32\slmgr.vbs" -cpky
cscript //B "%windir%\system32\slmgr.vbs" -rearm
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "BackupProductKey" /f>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "KeyManagementServiceName" /f>nul
echo Windows deactivated
timeout /t 2 /nobreak >nul 2>&1
goto menuorexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗     ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
:: ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
:: ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ ███████║   ██║   ██║██║   ██║██╔██╗ ██║
:: ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║    ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
:: ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║    ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
::  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝     ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:WindowsOptimization
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                           Do you want to create a restor point?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto CreateRestorePoint
if '%choice%'=='2' goto StartWindowsOptimization

:CreateRestorePoint
:: Creating restore point
cls
echo Creating restore point
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d "0" /f
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'GetReggeds Performance Batch' -RestorePointType 'MODIFY_SETTINGS'"

cls
echo Restore point created
timeout /t 2 /nobreak >nul 2>&1

:StartWindowsOptimization

:: ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗    ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
:: ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
:: ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
:: ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║    ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
:: ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║    ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
::  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

cls
echo Optimizing Windows Settings

:: SYSTEM TAB

:: Start > Settings > System > Display > Advanced scaling settings > Fix scaling for apps > Off
reg add "HKCU\Control Panel\Desktop" /v "EnablePerProcessSystemDPI" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Display > Graphic settings > Hardware-accelerated GPU scheduling > On (More FPS)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Get notifications from apps and other senders > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Show notifications on the lock screen > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Show notifications on the lock screen > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Show reminders and incoming VoIP calls on the lock screen > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Allow notifications to play sounds > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Show me the Windows welcome experience... > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Suggest ways I can finish setting up my device... > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Notifications & actions > Get tips, tricks, and suggestions as you use Windows > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-358394Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-358396Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-358398Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-202914Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-280813Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-280815Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310091Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310092Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338380Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338381Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-346481Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 &:: not in Windows Settings App Included

:: Start > Settings > System > Storage > Configure Storage Sense or run it now > Disable auto-delete files
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "08" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "256" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "32" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "512" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Tablet > When I sign in > Never use tablet mode
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "ConvertibleSlateModePromptPreference" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "TabletMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Tablet > Change additional tablet settings > Hide app icons on the taskbar > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAppsVisibleInTabletMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > System > Tablet > Change additional tablet settings > Make app icons on the taskbar easier to touch > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AppIconInTouchImprovement" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Tablet > Change additional tablet settings > Show the search icon without the search box > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SearchBoxVisibleInTouchImprovement" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > System > Tablet > Change additional tablet settings > Make buttons in File Explorer easier to touch > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "FileExplorerInTouchImprovement" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Tablet > Change additional tablet settings > Show onscreen keyboard > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDesktopModeAutoInvoke" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > Multitasking > When I snap a window, show what I can snap next to it > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > System > Multitasking > Pressing Alt + Tab shows > Open windows only
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MultiTaskingAltTabFilter" /t REG_DWORD /d "3" /f >nul 2>&1

:: Start > Settings > System > Shared experiences > Share across devices > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "EnableRemoteLaunchToast" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "NearShareChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP\SettingsPage"

:: Start > Settings > System > About > Advanced system settings > Hardware > Device Installation Settings > Do you want to automatically download... > No
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Animate controls and elements inside windows > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Animate windows when minimizing and maximizing > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Animations in the taskbar > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Enable Peek > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMAeroPeekEnabled" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Fade or slide menus into view > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Fade or slide ToolTips into view > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Fade out menu items after clicking > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\SelectionFade" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Save taskbar thumbnail previews > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMSaveThumbnailEnabled" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Show shadows under mouse pointer > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\CursorShadow" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Show shadows under windows > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DropShadow" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Show thumbnails instead of icons > On
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ThumbnailsOrIcon" /v "DefaultValue" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Show translucent selection rectangle > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewAlphaSelect" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Show windows contents while dragging > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DragFullWindows" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Slide open combo boxes > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Smooth edges of screen fonts > On
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultValue" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Smooth-scroll list boxes > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListBoxSmoothScrolling" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Use drop shadows for icon labels on the desktop > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewShadow" /v "DefaultValue" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Visual Effects > Peek active > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Performance (Settings) > Advanced > Virtual memory > Off (Disables Pagingfile)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d 00,00,00,00 /f

:: Start > Settings > System > About > Advanced system settings > Advanced > Startup and Recovery (Settings) > Automatically restart > Off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Advanced > Startup and Recovery (Settings) > Write debugging information > (none)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Remote > Off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > System > About > Advanced system settings > Remote > Off
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-DCOM-In-TCP-NoScope-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=6|Profile=Domain|LPort=135|App=%SystemRoot%\\system32\\svchost.exe|Svc=rpcss|Name=@FirewallAPI.dll,-33035|Desc=@FirewallAPI.dll,-33036|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-In-TCP-EdgeScope" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=6|Profile=Public|App=%SystemRoot%\\system32\\msra.exe|Name=@FirewallAPI.dll,-33003|Desc=@FirewallAPI.dll,-33006|EmbedCtxt=@FirewallAPI.dll,-33002|Edge=TRUE|Defer=App|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-In-TCP-EdgeScope-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=6|Profile=Domain|Profile=Private|App=%SystemRoot%\\system32\\msra.exe|Name=@FirewallAPI.dll,-33003|Desc=@FirewallAPI.dll,-33006|EmbedCtxt=@FirewallAPI.dll,-33002|Edge=TRUE|Defer=App|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-Out-TCP" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=6|Profile=Public|App=%SystemRoot%\\system32\\msra.exe|Name=@FirewallAPI.dll,-33007|Desc=@FirewallAPI.dll,-33010|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-Out-TCP-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=6|Profile=Domain|Profile=Private|App=%SystemRoot%\\system32\\msra.exe|Name=@FirewallAPI.dll,-33007|Desc=@FirewallAPI.dll,-33010|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-PnrpSvc-UDP-In-EdgeScope" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=17|Profile=Public|LPort=3540|App=%systemroot%\\system32\\svchost.exe|Svc=pnrpsvc|Name=@FirewallAPI.dll,-33039|Desc=@FirewallAPI.dll,-33040|EmbedCtxt=@FirewallAPI.dll,-33002|Edge=TRUE|Defer=App|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-PnrpSvc-UDP-In-EdgeScope-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=17|Profile=Domain|Profile=Private|LPort=3540|App=%systemroot%\\system32\\svchost.exe|Svc=pnrpsvc|Name=@FirewallAPI.dll,-33039|Desc=@FirewallAPI.dll,-33040|EmbedCtxt=@FirewallAPI.dll,-33002|Edge=TRUE|Defer=App|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-PnrpSvc-UDP-OUT" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=17|Profile=Public|App=%systemroot%\\system32\\svchost.exe|Svc=pnrpsvc|Name=@FirewallAPI.dll,-33037|Desc=@FirewallAPI.dll,-33038|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-PnrpSvc-UDP-OUT-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=17|Profile=Domain|Profile=Private|App=%systemroot%\\system32\\svchost.exe|Svc=pnrpsvc|Name=@FirewallAPI.dll,-33037|Desc=@FirewallAPI.dll,-33038|EmbedCtxt=@FirewallAPI.dll,-33002| /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-RAServer-In-TCP-NoScope-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=6|Profile=Domain|App=%SystemRoot%\\system32\\raserver.exe|Name=@FirewallAPI.dll,-33011|Desc=@FirewallAPI.dll,-33014|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-RAServer-Out-TCP-NoScope-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=6|Profile=Domain|App=%SystemRoot%\\system32\\raserver.exe|Name=@FirewallAPI.dll,-33015|Desc=@FirewallAPI.dll,-33018|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-SSDPSrv-In-TCP-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=6|Profile=Domain|Profile=Private|LPort=2869|RA4=LocalSubnet|RA6=LocalSubnet|App=System|Name=@FirewallAPI.dll,-33027|Desc=@FirewallAPI.dll,-33030|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-SSDPSrv-In-UDP-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=In|Protocol=17|Profile=Domain|Profile=Private|LPort=1900|RA4=LocalSubnet|RA6=LocalSubnet|App=%SystemRoot%\\system32\\svchost.exe|Svc=Ssdpsrv|Name=@FirewallAPI.dll,-33019|Desc=@FirewallAPI.dll,-33022|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-SSDPSrv-Out-TCP-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=6|Profile=Domain|Profile=Private|RA4=LocalSubnet|RA6=LocalSubnet|App=System|Name=@FirewallAPI.dll,-33031|Desc=@FirewallAPI.dll,-33034|EmbedCtxt=@FirewallAPI.dll,-33002|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "RemoteAssistance-SSDPSrv-Out-UDP-Active" /t REG_SZ /d "v2.30|Action=Allow|Active=FALSE|Dir=Out|Protocol=17|Profile=Domain|Profile=Private|RPort=1900|RA4=LocalSubnet|RA6=LocalSubnet|App=%SystemRoot%\\system32\\svchost.exe|Svc=Ssdpsrv|Name=@FirewallAPI.dll,-33023|Desc=@FirewallAPI.dll,-33026|EmbedCtxt=@FirewallAPI.dll,-33002|" /f

:: DEVICE TAB

:: Start > Settings > Devices > Printers & scanners > Let Windows manage my default printer > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Autocorrect misspelled words > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Highlight misspelled words > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Show text suggestions as I type on the software keyboard > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Add a space after I choose a text suggestion > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Add a period after I double-tap the Spacebar > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Onscreen keyboard > Docked > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EdgeTargetDockedState" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Onscreen keyboard > Auto space > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Onscreen keyboard > Audio feedback > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableKeyAudioFeedback" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Onscreen keyboard > Auto caps > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutoShiftEngage" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Onscreen keyboard > Shift lock > Off
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableShiftLock" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Typing insights > Off
reg add "HKCU\SOFTWARE\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Advanced keyboard settings > Input language hot keys > (None)
reg delete "HKCU\Control Panel\Input Method\Hot Keys\00000104" /f

:: Start > Settings > Devices > Typing > Advanced keyboard settings > Input language hot keys > (None)
reg add "HKCU\Keyboard Layout\Toggle" /v "Hotkey" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_DWORD /d "3" /f >nul 2>&1

:: Start > Settings > Devices > Typing > Emojis > Off
reg add "HKCU\SOFTWARE\Microsoft\Input\Settings" /v "EnableExpressiveInputEmojiMultipleSelection" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > Pen & Windows Ink > Show Cursor > Off
reg add "HKCU\Control Panel\Cursors" /v "PenVisualization" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > AutoPlay > Use AutoPlay for all media and devices > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Devices > AutoPlay > Removable drive > Take no action
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival" /t REG_SZ /d "MSTakeNoAction" /f >nul 2>&1

:: Start > Settings > Devices > AutoPlay > Removable drive > Take no action
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival" /t REG_SZ /d "MSTakeNoAction" /f >nul 2>&1

:: Start > Settings > Devices > AutoPlay > Memory card > Take no action
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival" /t REG_SZ /d "MSTakeNoAction" /f >nul 2>&1

:: Start > Settings > Devices > AutoPlay > Memory card > Take no action
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival" /t REG_SZ /d "MSTakeNoAction" /f >nul 2>&1

:: Start > Settings > Devices > USB > Notify me if there are issues connecting to USB devices > Off
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Devices > USB > Notify on weak charge over USB > Off
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnWeakCharger" /t REG_DWORD /d "0" /f >nul 2>&1

:: NETWORK TAB

:: Start > Settings > Network & Internet > Proxy > Automatically detect settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "AutoDetect" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Active Probing (not in Windows Settings App Included)
reg add "HKLM\Software\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "0" /f

::  APPS TAB

:: Start > Settings > Apps > Apps & Features > Sources > All
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AicEnabled" /t REG_SZ /d "Anywhere" /f >nul 2>&1

:: Start > Settings > Apps > Offline maps > Automatically update maps > Off
reg add "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Apps > Startup > Microsoft OneDrive > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "OneDrive" /t REG_BINARY /d 0300000000F877D1BF8DD801 /f >nul 2>&1

:: Start > Settings > Apps > Startup > Windows Security notification icon > Off
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d 0700000000F877D1BF8DD801 /f >nul 2>&1

::  ACCOUNT TAB

:: Start > Settings > Accounts > Sign-in options > Use my sign-in info to automatically finish setting up my device... > Disabled
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Accounts > Sync your settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

::  GAMING TAB                                           

:: Start > Settings > Gaming > Xbox Game Bar > Enable Xbox Game Bar... > Off (Disabling Game Bar Features)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "CursorCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "MicrophoneCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Gaming > Xbox Game Bar > Enable Xbox Game Bar... > Off (Disabling Game bar 100% Full)
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1 

:: Start > Settings > Gaming > Xbox Game Bar > Open Xbox Game Bar using this button... > Off
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Gaming > Captures > Maximum recording length > 30 minutes
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "MaximumRecordLength" /t REG_BINARY /d 0034E23004000000 /f >nul 2>&1

:: Start > Settings > Gaming > Game Mode > Off (Cause probabaly no impact)
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul 2>&1

::Disable GameDVR (not in Windows Settings App Included)
echo Disable GameDVR
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1

:: EASE OF ACCESS TAB

:: Start > Settings > Ease of Access > Display > Automatically hide scroll bars in Windows > Off
reg add "HKCU\Control Panel\Accessibility" /v "DynamicScrollbars" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Ease of Access > Mouse pointer > Show visual feedback around the touch points when I touch the screen > Off
reg add "HKCU\Control Panel\Cursors" /v "ContactVisualization" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Cursors" /v "GestureVisualization" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Ease of Access > Narrator > Allow the shortcut key to start Narrator > Off
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "WinEnterLaunchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Ease of Access > Narrator > Get image descriptions, page titles, and popular links > Off
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "OnlineServicesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Ease of Access > Keyboard > Allow the shortcut key to start Sticky Keys > Off
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags /t REG_SZ /d "506" /f >nul 2>&1

:: Start > Settings > Ease of Access > Keyboard > Allow the shortcut key to start Toggle Keys > Off
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f >nul 2>&1

:: Start > Settings > Ease of Access > Keyboard > Allow the shortcut key to start Filter Keys > Off
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f >nul 2>&1                                                                                                       

:: SEARCH TAB

:: Start > Settings > Search > Permissions & History > SafeSearch > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Search > Permissions & History > Microsoft account > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Search > Permissions & History > Work or School account > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Search > Permissions & History > Search history on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Search > Searching Windows > Off
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
                                                

:: PRIVACY TAB

:: Start > Settings > Privacy > General > Let apps use advertising ID... > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Id" /f >nul 2>&1

:: Start > Settings > Privacy > General > Let apps access my language list > Off
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > General > Let Windows track app launches to improve Start and search results > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > General > Show me suggested content in the Settings app > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Speech recognition > Online-Speech recognition > Off
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Inking & typing personalization > Off
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Inking & typing personalization > Off
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Inking & typing personalization > Off
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Inking & typing personalization > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Diagnostics & feedback > Diagnostic data > Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Diagnostics & feedback > Diagnostic data > Required
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Diagnostics & feedback > Improve inking and typing > Off
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Diagnostics & feedback > Tailored experiences > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Diagnostics & feedback > Windows should ask for my feedback > Never
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >nul 2>&1

:: Start > Settings > Privacy > Activity history > Store my activity history on this device > Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Activity history > Send my activity history to Microsoft > Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Location > Allow access to location on this device > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Privacy > Activity history > Send my activity history to Microsoft > Disabled
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > App diagnostics > Allow access to app diagnostic info on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Calendar > Allow access to calendars on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Calendar > Allow access to bluetooth on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Other devices > Communicate with unpaired devices > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > File system > Allow access to the file system on this device > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Calendar > Allow access to telephone data > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Messaging > Allow access to messaging on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Contacts > Allow access to contacts on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Contacts > Allow access to documents library on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Email > Allow access to email on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Email > Allow access to input on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Location > Allow access to location on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Phone calls > Allow phone calls on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Call history > Allow access to call history on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Contacts > Allow access to pictures library on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Radios > Allow access to control radios on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Account info > Allow access to account info on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Tasks > Allow access to tasks on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Notifications > Allow access to user notifications on this device > Off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Contacts > Allow access to videos library on this device > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Allow apps running in the background > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > 3D Viewer > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Alarms & Clock > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsAlarms_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsAlarms_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Calculator > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsCalculator_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsCalculator_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Camera > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsCamera_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsCamera_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Cortana > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.549981C3F5F10_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.549981C3F5F10_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Desktop App Installer > 3D Viewer > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > DevHome > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.DevHome_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.DevHome_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Feedback Hub > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Get Help > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.GetHelp_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.GetHelp_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Groove Music > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ZuneMusic_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ZuneMusic_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Mail and Calendar > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\microsoft.windowscommunicationsapps_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\microsoft.windowscommunicationsapps_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Maps > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsMaps_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsMaps_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Microsoft Solitaire Collection > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Microsoft Store > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsStore_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsStore_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Mixed Reality Portal > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MixedReality.Portal_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MixedReality.Portal_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Movies & TV > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ZuneVideo_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ZuneVideo_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Office > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > OneNote > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Office.OneNote_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Office.OneNote_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Paint 3D > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MSPaint_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MSPaint_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > People > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.People_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.People_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Photos > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Settings > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\windows.immersivecontrolpanel_cw5n1h2txyewy" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\windows.immersivecontrolpanel_cw5n1h2txyewy" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Skype > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.SkypeApp_kzf8qxf38zg5c" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.SkypeApp_kzf8qxf38zg5c" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Snip & Sketch > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ScreenSketch_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ScreenSketch_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Sticky Notes > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Tips > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Getstarted_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Getstarted_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Voice Recorder > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Weather > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.BingWeather_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.BingWeather_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > WebView > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Windows Security > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Xbox > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.XboxApp_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.XboxApp_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Xbox TCUI > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Xbox.TCUI_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Xbox.TCUI_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Xbox Game Bar > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Background apps > Your Phone > Off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Privacy > Voice activation > Allow apps to use voice activation > Off
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationLastUsed" /t REG_DWORD /d "0" /f >nul 2>&1

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: FOLLOWING TWEAKS ARE NOT IN WINDOWS SETTINGS APP INCLUDED                                                                       
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

:: ██████╗ ██╗███████╗██╗  ██╗
:: ██╔══██╗██║██╔════╝██║ ██╔╝
:: ██║  ██║██║███████╗█████╔╝ 
:: ██║  ██║██║╚════██║██╔═██╗ 
:: ██████╔╝██║███████║██║  ██╗
:: ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝

cls
echo Optimizing System Disks

:: Enable TRIM for SSD
fsutil behavior set DisableDeleteNotify NTFS 0 >nul 2>&1
fsutil behavior set DisableDeleteNotify ReFS 0 >nul 2>&1

:: NTFS Tweaks
fsutil behavior set disabledeletenotify 0 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1
fsutil behavior set memoryusage 2 >nul 2>&1
fsutil behavior set mftzone 4 >nul 2>&1

:: ██╗      █████╗ ████████╗███████╗███╗   ██╗ ██████╗██╗   ██╗
:: ██║     ██╔══██╗╚══██╔══╝██╔════╝████╗  ██║██╔════╝╚██╗ ██╔╝
:: ██║     ███████║   ██║   █████╗  ██╔██╗ ██║██║      ╚████╔╝ 
:: ██║     ██╔══██║   ██║   ██╔══╝  ██║╚██╗██║██║       ╚██╔╝  
:: ███████╗██║  ██║   ██║   ███████╗██║ ╚████║╚██████╗   ██║   
:: ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝  

cls
echo Optimizing Latency

:: BCD Tweaks
bcdedit /set MSI Default >nul 2>&1
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1
bcdedit /set avoidlowmemory 0x8000000 >nul 2>&1
bcdedit /set configaccesspolicy Default >nul 2>&1
bcdedit /set debug No >nul 2>&1
bcdedit /set disabledynamictick Yes >nul 2>&1
bcdedit /set disableelamdrivers Yes >nul 2>&1
bcdedit /set ems No >nul 2>&1
bcdedit /set extendedinput Yes >nul 2>&1
bcdedit /set firstmegabytepolicy UseAll >nul 2>&1
bcdedit /set forcefipscrypto No >nul 2>&1
bcdedit /set highestmode Yes >nul 2>&1
bcdedit /set hypervisorlaunchtype Off >nul 2>&1
bcdedit /set isolatedcontext No >nul 2>&1
bcdedit /set nolowmem Yes >nul 2>&1
bcdedit /set noumex Yes >nul 2>&1
bcdedit /set nx optout >nul 2>&1
bcdedit /set pae ForceEnable >nul 2>&1
bcdedit /set platformtick No >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set usefirmwarepcisettings No >nul 2>&1
bcdedit /set uselegacyapicmode No >nul 2>&1
bcdedit /set usephysicaldestination No >nul 2>&1
bcdedit /set useplatformclock No >nul 2>&1
bcdedit /set vm No >nul 2>&1
bcdedit /set vsmlaunchtype Off >nul 2>&1
bcdedit /set x2apicpolicy Enable >nul 2>&1

:: Enable Multiplane Overlay (Create a more favorable environment for Full Screen Optimizations to function properly and efficiently, enhancing your gaming experience)
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /f >nul 2>&1

:: Enable Full Screen Optimizations
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "0" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Disable P-States
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
		     reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f >nul 2>&1
                   )
                )
             )        
timeout /t 3 /nobreak >nul 2>&1

:: Delete Microcode
del "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /s /f /q >nul 2>&1
del "C:\Windows\System32\mcupdate_GenuineIntel.dll" /s /f /q >nul 2>&1
takeown /f "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /r /d y >nul 2>&1
takeown /f "C:\Windows\System32\mcupdate_GenuineIntel.dll" /r /d y >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Disable Mitigations
powershell "ForEach($v in (Get-Command -Name \"Set-ProcessMitigation\").Parameters[\"Disable\"].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}" >nul 2>&1
powershell "Remove-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Sub Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Set CSRSS to Realtime
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

:: Set MMCSS
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "25000" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Disable Power Throttling
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Set Service Priorities & Boost
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "PagePriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "PagePriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Disable Windows Defender
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotificationOnLockScreen" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEngCP.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericReports" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats" /v "Threats_ThreatSeverityDefaultAction" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "1" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "2" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "4" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "5" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Set Latency Tolerance (melodytheneko)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Set Resource Policy Values
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\BackgroundDefault" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Frozen" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNCS" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenPPLE" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Paused" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PausedDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Pausing" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PrelaunchForeground" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\ThrottleGPUInterference" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\NoCap" /v "IOBandwidth" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitLimit" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitTarget" /t REG_DWORD /d "4294967295" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: ██████╗ ███████╗███████╗██╗  ██╗████████╗ ██████╗ ██████╗ 
:: ██╔══██╗██╔════╝██╔════╝██║ ██╔╝╚══██╔══╝██╔═══██╗██╔══██╗
:: ██║  ██║█████╗  ███████╗█████╔╝    ██║   ██║   ██║██████╔╝
:: ██║  ██║██╔══╝  ╚════██║██╔═██╗    ██║   ██║   ██║██╔═══╝ 
:: ██████╔╝███████╗███████║██║  ██╗   ██║   ╚██████╔╝██║     
:: ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝     

cls
echo Optimizing Desktop

::Decrease Processes Kill Time
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_DWORD /d "1000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_DWORD /d "2000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_DWORD /d "1000" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Decrease Menu Show Delay
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_DWORD /d "0" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Disable Account Lock Delay
reg add "HKCU\Control Panel\Desktop" /v "DelayLockInterval" /t REG_DWORD /d "0" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: ███████╗██╗  ██╗██████╗ ██╗      ██████╗ ██████╗ ███████╗██████╗ 
:: ██╔════╝╚██╗██╔╝██╔══██╗██║     ██╔═══██╗██╔══██╗██╔════╝██╔══██╗
:: █████╗   ╚███╔╝ ██████╔╝██║     ██║   ██║██████╔╝█████╗  ██████╔╝
:: ██╔══╝   ██╔██╗ ██╔═══╝ ██║     ██║   ██║██╔══██╗██╔══╝  ██╔══██╗
:: ███████╗██╔╝ ██╗██║     ███████╗╚██████╔╝██║  ██║███████╗██║  ██║
:: ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

cls
echo Optimizing Explorer

:: Disable Frequent/Recent Files Showing in Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "TelemetrySalt" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable Show Hidden Files and Folders in Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable Show File Extensions in Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable Show Toolbar in Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "0" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: ████████╗███████╗██╗     ███████╗███╗   ███╗███████╗████████╗██████╗ ██╗   ██╗
:: ╚══██╔══╝██╔════╝██║     ██╔════╝████╗ ████║██╔════╝╚══██╔══╝██╔══██╗╚██╗ ██╔╝
::    ██║   █████╗  ██║     █████╗  ██╔████╔██║█████╗     ██║   ██████╔╝ ╚████╔╝ 
::    ██║   ██╔══╝  ██║     ██╔══╝  ██║╚██╔╝██║██╔══╝     ██║   ██╔══██╗  ╚██╔╝  
::    ██║   ███████╗███████╗███████╗██║ ╚═╝ ██║███████╗   ██║   ██║  ██║   ██║   
::    ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝    

cls
echo Disable Telemetry

:: Disable Telemetry Services
sc config DiagTrack start= disabled >nul 2>&1
sc config diagnosticshub.standardcollector.service start= disabled >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc stop diagnosticshub.standardcollector.service >nul 2>&1
sc stop dmwappushservice >nul 2>&1

::Disable Trace Logs (Check which are active with 'logman query -ets')
logman delete "BioEnrollment" -ets >nul 2>&1
logman delete "Circular Kernel Context Logger" -ets >nul 2>&1
logman delete "DiagLog" -ets >nul 2>&1
logman delete "FaceCredProv" -ets >nul 2>&1
logman delete "FaceTel" -ets >nul 2>&1
logman delete "Ihv" -ets >nul 2>&1
logman delete "IntelPTTEKRecertification" -ets >nul 2>&1
logman delete "IntelRST" -ets >nul 2>&1
logman delete "LwtNetLog" -ets >nul 2>&1
logman delete "Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace" -ets >nul 2>&1
logman delete "ModemControl" -ets >nul 2>&1
logman delete "NetCore" -ets >nul 2>&1
logman delete "NtfsLog" -ets >nul 2>&1
logman delete "RadioMgr" -ets >nul 2>&1
logman delete "SgrmEtwSession" -ets >nul 2>&1
logman delete "SleepStudyTraceSession" -ets >nul 2>&1
logman delete "TPMProvisioningService" -ets >nul 2>&1
logman delete "Ude" -ets >nul 2>&1
logman delete "UserNotPresentTraceSession" -ets >nul 2>&1
logman delete "WdiContextLog" -ets >nul 2>&1
logman delete "WiFiDriverIHVSession" -ets >nul 2>&1
logman delete "WiFiSession" -ets >nul 2>&1
logman delete "iclsClient" -ets >nul 2>&1
logman delete "iclsProxy" -ets >nul 2>&1

:: Disable Telemetry Through Task Scheduler
schtasks /change /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" /disable >nul 2>&1
schtasks /change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" /disable >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Device Information\Device" /disable >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /disable >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /disable >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable >nul 2>&1
schtasks /change /TN "\Microsoftd\Office\OfficeTelemetryAgentFallBack" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\AitAgent" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul 2>&1
schtasks /end /tn "\Microsoft\Office\Office 15 Subscription Heartbeat" >nul 2>&1
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" >nul 2>&1
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" >nul 2>&1
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\AitAgent" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\StartupAppTask" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Autochk\Proxy" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Device Information\Device" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\PI\Sqm-Tasks" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>&1
schtasks /end /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" >nul 2>&1
schtasks /end /tn "\Microsoftd\Office\OfficeTelemetryAgentFallBack" >nul 2>&1

:: Disable Device History
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Game Bar Telemetry
reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Search History Logging
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

::Disbale Shared User App Data
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowSharedUserAppData" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Energy Logging
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Windows Error Reporting
echo Disable Windows Error Reporting
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable other Telemetry
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoExplicitFeedback" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v "SqmLoggerRunning" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v "SqmLoggerRunning" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "DisableOptinExperience" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "SqmLoggerRunning" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoActiveHelp" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\DeviceHealthAttestationService" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Peernet" /v "Disabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MicrosoftEdgeDataOptIn" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\FileHistory" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "DoSvc" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\DriverDatabase\Policies\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\DriverDatabase\Policies\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable AutoLoggers
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Credssp" /v "DebugLogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AppModel" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Cellcore" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Circular Kernel Context Logger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\CloudExperienceHostOobe" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DataMarket" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\HolographicDevice" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\LwtNetLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Mellanox-Kernel" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-AssignedAccess-Trace" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-Setup" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NBSMBLOGGER" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\PEAuthLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RdrLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\ReadyBoot" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SQMLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatform" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatformTel" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SocketHeciServer" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SpoolerLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TCPIPLOGGER" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TPMProvisioningService" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TileStore" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Tpm" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\UBPM" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WFP-IPsec Trace" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WdiContextLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSession" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSessionRepro" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiSession" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WinPhoneCritical" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsClient" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsProxy" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Office Telemetry
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "accesssolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "olksolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "onenotesolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "pptsolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "projectsolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "publishersolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "visiosolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "wdsolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "xlsolution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "agave" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "appaddins" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "comaddins" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "documentfiles" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "templatefiles" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Software\Policies\Microsoft\Office\16.0\osm" /v "EnableUpload" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Software\Policies\Microsoft\Office\16.0\osm" /v "Enablelogging" /t REG_DWORD /d "0" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
:: ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
:: ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
:: ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
:: ███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
:: ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝

cls
echo Optimizing Services

::Decrease Service Kill Time
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_DWORD /d "2000" /f >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

:: Optimize Service Host Split Threshold
:SvcHostOptimization
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                              How much RAM does your PC have?
echo.
echo.
echo                                        	    %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%8GB%t%                %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%16GB%t%
echo.
echo.
echo                                        	    %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%32GB%t%               %w%[%y% %c%%u%4%q%%t% %w%]%y% %c%64GB%t%
echo.
echo.
echo                                                     %w%[%y% %c%%u%5%q%%t% %w%]%y% %c%I don't know%t%
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto 8GB
if '%choice%'=='2' goto 16GB
if '%choice%'=='3' goto 32GB
if '%choice%'=='4' goto 64GB
if '%choice%'=='5' goto ServiceOptimizations

:8GB
cls
echo Optimize Service Host Split Threshold for 8GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "8388608" /f >nul 2>&1
timeout /t 3 /nobreak >nul 2>&1
goto ServiceOptimizations

:16GB
cls
echo Optimize Service Host Split Threshold for 16GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "16777216" /f >nul 2>&1
timeout /t 3 /nobreak >nul 2>&1
goto ServiceOptimizations

:32GB
cls
echo Optimize Service Host Split Threshold for 32GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "33554432" /f >nul 2>&1
timeout /t 3 /nobreak >nul 2>&1
goto ServiceOptimizations

:64GB
cls
echo Optimize Service Host Split Threshold for 64GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "67108864" /f >nul 2>&1
timeout /t 3 /nobreak >nul 2>&1
goto ServiceOptimizations

::Optimize Windows Services & Tasks
:ServiceOptimizations
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo                                          Do you want to disable Remote Services and Tasks?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto disableremote
if '%choice%'=='2' goto printsvc

:: Disable Remote Services & Tasks
:disableremote
echo Disable Remote Services & Tasks
sc config RemoteRegistry start= disabled
sc config RemoteAccess start= disabled
sc config WinRM start= disabled
sc config RmSvc start= disabled
timeout /t 1 /nobreak >nul 2>&1

:printsvc
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo                                          Do you want to disable Print Services and Tasks?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto disableprint
if '%choice%'=='2' goto bluetoothsvc

:: Disable Printer Services & Tasks
:disableprint
echo Disable Printer Services & Tasks
sc config PrintNotify start= disabled
sc config Spooler start= disabled
schtasks /Change /TN "Microsoft\Windows\Printing\EduPrintProv" /Disable
schtasks /Change /TN "Microsoft\Windows\Printing\PrinterCleanupTask" /Disable
timeout /t 1 /nobreak >nul 2>&1

:bluetoothsvc
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo                                          Do you want to disable Bluetooth Services and Tasks?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto disablebluetooth
if '%choice%'=='2' goto GraphicsOptimization

:: Disable Bluetooth Services & Tasks
:disablebluetooth
echo Disable Bluetooth Services & Tasks
sc config BTAGService start= disabled
sc config bthserv start= disabled
timeout /t 1 /nobreak >nul 2>&1

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
::  ██████╗ ██████╗  █████╗ ██████╗ ██╗  ██╗██╗ ██████╗███████╗     ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
:: ██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██║  ██║██║██╔════╝██╔════╝    ██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
:: ██║  ███╗██████╔╝███████║██████╔╝███████║██║██║     ███████╗    ██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ ███████║   ██║   ██║██║   ██║██╔██╗ ██║
:: ██║   ██║██╔══██╗██╔══██║██╔═══╝ ██╔══██║██║██║     ╚════██║    ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
:: ╚██████╔╝██║  ██║██║  ██║██║     ██║  ██║██║╚██████╗███████║    ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
::  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝     ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝                                                                                               
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:GraphicsOptimization
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                                    What GPU do you use?
echo.
echo.
echo                 	      %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%NVIDIA%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%AMD%t%               %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%IGPU%t%
echo.
echo.
echo                                                    %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%IGPU%t% 
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto NVIDIA
if '%choice%'=='2' goto AMD
if '%choice%'=='3' goto IGPU

:NVIDIA
cls
echo Applying NVIDIA Optimizations

:: NVIDIA Inspector Profile
:: curl -g -k -L -# -o "%temp%\nvidiaProfileInspector.zip" "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest/download/nvidiaProfileInspector.zip" >nul 2>&1 &:: Importiere Profile Inspector
:: powershell -NoProfile Expand-Archive '%temp%\nvidiaProfileInspector.zip' -DestinationPath '%temp%\NvidiaProfileInspector\' >nul 2>&1
:: curl -g -k -L -# -o "%temp%\NvidiaProfileInspector\Getreggeds-Nvidia-Profile.nip" "https://github.com/GetRegged/GetReggeds-Performance-Batch/raw/main/bin/Getreggeds-Nvidia-Profile.nip" >nul 2>&1
:: start "" /wait "%temp%\NvidiaProfileInspector\nvidiaProfileInspector.exe" -silentImport "%temp%\NvidiaProfileInspector\Getreggeds-Nvidia-Profile.nip" >nul 2>&1

:: Enable MSI Mode for GPU
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f  >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Set NVIDIA Latency Tolerance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "D3PCLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "LOWLATENCY" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f >nul 2>&1

:: Force Contigous Memory Allocation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable High-bandwidth Digital Content Protection (HDCP)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyGlobZero" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable TCC
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Tiled Display
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableTiledDisplay" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable NVIDIA Telemetry
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvBackend" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d "0" /f >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport1_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvDriverUpdateCheckDaily_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NVIDIA GeForce Experience SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1

:: NVIDIA Control Panal Language English
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "UserDefinedLocale" /t REG_DWORD /d "1024" /f >nul 2>&1

:: Disable NVIDIA Display Power Saving
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Write Combining
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable DPC'S for each Core
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable Old Image Sharpening
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f >nul 2>&1

:: Video Redraw Acceleration
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Acceleration.Level" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable NVIDIA 3D Vision Shortcuts
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DesktopStereoShortcuts" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "FeatureControl" /t REG_DWORD /d "4" /f >nul 2>&1

:: Disable Filter
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NVDeviceSupportKFilter" /t REG_DWORD /d "0" /f >nul 2>&1

:: Increased Dedicated Video Memory
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmCacheLoc" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set NVIDIA Driver Package Install Directory
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmDisableInst2Sys" /t REG_DWORD /d "0" /f >nul 2>&1

:: ReAllocate DMA Buffers
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmFbsrPagedDMA" /t REG_DWORD /d "1" /f >nul 2>&1

:: Change Performance Counter Permissions
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmProfilingAdminOnly" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DX Event Tracking
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TrackResetEngine" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Verifications in Block Transfer Operations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ValidateBlitSubRects" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable NVIDIA WDDM TDR
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDebugMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLimitCount" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLimitTime" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrTestMode" /t REG_DWORD /d "0" /f >nul 2>&1

cls
echo Completed
timeout /t 2 /nobreak > NUL
goto menuorexit

:AMD
cls
echo Applying AMD Optimizations

:: Enable MSI Mode for GPU
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Disable Display Refresh Rate Override
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable SnapShot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Anti Aliasing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t REG_SZ /d "0" /f >nul 2>&1

:: Disable AllowSubscription
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Anisotropic Filtering
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t REG_SZ /d "0" /f >nul 2>&1

:: Disable AllowRSOverlay
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t REG_SZ /d "false" /f >nul 2>&1 

:: Enable Adaptive DeInterlacing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable AllowSkins
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t REG_SZ /d "false" /f >nul 2>&1

:: Disable AutoColorDepthReduction_NA
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Power Gating
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePowerGating" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Clock Gating
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableVceSwClockGating" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUvdClockGating" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Active State Power Management (ASPM)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Ultra Low Power States (ULPS)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t REG_SZ /d "0" /f >nul 2>&1

:: Enable De-Lag
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Frame Rate Target (FRT)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DMA
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable BlockWrite
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable StutterMode
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable GPU Mem Clock Sleep State
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Thermal Throttling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set Main3D
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f >nul 2>&1

:: Set FlipQueueSize
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f >nul 2>&1

:: Set Shader Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f >nul 2>&1

:: Configuring TFQ
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f >nul 2>&1

:: Disable High-Bandwidth Digital Content Protection (HDCP)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t REG_BINARY /d "0100000001000000" /f >nul 2>&1

:: Disable GPU Power Down
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_GPUPowerDownEnabled" /t REG_DWORD /d "1" /f >nul 2>&1


:: Disable AMD Logging
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1

:: AMD Tweaks (melodytheneko)
for %%a in (LTRSnoopL1Latency LTRSnoopL0Latency LTRNoSnoopL1Latency LTRMaxNoSnoopLatency KMD_RpmComputeLatency
        DalUrgentLatencyNs memClockSwitchLatency PP_RTPMComputeF1Latency PP_DGBMMMaxTransitionLatencyUvd
        PP_DGBPMMaxTransitionLatencyGfx DalNBLatencyForUnderFlow
        BGM_LTRSnoopL1Latency BGM_LTRSnoopL0Latency BGM_LTRNoSnoopL1Latency BGM_LTRNoSnoopL0Latency
        BGM_LTRMaxSnoopLatencyValue BGM_LTRMaxNoSnoopLatencyValue) do (reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "%%a" /t REG_DWORD /d "1" /f >nul 2>&1
)

cls
echo Completed
timeout /t 2 /nobreak > NUL
goto menuorexit

:IGPU
cls
echo Applying IGPU Optimizations

:: Dedicated Segment Size
reg add "HKLM\SOFTWARE\Intel\GMM" /v "DedicatedSegmentSize" /t REG_DWORD /d "512" /f >nul 2>&1

cls
echo Completed
timeout /t 2 /nobreak > NUL
goto menuorexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗    ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
:: ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
:: ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
:: ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║    ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
:: ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
::  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝     ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:WindowsUpdates
cls
echo Disable Windows Update

:: Start > Settings > Update & Security > Windows Update > Get ready for Windows 11... > Dismiss notification
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "SvDismissedState" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Update & Security > Windows Update > Advanced options > Pause updates > Activate pause update feature
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UpdatePolicy\Settings" /v "PausedFeatureStatus" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UpdatePolicy\Settings" /v "PausedQualityStatus" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Update & Security > Windows Update > Advanced options > Pause updates > Enable Converged Update Stack
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX" /v "IsConvergedUpdateStackEnabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Update & Security > Windows Update > Advanced options > Pause updates > Until January 1st, 2069
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "ActiveHoursEnd" /t REG_DWORD /d "17" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "ActiveHoursStart" /t REG_DWORD /d "8" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "FlightCommitted" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "LastToastAction" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "UxOption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "InsiderProgramEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "PendingRebootStartTime" /t REG_SZ /d "2019-07-28T03:07:38Z" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "PauseFeatureUpdatesStartTime" /t REG_SZ /d "2019-07-28T10:38:56Z" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "PauseFeatureUpdatesEndTime" /t REG_SZ /d "2069-01-01T10:38:56Z" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "PauseQualityUpdatesStartTime" /t REG_SZ /d "2019-07-28T10:38:56Z" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "PauseQualityUpdatesEndTime" /t REG_SZ /d "2069-01-01T10:38:56Z" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "PauseUpdatesExpiryTime" /t REG_SZ /d "2069-01-01T10:38:56Z" /f >nul 2>&1

:: Start > Settings > Update & Security > Windows Update > Automatically download drivers > Off
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f >nul 2>&1

:: Start > Settings > Update & Security > Delivery Optimization > Allow downloads from other PCs > Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "63" /f >nul 2>&1

:: Start > Settings > Update & Security > Troubleshoot > Off
reg add "HKLM\SOFTWARE\Microsoft\WindowsMitigation" /v "UserPreference" /t REG_DWORD /d "1" /f >nul 2>&1

:: Start > Settings > Update & Security > Find my device > Off
reg add "HKLM\SOFTWARE\Microsoft\MdmCommon\SettingValues" /v "ILocationSyncEnabled" /t REG_DWORD /d "0" /f >nul 2>&1   

:: Disable Auto Install Minor Updates (not in Windows Settings App Included)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Windows Update And Store Services And Tasks (not in Windows Settings App Included)
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpdatePeriod" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgradePeriod" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f
sc stop BITS
sc stop ClipSVC
sc stop InstallService
sc stop LanmanServer
sc stop PushToInstall
sc stop UsoSvc
sc stop uhssvc
sc stop uhssvc
sc stop upfc
sc stop wuauserv
sc config BITS start= disabled
sc config ClipSVC start= disabled
sc config InstallService start= disabled
sc config LanmanServer start= disabled
sc config UsoSvc start= disabled
sc config uhssvc start= disabled
sc config wuauserv start= disabled
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BITS" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\InstallService" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ossrs" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\uhssvc" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\upfc" /v Start /t reg_dword /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v Start /t reg_dword /d 4 /f
schtasks /Change /TN "Microsoft\Windows\InstallService\ScanForUpdates" /Disable
schtasks /Change /TN "Microsoft\Windows\InstallService\ScanForUpdatesAsUser" /Disable
schtasks /Change /TN "Microsoft\Windows\InstallService\SmartRetry" /Disable
schtasks /Change /TN "Microsoft\Windows\InstallService\WakeUpAndContinueUpdates" /Disable
schtasks /Change /TN "Microsoft\Windows\InstallService\WakeUpAndScanForUpdates" /Disable
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Report policies" /Disable
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /Disable
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /Disable
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" /Disable
schtasks /Change /TN "Microsoft\Windows\WaaSMedic\PerformRemediation" /Disable
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
timeout /t 1 /nobreak > NUL

cls
echo Completed
timeout /t 2 /nobreak > NUL
goto menuorexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ██████╗  ██████╗ ██╗    ██╗███████╗██████╗     ██████╗ ██╗      █████╗ ███╗   ██╗
:: ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗    ██╔══██╗██║     ██╔══██╗████╗  ██║
:: ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝    ██████╔╝██║     ███████║██╔██╗ ██║
:: ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗    ██╔═══╝ ██║     ██╔══██║██║╚██╗██║
:: ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║    ██║     ███████╗██║  ██║██║ ╚████║
:: ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
::Power Plan Optimizatons
:WindowsPowerPlan
cls

:: Import GetReggeds Power Plan
echo Importing Bitsum Highest Performance Power Plan
curl -g -k -L -# -o "%temp%\Bitsum-Highest-Performance.pow" "https://github.com/GetRegged/GetReggeds-Performance-Batch/raw/main/bin/Bitsum-Highest-Performance.pow" >nul 2>&1
powercfg -import "%temp%\Bitsum-Highest-Performance.pow" 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111 >nul 2>&1

:: Disable Hibernation
echo Disable Hibernation
powercfg /h off >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Sleep Study
echo Disable Sleep Study
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

cls
echo Completed
timeout /t 2 /nobreak > NUL

cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo                                          Do you want to delete all other plans?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto DeletePlans
if '%choice%'=='2' goto menuorexit

:DeletePlans
cls
echo Deleting other power plans
timeout /t 2 /nobreak > NUL

:: Delete Balanced Power Plan
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1

:: Delete Power Saver Power Plan
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1

:: Delete High Performance Power Plan
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

:: Delete Ultimate Performance Power Plan
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Delete AMD Ryzen Balanced Power Plan
powercfg -delete 9897998c-92de-4669-853f-b7cd3ecb2790 >nul 2>&1

:: Delete Dynamic Boost Performance
powercfg -delete 10728b17-d7bd-4ca1-990c-b4f7c030f8cd >nul 2>&1

:: Delete GameTurbo
powercfg -delete ce9fa8b3-8e9e-42db-b4e1-e6297f6cdd7e >nul 2>&1

cls
echo Completed 
timeout /t 2 /nobreak > NUL
goto menuorexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗    ████████╗███████╗███╗   ███╗██████╗      ██████╗██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
:: ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
:: ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗       ██║   █████╗  ██╔████╔██║██████╔╝    ██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██████╔╝
:: ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║       ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝     ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██╔══██╗
:: ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║       ██║   ███████╗██║ ╚═╝ ██║██║         ╚██████╗███████╗███████╗██║  ██║██║ ╚████║███████╗██║  ██║
::  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝       ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝          ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:WindowsTempCleaner
cls
echo Cleaning Temporary Files and Folders

:: Reset & Delete IP-Cache
ipconfig /flushdns >nul 2>&1
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1
netsh int ip reset >nul 2>&1
netsh int ipv4 reset >nul 2>&1
netsh int ipv6 reset >nul 2>&1
netsh int tcp reset >nul 2>&1
netsh winsock reset >nul 2>&1
netsh branchcache reset >nul 2>&1
netsh http flush logbuffer >nul 2>&1

:: Delete Temporary Cache & Files
del /s /f /q "%AppData%\Discord\Cache" >nul 2>&1
del /s /f /q "%AppData%\Discord\Code Cache" >nul 2>&1
del /s /f /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache" >nul 2>&1
del /s /f /q "%LocalAppData%\Microsoft\Windows\Explorer\*.db" >nul 2>&1
del /s /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /s /f /q "%LocalAppData%\Microsoft\Windows\INetCache" >nul 2>&1
del /s /f /q "%LocalAppData%\Microsoft\Windows\INetCookies" >nul 2>&1
del /s /f /q "%LocalAppData%\Microsoft\Windows\WebCache" >nul 2>&1
del /s /f /q "%ProgramData%\Microsoft\Windows\Installer" >nul 2>&1
del /s /f /q "%ProgramData%\USOPrivate\UpdateStore" >nul 2>&1
del /s /f /q "%ProgramData%\USOShared\Logs" >nul 2>&1
del /s /f /q "%systemdrive%\$Recycle.Bin" >nul 2>&1
del /s /f /q "%temp%" >nul 2>&1
del /s /f /q "%windir%\Installer\$PatchCache$" >nul 2>&1
del /s /f /q "%windir%\Logs" >nul 2>&1
del /s /f /q "%windir%\Prefetch" >nul 2>&1
del /s /f /q "%windir%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization" >nul 2>&1
del /s /f /q "%windir%\SoftwareDistribution\Download" >nul 2>&1
del /s /f /q "%windir%\System32\SleepStudy" >nul 2>&1
del /s /f /q "%windir%\temp" >nul 2>&1

:: Delete Temporary Folders
rd /s /q "%SystemDrive%\$GetCurrent" >nul 2>&1
rd /s /q "%SystemDrive%\$SysReset" >nul 2>&1
rd /s /q "%SystemDrive%\$WinREAgent" >nul 2>&1
rd /s /q "%SystemDrive%\$Windows.~BT" >nul 2>&1
rd /s /q "%SystemDrive%\$Windows.~WS" >nul 2>&1
rd /s /q "%SystemDrive%\Intel" >nul 2>&1
rd /s /q "%SystemDrive%\AMD" >nul 2>&1
rd /s /q "%SystemDrive%\OneDriveTemp" >nul 2>&1
rd /s /q "%SystemDrive%\System Volume Information" >nul 2>&1

FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

:do_clear
wevtutil.exe cl %1
cls
echo Completed
timeout /t 2 /nobreak > NUL
goto :menu

:noAdmin
cls
echo Completed
timeout /t 2 /nobreak > NUL
goto menuorexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
::  ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗ ██████╗ 
:: ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝ 
:: ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗ 
:: ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║██╔═══██╗
:: ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║╚██████╔╝
::  ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ 
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:Option6
cls
:: INSERT OPTION 6 HERE
:: INSERT OPTION 6 HERE
:: INSERT OPTION 6 HERE
echo Completed
timeout /t 2 /nobreak > NUL
goto menuorexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ███╗   ███╗███████╗███╗   ██╗██╗   ██╗     ██████╗ ██████╗     ███████╗██╗  ██╗██╗████████╗
:: ████╗ ████║██╔════╝████╗  ██║██║   ██║    ██╔═══██╗██╔══██╗    ██╔════╝╚██╗██╔╝██║╚══██╔══╝
:: ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║    ██║   ██║██████╔╝    █████╗   ╚███╔╝ ██║   ██║   
:: ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║    ██║   ██║██╔══██╗    ██╔══╝   ██╔██╗ ██║   ██║   
:: ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝    ╚██████╔╝██║  ██║    ███████╗██╔╝ ██╗██║   ██║   
:: ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝      ╚═════╝ ╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝   
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:menuorexit
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Menu%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%Exit%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Menu
if '%choice%'=='2' goto Exit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: ███████╗██╗  ██╗██╗████████╗
:: ██╔════╝╚██╗██╔╝██║╚══██╔══╝
:: █████╗   ╚███╔╝ ██║   ██║   
:: ██╔══╝   ██╔██╗ ██║   ██║   
:: ███████╗██╔╝ ██╗██║   ██║   
:: ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝   
::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:Exit
cls 
exit