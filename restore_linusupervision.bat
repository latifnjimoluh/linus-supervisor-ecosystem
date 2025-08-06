@echo off
SET PGPASSWORD=Nexus2023.
set "PGBIN=C:\Program Files\PostgreSQL\17\bin"

echo ===============================
echo 🐘 Gestion PostgreSQL
echo ===============================
echo [1] Supprimer une base
echo [2] Créer une base
echo [3] Sauvegarder une base
echo [4] Restaurer une base
echo.
set /p opt="Choisissez une option (1-4): "

if "%opt%"=="1" goto DROP
if "%opt%"=="2" goto CREATE
if "%opt%"=="3" goto BACKUP
if "%opt%"=="4" goto RESTORE

echo Option invalide.
goto END

:DROP
set /p DBNAME="Nom de la base à supprimer: "
echo 🛑 Fermeture des connexions actives...
"%PGBIN%\psql.exe" -U postgres -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DBNAME%';"
echo 🧹 Suppression de la base %DBNAME%...
"%PGBIN%\dropdb.exe" -U postgres %DBNAME%
goto END

:CREATE
set /p DBNAME="Nom de la base à créer: "
echo 🆕 Création de la base %DBNAME%...
"%PGBIN%\createdb.exe" -U postgres %DBNAME%
goto END

:BACKUP
set /p DBNAME="Nom de la base à sauvegarder: "
set /p BACKUPFILE="Chemin du fichier de backup (.sql): "
echo 💾 Sauvegarde de %DBNAME% vers %BACKUPFILE%...
"%PGBIN%\pg_dump.exe" -U postgres %DBNAME% > "%BACKUPFILE%"
goto END

:RESTORE
set /p DBNAME="Nom de la base à restaurer: "
set /p BACKUPFILE="Chemin du fichier de backup (.sql): "
echo 🛑 Fermeture des connexions actives...
"%PGBIN%\psql.exe" -U postgres -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DBNAME%';"
echo 🧹 Suppression de l'ancienne base...
"%PGBIN%\dropdb.exe" -U postgres %DBNAME%
echo 🆕 Création de la nouvelle base...
"%PGBIN%\createdb.exe" -U postgres %DBNAME%
echo ♻️ Restauration de %BACKUPFILE%...
"%PGBIN%\psql.exe" -U postgres -d %DBNAME% -f "%BACKUPFILE%"
goto END

:END
echo ✅ Opération terminée.
pause
