#!/usr/bin/env python

import pandas as pd
import argparse

def compare(node, edge):

    print('Loading files:')
    node_frame = pd.read_csv(node)
    edge_frame = pd.read_csv(edge)
    print('Load successful.')

    print('\nnode.id missing from edge.to:')
    node_id = set(node_frame.id)
    diff_list1 = [x for x in edge_frame.to if x not in node_id]
    [print(x) for x in diff_list1]

    print('\nnode.id missing from edge.id:')
    node_id = set(node_frame.id)
    diff_list2 = [x for x in edge_frame.id if x not in node_id]
    [print(x) for x in diff_list2]

    # print('\nedge.to missing in node.id:')
    # egde_to = set(edge_frame.to)
    # diff_list3 = [x for x in node_frame.id if x not in egde_to]
    # [print(x) for x in diff_list3]
    # 
    # print('\nedge.id missing in node.id:')
    # edge_id = set(edge_frame.id)
    # diff_list4 = [x for x in node_frame.id if x not in edge_id]
    # [print(x) for x in diff_list4]

    print('\nDone!')

if __name__ == "__main__":

    # parse command-line args
    parser = argparse.ArgumentParser(description='Extract terms from local .OWL file')
    parser.add_argument("node", help="File to query")
    parser.add_argument("edge", help="File to query")
    args = parser.parse_args()

    # run puppy, run
    compare(args.node,args.edge)
