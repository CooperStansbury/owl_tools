FILE='STAT_DIR/MASTER_LIST_temp.csv'
OUTPUT='STAT_DIR/Errors_by_Type.csv'

# rename columns because the space is a nightmare
sed -i '' '1s/.*/Source,Level,Rule/' ${FILE}

# head -n 10 ${FILE}

< ${FILE} csvsql --query \
    "SELECT Rule, count(Level) as 'Count'
    FROM stdin
    GROUP BY Rule
    ORDER BY count(Level) desc" > ${OUTPUT}
