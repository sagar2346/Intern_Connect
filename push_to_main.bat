@echo off
echo Pushing code to main branch...
echo.

REM Check if Git is installed
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Git is not installed or not in your PATH.
    echo Please install Git and try again.
    pause
    exit /b 1
)

REM Initialize Git repository if not already initialized
if not exist ".git" (
    echo Initializing Git repository...
    git init
)

REM Add all files to the staging area
echo Adding files to staging area...
git add .

REM Commit the changes
echo Committing changes...
git commit -m "Fix deployment issues and improve project structure"

REM Check if main branch exists
git show-ref --verify --quiet refs/heads/main
if %ERRORLEVEL% NEQ 0 (
    echo Creating main branch...
    git branch -M main
) else (
    echo Switching to main branch...
    git checkout main
)

REM Ask for remote repository URL if not already set
git remote -v | findstr origin >nul
if %ERRORLEVEL% NEQ 0 (
    set /p REMOTE_URL="Enter remote repository URL (e.g., https://github.com/username/repo.git): "
    git remote add origin %REMOTE_URL%
)

REM Push to main branch
echo Pushing to main branch...
git push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo Failed to push to main branch. Please check your Git configuration and try again.
    pause
    exit /b 1
)

echo.
echo Code successfully pushed to main branch!
echo.

pause
