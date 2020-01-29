#!/usr/bin/env python3

import argparse
import os
import owlready2 as ow


def getClassLabel(iri):
    """ Return the rdfs:label for given URI """

    search_result = onto.search_one(iri=iri)

    if str(search_result).__contains__('BFO'):
        label = search_result.label[0]
        label = label.replace("-"," ")
        camel_case = ''.join(x for x in label.title() if not x.isspace())
        return camel_case
    else:
        return str(search_result).split(".")[1]


def getSubClassAxioms(iri):
    """ Prints subclass axioms to a file """
    search_result = onto.search_one(iri=iri)

    label = getClassLabel(search_result.iri)
    subclass_axioms = search_result.is_a[1:]

    if subclass_axioms:
        print(label, file=open("subclassAxioms.txt", "a"))
        [print(label, ": ", \
            str(x).replace("CommonCoreOntologies.", "").replace("ro.", ""), \
            '\n', file=open("subclassAxioms.txt", "a"))\
            for x in subclass_axioms]


def getEquivalenceAxioms(iri):
    """ Prints equivalentClass axioms to a file """
    search_result = onto.search_one(iri=iri)

    label = getClassLabel(search_result.iri)
    equivalence_axioms = search_result.equivalent_to

    if equivalence_axioms:
        print(label, file=open("equivalenceAxioms.txt", "a"))
        [print(label, ": ", \
            str(x).replace("CommonCoreOntologies.", "").replace("ro.", ""), \
            '\n', file=open("equivalenceAxioms.txt", "a"))\
            for x in equivalence_axioms]


def getFOL(onto):
    """ print CommonCore FOL Statements in Prover9 Syntax """

    unique_classes = []

    for onto_class in onto.classes():
        if onto_class in unique_classes:
            pass
        else:
            unique_classes.append(onto_class)

        # get parent and class label
        label = getClassLabel(onto_class.iri)
        parent = onto_class.is_a[0]

        # save list of all IRIs
        print(onto_class.iri, label, file=open("allIRIS.txt", "a"))

        # handle 'Entity'
        if str(parent) == 'owl.Thing':
            parent_label = 'Thing'
        else:
            parent_label = getClassLabel(parent.iri)

        # Human readable comments
        print("%%%%%% " + label + \
                " subClassOf " + parent_label, \
                file=open("prover9subclass.txt", 'a'))

        print("all x (" + label \
            + "(x) -> " + parent_label \
            + "(x)).\n", file=open("prover9subclass.txt", 'a'))

        # save all subclassAxioms to new file
        getSubClassAxioms(onto_class.iri)

        # save all equivalenceAxioms to new file
        getEquivalenceAxioms(onto_class.iri)


if __name__ == "__main__":

    # parse command-line args
    parser = argparse.ArgumentParser(description='Extract terms from local OWL file')
    parser.add_argument("--f", help="File to query")
    args = parser.parse_args()

    source_file = os.path.basename(args.f))
    base = os.path.splitext(source_file)[0]

    # load owlready graph object in order to print EquivalenceAxioms
    onto = ow.get_ontology("file://" + source_file).load()
    getFOL(onto)
