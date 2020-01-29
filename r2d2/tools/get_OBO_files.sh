#!/bin/bash

JSON_FILE='ontologies.jsonld'
PURL_FILE='purls.json'
CLEANED_PURLS='cleaned_purls.txt'
OWL_DIR='OWL_FILES'
REPORT_DIR='REPORTS'
LOG='log.txt'
MASTER_LIST='MASTER_LIST.csv'

######## RETRIEVE OBO FOUNDRY OWL FILES

# get OBO Foundry Registry JSON file
wget -N http://www.obofoundry.org/registry/ontologies.jsonld >> ${LOG}

# get all purls from OBO registry, save to new file
jq '.ontologies[] | {name: .id,purl:  .ontology_purl}' ${JSON_FILE} > ${PURL_FILE}

# remove quotes, save to cleaned file to retian 'null' purls for analysis
jq '.purl' ${PURL_FILE} | tr -d '"' > ${CLEANED_PURLS}

# remove null lines
sed -i '' '/null/d' ${CLEANED_PURLS}

# print counts to provide edvidence of partial availability
echo 'total ontologies returned:' >> ${LOG}
jq '.purl' ${PURL_FILE} | wc -l >> ${LOG}
echo 'total non-null purls returned:' >> ${LOG}
cat ${CLEANED_PURLS} | wc -l >> ${LOG}

# get ontology files if not already present or changed
cat ${CLEANED_PURLS} | xargs wget -N -P ${OWL_DIR}/ >> ${LOG}

######## TEST AVAILABLE ONTOLOGIES USING ROBOT

# test each file in OWL_DIR using robot report
# save output in new dir
for OWL_FILE in ${OWL_DIR}/*.owl
  do
    BASE="${OWL_FILE##*/}"
    OUTPUT="${BASE%.*}_output.csv"

    # format output into log file for troubleshooting
    echo "Results for ${BASE}" >> ${LOG}
    robot report --input "${OWL_FILE}" --output "${REPORT_DIR}"/"${OUTPUT}" >> ${LOG}
    echo "" >> ${LOG}

    # convert all .tsv to .csv
    # this was annoying
    tr '\t' ',' < "${REPORT_DIR}"/"${OUTPUT}" > temp.csv
    mv temp.csv "${REPORT_DIR}"/"${OUTPUT}"

    # NEED TO FIX SED HEADER REPLACEMENT
    sed -i '' 's/^/'${BASE}',/' "${REPORT_DIR}"/"${OUTPUT}"
    HEADER="Source,Level,Rule Name,Subject,Property,Value,,"
    sed -i '' "1s/.*/${HEADER}/" "${REPORT_DIR}"/"${OUTPUT}"
  done

# combine all csv reports into one file
cat "${REPORT_DIR}"/*.csv >> ${MASTER_LIST}
echo 'Process completed.'
