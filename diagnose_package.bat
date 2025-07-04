@echo off
echo Diagnosing MingDa OrcaSlicer package issue...
echo.

REM Check if executable exists
if exist "build\src\Release\mingda-slicer.exe" (
    echo [OK] Main executable found: build\src\Release\mingda-slicer.exe
) else (
    echo [ERROR] Main executable NOT found!
    exit /b 1
)

REM Check file size
for %%A in ("build\src\Release\mingda-slicer.exe") do (
    echo Executable size: %%~zA bytes
)

REM Check dependencies
echo.
echo Checking dependencies with dumpbin (if available)...
where dumpbin >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    dumpbin /dependents "build\src\Release\mingda-slicer.exe"
) else (
    echo dumpbin not found in PATH. Please ensure Visual Studio tools are available.
)

REM Check for common missing files
echo.
echo Checking for common dependencies...
set "missing=0"

for %%f in (
    "build\src\Release\libslic3r.dll"
    "build\src\Release\libslic3r_gui.dll"  
    "build\src\Release\boost_system-vc143-mt-x64-1_78.dll"
    "build\src\Release\boost_thread-vc143-mt-x64-1_78.dll"
    "build\src\Release\boost_filesystem-vc143-mt-x64-1_78.dll"
    "build\src\Release\boost_regex-vc143-mt-x64-1_78.dll"
) do (
    if exist %%f (
        echo [OK] Found: %%~nxf
    ) else (
        echo [MISSING] %%~nxf
        set "missing=1"
    )
)

REM Check resources
echo.
echo Checking resources...
if exist "build\src\Release\resources" (
    echo [OK] Resources directory found
) else (
    echo [WARNING] Resources directory not found
)

REM Try to run the executable
echo.
echo Attempting to run mingda-slicer.exe...
cd build\src\Release
mingda-slicer.exe --version
echo Exit code: %ERRORLEVEL%

pause