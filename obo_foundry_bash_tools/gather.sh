#!/bin/sh

# Requires xmllint to be installed
command -v wget 1> /dev/null 2>&1 || \
  { echo >&2 "wget required but it's not installed.  Aborting."; exit 1; }

command -v sed 1> /dev/null 2>&1 || \
  { echo >&2 "sed required but it's not installed.  Aborting."; exit 1; }

command -v jq 1> /dev/null 2>&1 || \
  { echo >&2 "jq required but it's not installed.  Aborting."; exit 1; }

# get OBO Foundry Registry JSON file
wget http://www.obofoundry.org/registry/ontologies.jsonld

# name variables
JSON_FILE='ontologies.jsonld'
PURL_FILE='PURLS.txt'
OWL_FILES='/OWL_FILES'

# # clear current OWL files
# rm ${OWL_FILES}/*.owl

# get all PURLS from JSON registry
jq '.ontologies[].ontology_purl' ${JSON_FILE} > ${PURL_FILE}

# remove null lines and quotes
# SHOULD COUNT NULLS, or move to a separate
sed -i '' '/null/d' ${PURL_FILE}
sed 's/"//g' ${PURL_FILE} > temp && mv temp ${PURL_FILE}

# get and save all OWL files from PURLS
wget -i ${PURL_FILE} -P ${OWL_FILES}
