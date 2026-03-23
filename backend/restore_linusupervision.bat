@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ======= CONFIGURATION PAR DÉFAUT =======
SET "PGBIN=C:\Program Files\PostgreSQL\17\bin"
REM Mot de passe local par défaut (modifiable au prompt)
SET "PGPASSWORD_LOCAL=Nexus2023."
REM Hôte Render par défaut
SET "RENDER_HOST=dpg-d2dm1995pdvs73f1sc60-a.oregon-postgres.render.com"
SET "RENDER_PORT=5432"
SET "RENDER_DB=linsup"
SET "RENDER_USER=linsup_user"
REM ========================================

title 🐘 PostgreSQL Manager
:MENU
cls
echo ===============================
echo        🐘 Gestion PostgreSQL
echo ===============================
echo [1] 🗑️  Supprimer une base (local)
echo [2] 🆕 Créer une base (local)
echo [3] 💾 Sauvegarder une base locale (--clean --if-exists)
echo [4] ♻️ Restaurer un .sql dans Render
echo [5] 🔁 Migrer DIRECT local -> Render (pipe)
echo [6] ⚙️  Tester la connexion Render
echo [7] 🚪 Quitter
echo.
set /p opt="👉 Choisissez une option (1-7): "

if "%opt%"=="1" goto DROP
if "%opt%"=="2" goto CREATE
if "%opt%"=="3" goto BACKUP_CLEAN
if "%opt%"=="4" goto RESTORE_RENDER
if "%opt%"=="5" goto MIGRATE_PIPE
if "%opt%"=="6" goto TEST_RENDER
if "%opt%"=="7" goto END

echo ❌ Option invalide.
pause
goto MENU

:DROP
set /p DBNAME="Nom de la base locale à supprimer: "
if "%DBNAME%"=="" (echo ❌ Nom vide.& pause & goto MENU)

REM Demande éventuelle du mot de passe local
set /p PGPASSWORD_LOCAL="Mot de passe local postgres (ENTER pour defaut: %PGPASSWORD_LOCAL%): "
if "%PGPASSWORD_LOCAL%"=="" set "PGPASSWORD_LOCAL=Nexus2023."

echo 🔄 Fermeture des connexions actives...
set "PGPASSWORD=%PGPASSWORD_LOCAL%"
"%PGBIN%\psql.exe" -h localhost -U postgres -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DBNAME%';"

echo 🗑️ Suppression de la base %DBNAME%...
"%PGBIN%\dropdb.exe" -h localhost -U postgres %DBNAME%
if errorlevel 1 (echo ❌ Echec DROP DB.& pause) else (echo ✅ Supprimée.& pause)
goto MENU

:CREATE
set /p DBNAME="Nom de la base locale à créer: "
if "%DBNAME%"=="" (echo ❌ Nom vide.& pause & goto MENU)

set /p PGPASSWORD_LOCAL="Mot de passe local postgres (ENTER pour defaut: %PGPASSWORD_LOCAL%): "
if "%PGPASSWORD_LOCAL%"=="" set "PGPASSWORD_LOCAL=Nexus2023."

echo 🆕 Création de la base %DBNAME%...
set "PGPASSWORD=%PGPASSWORD_LOCAL%"
"%PGBIN%\createdb.exe" -h localhost -U postgres %DBNAME%
if errorlevel 1 (echo ❌ Echec CREATE DB.& pause) else (echo ✅ Créée.& pause)
goto MENU

:BACKUP_CLEAN
set /p DBNAME="Nom de la base locale à sauvegarder: "
if "%DBNAME%"=="" (echo ❌ Nom vide.& pause & goto MENU)
set /p BACKUPFILE="Chemin complet de sortie (.sql) [ex: D:\backup_linsup.sql]: "
if "%BACKUPFILE%"=="" (echo ❌ Chemin vide.& pause & goto MENU)

set /p PGPASSWORD_LOCAL="Mot de passe local postgres (ENTER pour defaut: %PGPASSWORD_LOCAL%): "
if "%PGPASSWORD_LOCAL%"=="" set "PGPASSWORD_LOCAL=Nexus2023."

echo 💾 Dump propre de %DBNAME% vers "%BACKUPFILE%" ...
set "PGPASSWORD=%PGPASSWORD_LOCAL%"
"%PGBIN%\pg_dump.exe" --clean --if-exists -h localhost -U postgres -d %DBNAME% > "%BACKUPFILE%"
if errorlevel 1 (
  echo ❌ Echec du dump.
) else (
  echo ✅ Sauvegarde OK.
)
pause
goto MENU

:ASK_RENDER_PARAMS
echo.
echo === Parametres Render (ENTER = valeur par defaut) ===
set /p RENDER_HOST_IN="Host [%RENDER_HOST%]: "
if not "%RENDER_HOST_IN%"=="" set "RENDER_HOST=%RENDER_HOST_IN%"

set /p RENDER_PORT_IN="Port [%RENDER_PORT%]: "
if not "%RENDER_PORT_IN%"=="" set "RENDER_PORT=%RENDER_PORT_IN%"

set /p RENDER_DB_IN="DB name [%RENDER_DB%]: "
if not "%RENDER_DB_IN%"=="" set "RENDER_DB=%RENDER_DB_IN%"

set /p RENDER_USER_IN="User [%RENDER_USER%]: "
if not "%RENDER_USER_IN%"=="" set "RENDER_USER=%RENDER_USER_IN%"

set /p RENDER_PWD="Mot de passe Render pour %RENDER_USER%: "
if "%RENDER_PWD%"=="" (echo ❌ Mot de passe requis.& pause & goto MENU)
exit /b 0

:RESTORE_RENDER
call :ASK_RENDER_PARAMS
set /p BACKUPFILE="Chemin du fichier .sql à restaurer [ex: D:\backup_linsup.sql]: "
if "%BACKUPFILE%"=="" (echo ❌ Chemin vide.& pause & goto MENU)
if not exist "%BACKUPFILE%" (echo ❌ Le fichier n'existe pas.& pause & goto MENU)

echo ♻️ Restauration vers Render %RENDER_DB%@%RENDER_HOST% ...
set "PGPASSWORD=%RENDER_PWD%"
"%PGBIN%\psql.exe" "host=%RENDER_HOST% port=%RENDER_PORT% dbname=%RENDER_DB% user=%RENDER_USER% sslmode=require" -v ON_ERROR_STOP=1 -f "%BACKUPFILE%"
if errorlevel 1 (
  echo ❌ Echec de la restauration.
) else (
  echo ✅ Restauration OK.
)
pause
goto MENU

:MIGRATE_PIPE
REM Paramètres locaux
set /p LOCAL_DB="Nom de la base locale à envoyer (ex: linsup): "
if "%LOCAL_DB%"=="" (echo ❌ Nom vide.& pause & goto MENU)
set /p LOCAL_USER="Utilisateur local postgres (ENTER pour 'postgres'): "
if "%LOCAL_USER%"=="" set "LOCAL_USER=postgres"
set /p PGPASSWORD_LOCAL="Mot de passe local %LOCAL_USER% (ENTER pour defaut: %PGPASSWORD_LOCAL%): "
if "%PGPASSWORD_LOCAL%"=="" set "PGPASSWORD_LOCAL=Nexus2023."

REM Paramètres Render
call :ASK_RENDER_PARAMS

echo 🔁 Migration directe locale -> Render (avec --clean --if-exists)...
REM Important: sslmode dans la chaine de connexion. Variables définies hors du bloc.
set "PGPASSWORD=%PGPASSWORD_LOCAL%"
"%PGBIN%\pg_dump.exe" --clean --if-exists -h localhost -U %LOCAL_USER% -d %LOCAL_DB% | (
  set "PGPASSWORD=%RENDER_PWD%"
  "%PGBIN%\psql.exe" "host=%RENDER_HOST% port=%RENDER_PORT% dbname=%RENDER_DB% user=%RENDER_USER% sslmode=require"
)
if errorlevel 1 (
  echo ❌ Echec de la migration (pipe).
) else (
  echo ✅ Migration réussie.
)
pause
goto MENU

:TEST_RENDER
call :ASK_RENDER_PARAMS
echo 🔎 Test connexion Render...
set "PGPASSWORD=%RENDER_PWD%"
"%PGBIN%\psql.exe" "host=%RENDER_HOST% port=%RENDER_PORT% dbname=%RENDER_DB% user=%RENDER_USER% sslmode=require" -c "SELECT current_database(), current_user, version();"
if errorlevel 1 (
  echo ❌ Connexion echouee.
) else (
  echo ✅ Connexion OK.
)
pause
goto MENU

:END
echo.
echo ✅ Terminé.
ENDLOCAL
exit /b
