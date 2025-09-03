@echo off
setlocal

:: ============================================================================
:: Configuration
:: ============================================================================

set "EXTENSION_NAME=linkding"
set "DIST_DIR=dist"
set "ZIP_FILE=%DIST_DIR%\%EXTENSION_NAME%.zip"
set "INCLUDE_ITEMS=manifest.json build icons options popup styles"

:: ============================================================================
:: Build Script
:: ============================================================================

echo --- Updating dependencies ---
call npm install
if errorlevel 1 (
    echo ERROR: 'npm install' failed. & pause & exit /b 1
)

echo.
echo --- Building extension ---
call npm run build
if errorlevel 1 (
    echo ERROR: 'npm run build' failed. & pause & exit /b 1
)

echo.
echo --- Preparing output directory ---
if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"

echo.
echo --- Starting packaging process (DEBUG MODE) ---

echo [DEBUG] Checking for required files and folders...
if not exist "manifest.json" (
    echo [FATAL ERROR] manifest.json does not exist!
    pause
    exit /b 1
)
if not exist "build" (
    echo [FATAL ERROR] The 'build' directory does not exist. The build step may have failed.
    pause
    exit /b 1
)
echo [DEBUG] Required items seem to exist.

echo.
echo [DEBUG] Locating 7-Zip...
:: We remove >nul to see the output of the 'where' command
where 7z
if errorlevel 1 (
    echo [FATAL ERROR] 7-Zip (7z.exe) not found in your PATH.
    pause
    exit /b 1
)
echo [DEBUG] 7-Zip was found at the location above.

echo.
echo [DEBUG] Deleting old zip file if it exists...
if exist "%ZIP_FILE%" del "%ZIP_FILE%"
echo [DEBUG] Old zip file handled.

echo.
echo [DEBUG] The script will now attempt to create the zip file.
echo [DEBUG] It will run this command:
echo 7z a -tzip "%ZIP_FILE%" %INCLUDE_ITEMS%
echo.
pause

:: Create the archive.
call 7z a -tzip "%ZIP_FILE%" %INCLUDE_ITEMS%
if errorlevel 1 (
    echo [FATAL ERROR] 7-Zip failed during the archiving process.
    pause
    exit /b 1
)

echo.
echo ✅ Done!
pause
endlocal