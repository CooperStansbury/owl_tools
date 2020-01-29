# Mass Update Tools
This is a set of command line tools designed to extract terms and definitions from an `.owl` file into a `.csv` using Python 3. The `.csv` file can be imported into a common application such as MS Excel in order to make changes to the content. Once changes have been made the OWL file can be updated for all terms that were changed. This is helpful for teams that want to make significant content changes to terms and definitions at once. The primary reason for including these is that they were used to revise content in `ico.owl` during the summer of 2018.

### `extract_classes.py`
This tool takes one `.owl` file command line argument. It produces a `.csv` file with terms and definitions in the following format:

```
PURL,Term Label,Definition
```

### `insert_new_definitions.py`
This tool takes one `.owl` file and one `.csv` command line argument. It is expected that the `.csv` file is in **exactly** the same format as the output from `extract_classes.py`. It compares the 'PURLS' in the `.csv` to the existing content in the `.owl` file and creates an updated `.owl` file and and revisions file to compare and document the changes.

### `find_and_replace.py`
A tool to update purls dynamically in an owl file (create new copy) given a text file input of purls.
