#!/bin/sh

# Requires xmllint to be installed, dependency tests
command -v wget 1> /dev/null 2>&1 || \
  { echo >&2 "wget required but it's not installed.  Aborting."; exit 1; }

command -v sed 1> /dev/null 2>&1 || \
  { echo >&2 "sed required but it's not installed.  Aborting."; exit 1; }

command -v jq 1> /dev/null 2>&1 || \
  { echo >&2 "jq required but it's not installed.  Aborting."; exit 1; }

command -v robot 1> /dev/null 2>&1 || \
  { echo >&2 "robot required but it's not installed.  Aborting."; exit 1; }

######## GATHER ALL FILES FROM OBO FOUNDRY

# get OBO Foundry Registry JSON file
wget http://www.obofoundry.org/registry/ontologies.jsonld

# declare variables
JSON_FILE='ontologies.jsonld'
PURL_FILE='PURLS.txt'
OWL_DIR='OWL_FILES/'
REPORT_DIR='REPORTS/'
CSV_DIR='CSV_REPORTS/'

# # clear current OWL_DIR
# rm ${OWL_FILES}/*.owl

# get all PURLS from JSON registry, save to new file
jq '.ontologies[].ontology_purl' ${JSON_FILE} > ${PURL_FILE}

# remove null lines and quotes
##### SHOULD COUNT NULLS, or move to a separate file
##### SHOULD record ontology name to know which are null pointers
sed -i '' '/null/d' ${PURL_FILE}
sed 's/"//g' ${PURL_FILE} > temp && mv temp ${PURL_FILE}

# get and save all OWL files from PURLS to local machine
wget -i ${PURL_FILE} -P ${OWL_DIR}

# # clear current reports
# rm ${REPORT_DIR}/*.tsv

# test each file in OWL_DIR using robot report
# save output in new dir
for OWL_FILE in ${OWL_DIR}*.owl
  do
    BASE="${OWL_FILE##*/}"
    echo "Results for ${BASE}"
    OUTPUT="${BASE%.*}_output.tsv"
    robot report --input "${OWL_FILE}" --output "${REPORT_DIR}"/"${OUTPUT}"
    echo ""
  done

# convert all tsv to csv
# not sure if this is necessary
for REPORT in ${REPORT_DIR}*.tsv
  do
    BASE="${REPORT##*/}"
    OUTPUT="${BASE%.*}.csv"
    echo "Converting ${BASE} to CSV"

    awk 'BEGIN { FS="\t"; OFS="," } {
      rebuilt=0
      for(i=1; i<=NF; ++i) {
        if ($i ~ /,/ && $i !~ /^".*"$/) { $i = "\"" $i "\""; rebuilt=1 }
      }
      if (!rebuilt) { $1=$1 }
      print
    }' ${REPORT} > "${CSV_DIR}"/"${OUTPUT}"

    echo ""
  done

# add filename (ontology) to new column in each report
# set up for descriptive statistics
for REPORT in ${CSV_DIR}*.csv
  do
    BASE="${REPORT##*/}"
    OUTPUT="${BASE%.*}.csv"
    sed 's/^/'${OUTPUT}',/' ${REPORT} > temp/${OUTPUT}
  done

# combine all csv reports into one file
cat temp/*.csv >> MASTER_LIST.csv

# clean up temp dir
rm temp/*.csv
