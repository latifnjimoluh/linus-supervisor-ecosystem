@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ======= CONFIGURATION =======
SET PGPASSWORD=Nexus2023.
SET "PGBIN=C:\Program Files\PostgreSQL\17\bin"
REM =============================

REM Titre & Menu
title 🐘 PostgreSQL Manager
cls
echo ===============================
echo        🐘 Gestion PostgreSQL
echo ===============================
echo [1] 🗑️  Supprimer une base
echo [2] 🆕 Créer une base
echo [3] 💾 Sauvegarder une base
echo [4] ♻️  Restaurer une base
echo [5] 🚪 Quitter
echo.
set /p opt="👉 Choisissez une option (1-5): "

if "%opt%"=="1" goto DROP
if "%opt%"=="2" goto CREATE
if "%opt%"=="3" goto BACKUP
if "%opt%"=="4" goto RESTORE
if "%opt%"=="5" exit

echo ❌ Option invalide.
goto END

:DROP
set /p DBNAME="Nom de la base à supprimer: "
echo 🔄 Fermeture des connexions actives...
"%PGBIN%\psql.exe" -U postgres -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DBNAME%';"

echo 🗑️ Suppression de la base %DBNAME%...
"%PGBIN%\dropdb.exe" -U postgres %DBNAME%
goto END

:CREATE
set /p DBNAME="Nom de la base à créer: "
echo 🆕 Création de la base %DBNAME%...
"%PGBIN%\createdb.exe" -U postgres %DBNAME%
goto END

:BACKUP
set /p DBNAME="Nom de la base à sauvegarder: "
set /p BACKUPFILE="Chemin de sauvegarde complet (.sql): "
echo 💾 Sauvegarde de %DBNAME% vers "%BACKUPFILE%" ...
"%PGBIN%\pg_dump.exe" -U postgres %DBNAME% > "%BACKUPFILE%"
if %ERRORLEVEL%==0 (
  echo ✅ Sauvegarde réussie.
) else (
  echo ❌ Échec de la sauvegarde.
)
goto END

:RESTORE
set /p DBNAME="Nom de la base à restaurer: "
set /p BACKUPFILE="Chemin du fichier de backup (.sql): "

if not exist "%BACKUPFILE%" (
  echo ❌ Le fichier "%BACKUPFILE%" n'existe pas.
  goto END
)

echo 🔄 Fermeture des connexions actives...
"%PGBIN%\psql.exe" -U postgres -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DBNAME%';"

echo 🗑️ Suppression de l'ancienne base...
"%PGBIN%\dropdb.exe" -U postgres %DBNAME%

echo 🆕 Création de la nouvelle base...
"%PGBIN%\createdb.exe" -U postgres %DBNAME%

echo ♻️ Restauration de la base depuis "%BACKUPFILE%" ...
"%PGBIN%\psql.exe" -U postgres -d %DBNAME% -f "%BACKUPFILE%"

if %ERRORLEVEL%==0 (
  echo ✅ Restauration réussie.
) else (
  echo ❌ Échec de la restauration.
)
goto END

:END
echo.
echo ✅ Opération terminée. Appuyez sur une touche pour quitter...
pause > nul
exit
