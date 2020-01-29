#!/bin/sh

# directory variables
CSV_DIR='CSV_REPORTS/'

# test each file in OWL_FILES
for REPORT in ${CSV_DIR}*.csv
  do
    BASE="${REPORT##*/}"
    OUTPUT="${BASE%.*}.csv"
    sed 's/^/'${OUTPUT}',/' ${REPORT} > temp/${OUTPUT}
  done

cat temp/*.csv >> MASTER_LIST.csv
rm temp/*.csv
