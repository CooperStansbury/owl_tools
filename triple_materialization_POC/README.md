# Ontology Individual Creation using Python
This repository is a toy demonstration to show how one can create individuals in an `OWL` ontology using Python 3.6 or later. This example shows how one can use a structured `.csv` containing 'individuals' can be added to an ontology using [owlready2](https://pythonhosted.org/Owlready2/index.html). Two important notes: (1) there is no claim of ontology best practices, this is a 'technical' example. (2) `owl:ObjectProperty` is not instantiated here (I ran out of time).

## Contents
1. [catalog-v001.xml](catalog-v001.xml): an intermediate file created by the ontology editor [Protégé](https://protege.stanford.edu/).
1. [materialize_test.py](materialize_test.py): a Python script that reads both `poc.owl` and `poc_instances.csv` to generate new ontology individuals. The script produces `test_poc.owl` as an output.
1. [poc_instances.csv](poc_instances.csv): a comma-separated text file containing strings and fields indicating which class that string value belongs to. Note, no headers in the actual file. Format:

| subject class                |   subject     |  action class |  action     | purpose class    |  purpose        |
|------------------------------|---------------|---------------|-------------|------------------|-----------------|
| personally_identifiable_data | personal data | collected_for | obtained for | broad_use        | future research |
| data                         | linked data   | collected_for | taken for   | specific_use     | this study      |
| hair                         | hair          | collected_for | stored for  | broad_use        | decades to come |
| biospecimens                 | blood serum   | collected_for | shared for  | specific_use     | this study only |
| data                         | genetic data  | collected_for | stored for  | genetic_research | genetic studies |

1. [poc.owl](poc.owl): a tiny ontology with no upper-level structure.
1. [sparql_test.sq](sparql_test.sq): a `sparql` query to show inferred inheritance results in `test_poc.owl`.
1. [test_poc.owl](test_poc.owl): the output of `materialize_test.py`, an ontology file with created individuals.

## Running the Example:
1. [owlready2](https://pythonhosted.org/Owlready2/index.html) must be installed.
1. Highly recommended that you view the ontology files in [Protégé](https://protege.stanford.edu/).
1. From the `triple_materialization_POC` directory, run `./materialize_test.py`.
1. Open the .`owl` files in [Protégé](https://protege.stanford.edu/) to see results.
1. Copy + Paste the query in `sparql_test.sq` to the query window in [Protégé](https://protege.stanford.edu/).
