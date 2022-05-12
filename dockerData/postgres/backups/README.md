## How to use pg_restore

1. add dump.dump in this directory

2. rerun images (docker-compose down && docker-compose up)

3. run

`docker exec postgres_dev pg_restore --clean -d YOUR_DB /backups/YOUR_FILE`
