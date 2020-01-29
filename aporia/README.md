# aporia
A set of tools to automate owl ontology visualization from the command line.

## Usage
This repository assumes that the input ontology is a merged `.owl` file.

1. `get_data.py` requires 1 positional argument: `.owl` file. Produces two `.csv` files: (1) for each `subClassOf` edge relationship and (2) for each node, or `owl:Class`.
1. `viz.r` requires 2 positional arguments, both `.csv` files. The first is the node file and the second is the edges file.

## Attribution
* The [OBO Foundry](http://www.obofoundry.org/)
    * The OBO Foundry [Internet]. [cited 2018 Oct 11]. Available from: http://www.obofoundry.org/
* [robot](http://robot.obolibrary.org/), a useful tool for managing OBO Foundry ontology files.
    * ROBOT is an OBO Tool [Internet]. robot. [cited 2018 Oct 11]. Available from: http://robot.obolibrary.org/
* [Owlready2](https://pypi.org/project/Owlready2/), a python library for working with `.owl` files.
  * Owlready2 [Internet]. PyPI. [cited 2018 Oct 11]. Available from: https://pypi.org/project/Owlready2/
* [Network visualization with R](http://kateto.net/network-visualization)
  * Ognyanova K. Static and dynamic network visualization with R [Internet]. Katya Ognyanova. [cited 2018 Oct 11]. Available from: http://kateto.net/network-visualization

## Licensing
