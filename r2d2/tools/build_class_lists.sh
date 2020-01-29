OWL_DIR='OWL_FILES'
OUTPUT_DIR='CLASS_LISTS'
SPARQL='SPARQL_DIR/class_list.sparql'

# loop through each file and extract content
for OWL_FILE in ${OWL_DIR}/*.owl
  do
    BASE="${OWL_FILE##*/}"
    OUTPUT="${BASE%.*}_class_list.csv"

    # save results
    robot query --input "${OWL_FILE}" --query "${SPARQL}" ${OUTPUT_DIR}/${OUTPUT}

    echo 'Done with '${OUTPUT}''
  done
