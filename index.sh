#!bin/bash

PRODUCTION_DB_URL=$1 #postgres://{user}:{password}@{server}:{port}/{db_name}
DUMP_TO_PATH=$2
ARGS=2
CURRENT_DATE=`date +"%Y-%m-%d"`

# Check pre-conditions
if [ $# -ne $ARGS ] 
then
  echo "invalid number of args"
  echo "...exiting"
  exit 1
fi

# Dump data for production db in script format
echo "...creating data dump of production db"
sudo -u postgres pg_dump -O -x --cluster 13/main $PRODUCTION_DB_URL > ${DUMP_TO_PATH}/production_dump.sql

if [ $? -ne 0 ]
then 
 echo "could not create data dump of production db"
 echo "...exiting"
 exit 1
fi

# Create local db
echo "...creating local db"
sudo -u postgres createdb ${CURRENT_DATE}-localdb

if [ $? -ne 0 ]
then
 echo "could not create local db"
 echo "...exiting"
 exit 1
fi

# Restore to local db
echo "...restoring data dump to local db"
sudo -u postgres psql ${CURRENT_DATE}-localdb < ${DUMP_TO_PATH}/production_dump.sql > /dev/null

if [ $? -ne 0 ]
then 
 echo "could not restore data dump to local db"
 echo "...exiting"
 exit 1
fi

# Dump data for local db in script format
echo "...creating data dump of local db"
sudo -u postgres pg_dump -O -x ${CURRENT_DATE}-localdb > ${DUMP_TO_PATH}/local_dump.sql

if [ $? -ne 0 ]
then 
 echo "could not create data dump of local db"
 echo "...exiting"
 exit 1
fi

echo "done"
