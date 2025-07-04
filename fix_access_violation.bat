@echo off
echo Fixing ACCESS_VIOLATION crash issue...
echo.

set "RELEASE_DIR=build\src\Release"
set "PACKAGE_DIR=build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

echo 1. Checking for mingda-slicer.dll issue...
if exist "%RELEASE_DIR%\mingda-slicer.dll" (
    echo [FOUND] mingda-slicer.dll in Release directory
    echo File size: 
    for %%A in ("%RELEASE_DIR%\mingda-slicer.dll") do echo %%~zA bytes
) else (
    echo [WARNING] mingda-slicer.dll not found in Release directory
)

if exist "%PACKAGE_DIR%\mingda-slicer.dll" (
    echo [FOUND] mingda-slicer.dll in Package directory
    for %%A in ("%PACKAGE_DIR%\mingda-slicer.dll") do echo %%~zA bytes
)

echo.
echo 2. The crash appears to be in OpenCASCADE (OCCT) and HID libraries
echo Checking OCCT DLLs...

for %%f in (
    "TKBRep.dll"
    "TKMath.dll"
    "TKernel.dll"
    "TKG3d.dll"
    "TKGeomBase.dll"
    "TKTopAlgo.dll"
) do (
    if exist "%PACKAGE_DIR%\%%~f" (
        echo [OK] %%~f found
    ) else (
        echo [MISSING] %%~f
        if exist "%RELEASE_DIR%\%%~f" (
            echo Copying from Release...
            copy "%RELEASE_DIR%\%%~f" "%PACKAGE_DIR%\"
        )
    )
)

echo.
echo 3. Checking hidapi.dll...
if not exist "%PACKAGE_DIR%\hidapi.dll" (
    echo [MISSING] hidapi.dll
    if exist "%RELEASE_DIR%\hidapi.dll" (
        copy "%RELEASE_DIR%\hidapi.dll" "%PACKAGE_DIR%\"
    )
)

echo.
echo 4. Testing with disabled HID support...
echo Creating test batch...
echo @echo off > "%PACKAGE_DIR%\test_no_hid.bat"
echo set ORCASLICER_NO_HID=1 >> "%PACKAGE_DIR%\test_no_hid.bat"
echo mingda-slicer.exe %%* >> "%PACKAGE_DIR%\test_no_hid.bat"

echo.
echo 5. The main issue: mingda-slicer is built as DLL instead of EXE!
echo This is wrong. Let's check the build configuration...

echo.
pause