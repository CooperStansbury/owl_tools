#!/bin/bash

STAT_DIR='STAT_DIR'
FILE='MASTER_LIST.csv'

# manage files separately
BASE="${FILE##*/}"
OUTPUT="${BASE%.*}_temp.csv"

# trim unused columns
< ${FILE} csvcut -c "Source","Level","Rule Name" > ${STAT_DIR}/${OUTPUT}

# rename columns because the space is a nightmare
sed -i '' '1s/.*/Source,Level,Rule/' ${STAT_DIR}/${OUTPUT}

# output descriptive stats by field
echo "### Descriptive statistics by field"
csvstat -v ${STAT_DIR}/${OUTPUT}
echo ""

# output number of unique values
echo "### Unique Values per field"
csvstat ${STAT_DIR}/${OUTPUT} --unique
echo ""

# query errors by ontology (raw counts)
ERROR_COUNT='ERROR_COUNT.csv'
echo "Error counts by Ontology..."
< ${STAT_DIR}/${OUTPUT} csvsql --query \
    "SELECT Source, count(level) as 'Total Error-Level Warnings'
    FROM stdin
    WHERE Level = 'ERROR'
    GROUP BY Source
    ORDER BY count(level) desc" > ${STAT_DIR}/${ERROR_COUNT}
echo "...saved to ${STAT_DIR}/${ERROR_COUNT}"
echo ""

# query info by ontology (raw counts)
WARN_COUNT='WARN_COUNT.csv'
echo "Warn counts by Ontology..."
< ${STAT_DIR}/${OUTPUT} csvsql --query \
    "SELECT Source, count(level) as 'Total Warn-Level Warnings'
    FROM stdin
    WHERE Level = 'WARN'
    GROUP BY Source
    ORDER BY count(level) desc" > ${STAT_DIR}/${WARN_COUNT}
echo "...saved to ${STAT_DIR}/${WARN_COUNT}"
echo ""

# query info by ontology (raw counts)
INFO_COUNT='INFO_COUNT.csv'
echo "Info counts by Ontology..."
< ${STAT_DIR}/${OUTPUT} csvsql --query \
    "SELECT Source, count(level) as 'Total Info-Level Warnings'
    FROM stdin
    WHERE Level = 'INFO'
    GROUP BY Source
    ORDER BY count(level) desc" > ${STAT_DIR}/${INFO_COUNT}
echo "...saved to ${STAT_DIR}/${INFO_COUNT}"
echo ""

# join all three of the count files into one file for further analysis
LEVEL_COUNT='LEVEL_COUNT.csv'
echo "Joining error level counts..."
csvjoin -c Source ${STAT_DIR}/${INFO_COUNT} ${STAT_DIR}/${ERROR_COUNT} ${STAT_DIR}/${WARN_COUNT} \
    > ${STAT_DIR}/${LEVEL_COUNT}
echo "...saved to ${STAT_DIR}/${LEVEL_COUNT}"
echo ""

# print to stdout
csvlook ${STAT_DIR}/${LEVEL_COUNT}
