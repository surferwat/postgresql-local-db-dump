#!bin/bash
# Creates a local data dump using a postgresql production database 

PRODUCTION_DB_URL=$1 #postgres://{user}:{password}@{server}:{port}/{db_name}
DUMP_TO_PATH=$2
ARGS=2
CURRENT_DATE=`date +"%Y-%m-%d"`

if [ $# -ne $ARGS ] 
then
  echo "invalid number of args"
  echo "...exiting"
  exit 1
fi

# Dump data for production db in script format
echo "...creating data dump of production db"
sudo -u postgres pg_dump -O -x --cluster 13/main $PRODUCTION_DB_URL > ${DUMP_TO_PATH}/production_dump.sql

# Create local db
echo "...creating local db"
sudo -u postgres createdb ${CURRENT_DATE}-localdb

# Restore to local db
echo "...restoring data dump to local db"
sudo -u postgres psql ${CURRENT_DATE}-localdb < ${DUMP_TO_PATH}/production_dump.sql > /dev/null

# Dump data for local db in script format
echo "...creating data dump of local db"
sudo -u postgres pg_dump -O -x ${CURRENT_DATE}-localdb > ${DUMP_TO_PATH}/local_dump.sql

echo "done"
