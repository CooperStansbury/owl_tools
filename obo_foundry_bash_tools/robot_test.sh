#!/bin/sh

# Requires xmllint to be installed
command -v robot 1> /dev/null 2>&1 || \
  { echo >&2 "robot required but it's not installed.  Aborting."; exit 1; }

# directory variables
OWL_DIR='OWL_FILES/'
REPORT_DIR='REPORTS/'

# # clear current reports
# rm ${REPORT_DIR}/*.tsv

# test each file in OWL_FILES
for OWL_FILE in ${OWL_DIR}*.owl
  do
    BASE="${OWL_FILE##*/}"
    echo "Results for ${BASE}"
    OUTPUT="${BASE%.*}_output.tsv"
    robot report --input "${OWL_FILE}" --output "${REPORT_DIR}"/"${OUTPUT}"
    echo ""
  done
