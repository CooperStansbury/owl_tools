#!/usr/bin/env bash


OWL_DIR='OWL_FILES'
MERGE_DIR='ALL_MERGED'

# merge each file in OWL_DIR using robot merge
for OWL_FILE in ${OWL_DIR}/*.owl
# for OWL_FILE in ${OWL_DIR}/iao.owl
  do
    BASE="${OWL_FILE##*/}"
    OUTPUT="${BASE%.*}_merged.owl"
    robot merge --input "${OWL_FILE}" --output "${MERGE_DIR}"/"${OUTPUT}"
  done
