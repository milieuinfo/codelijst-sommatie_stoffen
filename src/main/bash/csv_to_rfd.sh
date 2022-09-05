#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/somparameter/somparameter.csv
# to jsonld, /tmp/somparameter.jsonld
Rscript ../R/csv_to_json.R

# Make formatted jsonld and turtle
riot --formatted=TURTLE /tmp/somparameter.jsonld   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/somparameter/somparameter.ttl'
riot --formatted=JSONLD '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/somparameter/somparameter.ttl'   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/somparameter/somparameter.jsonld' 

