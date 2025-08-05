@echo off
SET PGPASSWORD=Nexus2023.

REM 📌 Terminer toutes les connexions existantes
echo 🛑 Fermeture des connexions actives...
"c:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'linusupervision';"

REM 🗑️ Supprimer la base si elle existe
echo 🧹 Suppression de l'ancienne base...
"c:\Program Files\PostgreSQL\17\bin\dropdb.exe" -U postgres linusupervision

REM ➕ Créer une base vide
echo 🆕 Création de la nouvelle base...
"c:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres linusupervision

REM ♻️ Restauration du backup
echo ♻️ Restauration du backup en cours...
"c:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d linusupervision -f "D:\Keyce_B3\Soutenance\linusupervisor-backend\linusupervisor-backend\sql\linusupervision_backup.sql"

echo ✅ Restauration terminée !
pause
