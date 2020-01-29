#!/usr/bin/env python3

import argparse
import os
import owlready2 as ow
import json
from pprint import pprint

PURLS = 'ontologies.jsonld'

onto = ow.get_ontology("http://test.org/onto.owl")

with open(PURLS) as f:
    data = json.load(f)

for ontology in data['ontologies']:
    purl = 'NO PURL'
    try:
        purl = ontology['ontology_purl'].strip()
        imported_onto =  ow.get_ontology(purl).load()
        print(purl, 'SUCCESS')
     except Exception as e:
        print(purl, 'ERROR:', e)
        pass

onto.save(file = 'master.owl', format = "rdfxml")
