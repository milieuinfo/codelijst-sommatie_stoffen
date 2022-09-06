#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.csv
# to jsonld, /tmp/sommatie_stoffen.jsonld
Rscript ../R/csv_to_json.R

# Make formatted jsonld and turtle
riot --formatted=TURTLE /tmp/sommatie_stoffen.jsonld   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.ttl'
riot --formatted=JSONLD '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.ttl'   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.jsonld' 

