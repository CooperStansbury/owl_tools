#!/usr/bin/env python

from __future__ import print_function # for 2.7 users
import pandas as pd
import argparse
import os
import owlready2 as ow
import subprocess

# function to traverse up the is_a tree
def get_tree(node, path):

    # add each node to the path
    if node not in path:
        path.append(node)

    # stop once we reach the known top of the tree
    if node.name != 'BFO_0000001':
        for parent in node.is_a:
            if parent not in path:
                path.append(parent)

            # recursively call get_tree
            get_tree(parent, path)
            break
    return path

def owl_to_csv(input_file):

    # dataframe for edges
    edge_frame = pd.DataFrame()

    # dataframe for edges
    node_frame = pd.DataFrame()

    # file variables
    source_file = os.path.basename(input_file)
    base = os.path.splitext(source_file)[0]
    file_out = 'merged_' + str(base) + '.owl'

    # merge the ontology via robot
    print('Merging: ' + str(source_file))
    robotMerge = 'robot merge --input ' + source_file + ' --output ' + file_out
    process = subprocess.Popen(robotMerge.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()
    print('File merged successfully.')

    # make full path for owlready2 object
    full_path='file://' + file_out

    # get owlready2 ontology object from input file
    print('Loading ontology file: ' + str(file_out))
    onto = ow.get_ontology(full_path).load()
    print('File loaded successfully...')

    # increment dataframe
    count = 1

    # loop to make edges dataset
    print('Building datasets...')
    for cl in onto.classes():
        if not str(cl.label).__contains__('obsolete'):
            edge_frame.loc[count, 'id'] = str(cl)

            try:
                edge_frame.loc[count, 'to'] = str(cl.is_a[0])
            except:
                edge_frame.loc[count, 'to'] = 'NULL'
            edge_frame.loc[count, 'type'] = 'SubClassOf'

            ## right now using default weight 1
            ## will experiment with other weights
            edge_frame.loc[count, 'weight'] = 1

            # build node frame
            node_frame.loc[count, 'id'] = str(cl)

            # need to handle entities without labels
            try:
                node_frame.loc[count, 'label'] = str(cl.label[0])
            except:
                node_frame.loc[count, 'label'] = str(cl)

            node_frame.loc[count, 'parent.purl'] = str(cl.iri).rsplit('/', 1)[1].rsplit('_',1)[0].rsplit('#',1)[0]
            # distance from the top

            # need empty list to store path for each class
            class_path = []
            node_frame.loc[count, 'entity.weight'] = 1/len(get_tree(cl, class_path))

            try:
                node_frame.loc[count, 'entity.type'] = str(class_path[-2])
            except:
                node_frame.loc[count, 'entity.type'] = 'NULL'

            # increment dataframe
            count += 1
        else:
            print('DROPPING obsolete class: ' + str(cl))

    # drop all elements not in common
    for item in list(set(edge_frame.to) - set(node_frame.id)):
        print('DROPPING entity mismatch: ' + str(item))
        edge_frame = edge_frame[edge_frame.to != item]
        edge_frame = edge_frame[edge_frame.id != item]
        node_frame = node_frame[node_frame.id != item]

    # drop all elements not in common
    for item in list(set(node_frame.id) - set(edge_frame.id)):
        print('DROPPING entity mismatch: ' + str(item))
        edge_frame = edge_frame[edge_frame.to != item]
        edge_frame = edge_frame[edge_frame.id != item]
        node_frame = node_frame[node_frame.id != item]

    print('Number of edges: ' + str(len(edge_frame)))
    print('Number of nodes: ' + str(len(node_frame)))

    # print(edge_frame.head(10))
    # print(node_frame.head(10))

    # output each csv to file
    print('Creating csv files...')
    edge_frame.to_csv('edges_' + str(base) + ".csv", index=False)
    node_frame.to_csv('nodes_' + str(base) + ".csv", index=False)

    # clean up dir
    print('Removing intermediate file: ' + str(file_out))
    rmTemp = 'rm ' + str(file_out)
    process = subprocess.Popen(rmTemp.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()

    print('Done!')



if __name__ == "__main__":

    # parse command-line args
    parser = argparse.ArgumentParser(description='Extract terms from local .OWL file')
    parser.add_argument("input_file", help="File to query")
    args = parser.parse_args()

    # run puppy, run
    owl_to_csv(args.input_file)
