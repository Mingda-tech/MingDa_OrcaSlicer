@echo off
echo Fixing MingDa OrcaSlicer package...
echo.

REM Set directories
set "RELEASE_DIR=build\src\Release"
set "PACKAGE_DIR=build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

REM Create package directory if not exists
if not exist "%PACKAGE_DIR%" (
    echo ERROR: Package directory not found!
    exit /b 1
)

REM Copy all DLLs from Release to Package
echo Copying all DLLs from Release to Package directory...
xcopy /Y "%RELEASE_DIR%\*.dll" "%PACKAGE_DIR%\"

REM Also copy resources if missing
if not exist "%PACKAGE_DIR%\resources" (
    echo Copying resources directory...
    xcopy /E /I /Y "resources" "%PACKAGE_DIR%\resources"
)

REM Copy any missing executables
xcopy /Y "%RELEASE_DIR%\*.exe" "%PACKAGE_DIR%\"

echo.
echo Done! Now rebuild the installer:
echo 1. Delete the old installer: del "build\mingda-slicer_Windows_Installer_V2.2.7.exe"
echo 2. Run in VS Command Prompt: cd build ^&^& cpack -C Release
echo.
pause