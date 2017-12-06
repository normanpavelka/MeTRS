#!/bin/sh

INPUT=/path/to/input/directory  #Requires only fastq files in the directory
OUTPUT=/path/to/output/directory
Silva_reannotated=/path/to/Silva_reannotated.txt 
Silva_bowtie_index=/path/to/Silva/bowtie_prefix

for entry in `ls $INPUT` 
do
echo  "$entry"
(bowtie -a -v3 --best --strata --chunkmbs 1000 ${Silva_bowtie_index} ${INPUT}/${entry} | awk '{print $1 "\t" $3}' > ${OUTPUT}/${entry}.twocol) 2> ${OUTPUT}/${entry}.log
python process.py ${OUTPUT}/${entry}.twocol $Silva_reannotated ${OUTPUT}/${entry}_abundances.txt
done
