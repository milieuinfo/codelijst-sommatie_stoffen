#!/bin/bash

cat ../codelijst-source.csv | cut -d ',' -f 4 | sort -u | grep '.*-.*-.' > /tmp/cas

pushd ../pubchem
#echo 'casnumber,inchikey' > /tmp/cas_resolved.csv
while read cas ; do
  output=`curl -s -o /dev/null -L -w "%{http_code}" "http://dd.eionet.europa.eu/vocabulary/wise/ObservedProperty/CAS_${cas}"`
  if [ $output -eq 200 ] ; then
    curl -LO "http://dd.eionet.europa.eu/vocabulary/wise/ObservedProperty/CAS_${cas}"
  fi
  #curl "https://pubchem.ncbi.nlm.nih.gov/compound/$cas"
  #url=`curl "https://pubchem.ncbi.nlm.nih.gov/compound/$cas"   -H 'accept: text/html' | grep alternate | tr '"' '\n' |grep http | sort -u ` ;
  #iko=`curl -L $url.nt  | grep -i inchikey | cut -d '>' -f 1 | sed -e 's/<//'`
  #inchikey=`curl -L  $iko.nt | grep SIO_000300 | cut -d '"' -f 2`
  #echo ${cas},${inchikey} >> /tmp/cas_to_inchikey.csv
  #echo ${url}
done < /tmp/cas