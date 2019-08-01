#!/bin/sh

input= ${@?Error:no input given}
ls $input | cut -f 2 -d "/" | cut -f 1 -d "_" | awk 'BEGIN{ print "samples:"}; ( $0 !~ /NEG/ ){print "- " $0 }'
echo "This script will remove Negative controls with string "NEG" within their IDs. If it is something else, manually remove the sample from the config.yaml file"  
