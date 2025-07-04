@echo off
echo Rebuilding MingDa OrcaSlicer with fix...
echo.

echo 1. Cleaning old build files...
if exist "build\src\Release\mingda-slicer.dll" (
    echo Deleting incorrect mingda-slicer.dll...
    del "build\src\Release\mingda-slicer.dll"
)

echo.
echo 2. Reconfiguring CMake...
cd build
cmake ..
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] CMake configuration failed!
    pause
    exit /b 1
)

echo.
echo 3. Building mingda-slicer.exe (this may take a while)...
msbuild src\mingda-slicer.vcxproj /p:Configuration=Release /p:Platform=x64
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo.
echo 4. Verifying build output...
if exist "src\Release\mingda-slicer.exe" (
    echo [OK] mingda-slicer.exe built successfully!
    for %%A in ("src\Release\mingda-slicer.exe") do echo Size: %%~zA bytes
) else (
    echo [ERROR] mingda-slicer.exe not found!
    pause
    exit /b 1
)

echo.
echo 5. Building package...
msbuild PACKAGE.vcxproj /p:Configuration=Release
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Package build failed, but you can still use the exe from build\src\Release
)

echo.
echo Build complete!
echo.
echo To test: cd build\src\Release && mingda-slicer.exe
echo.
pause