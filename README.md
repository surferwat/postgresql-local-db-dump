# postgresql-production-db-dump
## Description
A bash script that creates a local data dump in script file format from a postgresql production database for the purpose of helping developers setup a local database. The script takes two arguments. The first argument is the postgresql database url. The second argument is the output file path.
## Installation
Step 1: Clone the repo
```
git clone https://github.com/surferwat/postgresql-local-db-dump.git
```
## Usage
```
bash index.sh <postgresql production database url> <path/to/output/file>
```
## To Do
* [ ] add pre-condition check for production db connection
## References
* [Backup and Restore](https://www.postgresql.org/docs/8.1/backup.html)
* [pg_dump](https://www.postgresql.org/docs/9.3/app-pgdump.html)
* [psql](https://www.postgresql.org/docs/13/app-psql.html)
* [How do I solve a "server version mismatch" with pg_dump](https://askubuntu.com/questions/646603/how-do-i-solve-a-server-version-mismatch-with-pg-dump-when-i-need-both-postgre)
