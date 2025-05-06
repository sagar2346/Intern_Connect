@echo off
echo Building and preparing InternConnect application...
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Java is not installed or not in your PATH.
    echo Please install Java and try again.
    pause
    exit /b 1
)

echo Java is installed. Proceeding...
echo.

REM Create a lib directory if it doesn't exist
if not exist "lib" mkdir lib

REM Download dependencies if they don't exist
if not exist "lib\jakarta.servlet-api-5.0.0.jar" (
    echo Downloading Jakarta Servlet API...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar' -OutFile 'lib\jakarta.servlet-api-5.0.0.jar'}"
)

if not exist "lib\mysql-connector-j-8.0.33.jar" (
    echo Downloading MySQL Connector...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar' -OutFile 'lib\mysql-connector-j-8.0.33.jar'}"
)

REM Create a classes directory for compiled files
if not exist "classes" mkdir classes

REM Compile the Java files
echo Compiling Java files...
javac -cp "lib\*;classes" -d classes src\main\java\com\internconnect\*.java src\main\java\com\internconnect\dao\*.java src\main\java\com\internconnect\model\*.java src\main\java\com\internconnect\servlet\*.java src\main\java\com\internconnect\util\*.java 2>compile_errors.txt

if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed. See compile_errors.txt for details.
    pause
    exit /b 1
)

echo Compilation successful.
echo.

REM Create a dist directory for the WAR file
if not exist "dist" mkdir dist

REM Create a temporary directory for the WAR structure
if not exist "temp" mkdir temp
if not exist "temp\WEB-INF" mkdir temp\WEB-INF
if not exist "temp\WEB-INF\classes" mkdir temp\WEB-INF\classes
if not exist "temp\WEB-INF\lib" mkdir temp\WEB-INF\lib

REM Copy the compiled classes
xcopy /E /Y classes\* temp\WEB-INF\classes\

REM Copy the libraries
xcopy /Y lib\*.jar temp\WEB-INF\lib\

REM Copy the web.xml file
xcopy /Y src\main\webapp\WEB-INF\web.xml temp\WEB-INF\

REM Copy the JSP files and other web resources
xcopy /E /Y src\main\webapp\*.jsp temp\
if exist "src\main\webapp\view" xcopy /E /Y src\main\webapp\view\*.jsp temp\view\
if exist "src\main\webapp\css" xcopy /E /Y src\main\webapp\css\*.css temp\css\
if exist "src\main\webapp\js" xcopy /E /Y src\main\webapp\js\*.js temp\js\
if exist "src\main\webapp\images" xcopy /E /Y src\main\webapp\images\*.* temp\images\

REM Create the WAR file
echo Creating WAR file...
cd temp
jar -cf ..\dist\internconnect.war *
cd ..

echo.
echo Build completed successfully!
echo The WAR file is located in the dist directory.
echo.

REM Check if Tomcat is installed
set "TOMCAT_INSTALLED=false"
for %%I in (C:\Tomcat* C:\Program Files\Tomcat* C:\Program Files (x86)\Tomcat*) do (
    if exist "%%I\bin\startup.bat" (
        set "TOMCAT_HOME=%%I"
        set "TOMCAT_INSTALLED=true"
    )
)

if "%TOMCAT_INSTALLED%"=="true" (
    echo Tomcat found at %TOMCAT_HOME%
    echo.
    
    REM Ask if user wants to deploy to Tomcat
    set /p DEPLOY_CHOICE="Do you want to deploy to Tomcat? (Y/N): "
    if /i "%DEPLOY_CHOICE%"=="Y" (
        echo Deploying to Tomcat...
        
        REM Copy the WAR file to Tomcat webapps directory
        copy /Y dist\internconnect.war "%TOMCAT_HOME%\webapps\"
        
        REM Check if Tomcat is running
        tasklist /FI "IMAGENAME eq tomcat*.exe" 2>NUL | find /I /N "tomcat" >NUL
        if %ERRORLEVEL% NEQ 0 (
            echo Starting Tomcat...
            start "" "%TOMCAT_HOME%\bin\startup.bat"
        ) else (
            echo Tomcat is already running.
        )
        
        echo.
        echo Application deployed successfully!
        echo You can access the application at http://localhost:8080/internconnect
    ) else (
        echo Deployment skipped.
    )
) else (
    echo Tomcat not found. Please install Tomcat or manually deploy the WAR file.
)

echo.
pause
