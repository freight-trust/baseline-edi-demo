#!/bin/bash

FRESNOHOST=${1:-ec2-52-53-248-65.us-west-1.compute.amazonaws.com}

curl -s \
 --data-binary @samples/test211_freight_not_palletized.edi \
 -H 'Expect:' \
 -H 'Content-Type:application/EDI-X12' \
 -H 'Accept:application/xml' \
 ${FRESNOHOST}:8080/transactions/translator \
 | xsltproc src/xslt/x211_to_saia_bill_of_lading.xslt -
