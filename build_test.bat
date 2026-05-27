@echo off
setlocal
cd /d "%~dp0"

echo Current folder:
echo %CD%
echo.

if not exist "%CD%\health_tray_reminder.py" (
    echo ERROR: health_tray_reminder.py was not found in this folder.
    pause
    exit /b 1
)

set PYTHON_CMD=python
python --version >nul 2>nul
if errorlevel 1 (
    set PYTHON_CMD=py -3
)

echo Python command:
echo %PYTHON_CMD%
echo.

%PYTHON_CMD% --version
if errorlevel 1 (
    echo.
    echo ERROR: Python was not found from this batch file.
    pause
    exit /b 1
)

echo.
echo Installing packages...
%PYTHON_CMD% -m pip install pystray plyer schedule pillow pyinstaller
if errorlevel 1 (
    echo.
    echo ERROR: Package installation failed.
    pause
    exit /b 1
)

echo.
echo Building test app...
%PYTHON_CMD% -m PyInstaller -y --noconsole --name HealthReminderTest --distpath "%CD%\dist-test" --workpath "%CD%\build-test" --specpath "%CD%" "%CD%\health_tray_reminder.py"
if errorlevel 1 (
    echo.
    echo ERROR: PyInstaller test build failed.
    pause
    exit /b 1
)

if not exist "%CD%\dist-test\HealthReminderTest\HealthReminderTest.exe" (
    echo.
    echo ERROR: Test build finished, but HealthReminderTest.exe was not created.
    pause
    exit /b 1
)

echo.
echo SUCCESS.
echo Open this folder:
echo %CD%\dist-test\HealthReminderTest
echo.
pause
