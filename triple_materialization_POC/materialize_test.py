#!/usr/bin/env python3

import owlready2 as ow
import csv


## ---------------------- functions ------------------------------------ ##

def getInstanceDict(instances_file):
    """ return a dict of instance data from csv """
    instance_dict = {}
    with open(instances_file, 'r') as infile:
        reader = csv.reader(infile)
        instanceID = 0 # auto keep track of each instance
        for row in reader:
            instanceID += 1
            instance_dict[instanceID] = {
                'subject_class' : row[0],
                'subject' : row[1],
                'action_class' : row[2],
                'action' : row[3],
                'purpose_class' : row[4],
                'purpose' : row[5]
            }
    return instance_dict


def getOntology(ontology_file):
    """ return ontology class from a local OWL file """
    return ow.get_ontology("file://" + ontology_file).load()


def getClass(ontology, string):
    """ return ontology class from string """
    string = str(ontology.base_iri) + string
    return ontology.search_one(iri=string)


def populateIndividuals(ontology, instance_dict):
    """ create new instances based on imported file contents """
    for k,v in instance_dict.items():
        # clean subject to use for individal name
        cleanedSubject = v['subject'].title().strip().replace(" ", "")

        # instantiate a new class based on value from csv file
        subject_class =  getClass(ontology, v['subject_class'])(cleanedSubject)

        # rinse and repeat for 'purposes'
        cleanedPurpose = v['purpose'].title().strip().replace(" ", "")
        purpose_class =  getClass(ontology, v['purpose_class'])(cleanedPurpose)

    return ontology

## ---------------------- fake main ------------------------------------ ##

instances_file = 'poc_instances.csv'
ontology_file = 'poc.owl'

ontology = getOntology(ontology_file)
instance_dict = getInstanceDict(instances_file)
new_ontology = populateIndividuals(ontology, instance_dict)

# print individals to command line
for ind in new_ontology.individuals():
    print(ind)

# save new ontology to file
new_ontology.save(file = "test_poc.owl", format = "rdfxml")
