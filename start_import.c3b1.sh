#!/bin/bash

# Start import of given UUIDs.  This is run on host computer

# This is a wrapper around importGDC/start_step.sh with CPTAC3.b1-specific setup added for convenience
# All arguments passed to here will be passed to start_step.sh

# Using LSF_Group /mwyczalk/gdc-download (TODO: allow this to be defined in environment variable)

# Usage: start_import.c3b1.sh [options] UUID [UUID2 ...]
# Start import on host computer.  
# options:
# -d: dry run
#
# If UUID is - then read UUID from STDIN

source gdc-import.config
# Data download location
# NOTE: this has to be compatible with SomaticWrapper analysis, and should use DATAD_H from there
DATA_DIR="/gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-download/"
mkdir -p $DATA_DIR

if [ ! -e $GDCTOKEN ]; then
    >&2 echo Error: Token file $GDCTOKEN not found
    exit
fi

# This is MGI-specific
if [ ! -z $LSF_GROUP ]; then
    LSF_GROUP_ARG="-g $LSF_GROUP"
fi

# Copy token defined in host dir to container's /data directory
# Note there may be some security considerations associated with this
TOKEN_HOST="token/gdc-user-token.2017-12-15T20_42_09.411Z.txt"
TOKEN_CONTAINER="/data/token/gdc-user-token.txt"
mkdir -p $DATA_DIR/token
>&2 echo Copying $GDCTOKEN to $DATA_DIR/token/gdc-user-token.txt
cp $GDCTOKEN $DATA_DIR/token/gdc-user-token.txt


bash $IMPORTGDC_HOME/batch.import/start_step.sh -M -O $DATA_DIR -S $SR $LSF_GROUP_ARG -s import "$@"
