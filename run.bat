REM set mypath=%cd%
REM cd installers
PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File "%~dp0GWScript.ps1"' -Verb RunAs}"