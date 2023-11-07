#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.csv
# to jsonld, /tmp/sommatie_stoffen.jsonld
Rscript ../R/csv_to_json.R

shacl v --shapes ../resources/be/vlaanderen/omgeving/data/id/ontology/sommatie-stoffen-ap-constraints/sommatie-stoffen-ap-constraints.ttl --data ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.ttl
