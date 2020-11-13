#!/bin/bash

FRESNOHOST=${1:-ec2-52-53-248-65.us-west-1.compute.amazonaws.com}

curl -s \
 --data-binary @samples/test211_freight_not_palletized.edi \
 -H 'Expect:' \
 -H 'Content-Type:application/EDI-X12' \
 -H 'Accept:application/xml' \
 ${FRESNOHOST}:8080/transactions/translator \
 | saxonb-xslt -xsl:src/xslt/x211_to_x810_invoice.xslt - \
 | curl \
     --data-binary @- \
     -H 'Expect:' \
     -H 'Content-Type:application/xml' \
     ${FRESNOHOST}:8080/transactions/outbound && echo
