#!bin/bash

PRODUCTION_DB_URL=$1 #postgres://{user}:{password}@{server}:{port}/{db_name}
DUMP_TO_PATH=$2
ARGS=2
CURRENT_DATE=`date +"%Y-%m-%d"`

# Function to check pre- and post-conditions
check_condition() {
 if [ $1 ] 
 then 
  echo $2
  echo "...exiting"
  exit 1
 fi
}

# Check pre-conditions
check_condition "$# -ne $ARGS" "invalid number of args" 
check_condition "! -d $DUMP_TO_PATH" "$DUMP_TO_PATH does not exist" 

# Dump data for production db in script format
echo "...creating data dump of production db"
sudo -u postgres pg_dump -O -x --cluster 13/main $PRODUCTION_DB_URL > ${DUMP_TO_PATH}/production_dump.sql
check_condition "$? -ne 0" "could not create data dump of production db" 

# Create local db
echo "...creating local db"
sudo -u postgres createdb ${CURRENT_DATE}-localdb
check_condition "$? -ne 0" "could not create local db"

# Restore to local db
echo "...restoring data dump to local db"
sudo -u postgres psql ${CURRENT_DATE}-localdb < ${DUMP_TO_PATH}/production_dump.sql > /dev/null
check_condition "$? -ne 0" "could not restore data dump to local db"

# Dump data for local db in script format
echo "...creating data dump of local db"
sudo -u postgres pg_dump -O -x ${CURRENT_DATE}-localdb > ${DUMP_TO_PATH}/local_dump.sql
check_condition "$? -ne 0" "could not create data dump of local db"

echo "done"
exit 0
