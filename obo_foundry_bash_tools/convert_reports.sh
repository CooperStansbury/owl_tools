#!/bin/sh

# directory variables
REPORT_DIR='REPORTS/'
CSV_DIR='CSV_REPORTS/'

# test each file in OWL_FILES
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
