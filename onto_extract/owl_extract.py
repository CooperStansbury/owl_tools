#!/usr/bin/env python3

from __future__ import print_function # for 2.7 users
import rdflib
import pandas as pd
import argparse
import os
from io import StringIO


def runExtract(owl_file, query):
    """ extract results from owl file and print """

    # fast way to add to dataframe
    new_rows = []

    with open(query) as q_input:
        q_data=q_input.read()

        g = rdflib.Graph()
        g = g.parse(owl_file)


        qresults = g.query(q_data)

        # iterate through query result and place in dataframe
        for row in qresults:
            new_rows.append(row.asdict())

    ## TODO: additional options around df?

    df = pd.DataFrame(new_rows)
    output = StringIO()

    df.to_csv(output, index=False)

    # render to stdout
    print(output.getvalue())


if __name__ == "__main__":

    # parse command-line args
    parser = argparse.ArgumentParser(description='Extract terms from local .OWL owl_file')
    parser.add_argument("--owl_file", help="owl file to query")
    parser.add_argument("--query", help="sparql query to use")
    args = parser.parse_args()

    ## handle files from args
    try:
        source_owl_file = os.path.abspath(args.owl_file)
        query_owl_file = os.path.abspath(args.query)
    except FileNotFoundError as e:
        print("Error in input arguments file paths: ", e)


    runExtract(source_owl_file, query_owl_file)
