#!/bin/sh

input=${@?Error:no input given}
awk 'BEGIN{ print "#Acession\tReads\tYield\tGeeCee\tMinLen\tAvgLen\tMaxLen\tModeLen\tPhred\tAvgQual"}; {print $2}' $input | tr '\n' '\t' | sed $'s/input/\\\n&/g' | sed 's/input\///g;s/_R1.fastq.gz//g' | sed -e '$a\'
