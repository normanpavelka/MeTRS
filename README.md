# MeTRS
Meta-Total RNA-sequencing (MeTRS) allows unbiased taxonomic characterization of a complex microbial community

_Requirements:_
* R 3.1.2 or higher
* bowtie version 1.1.2 or higher
* Python 2.7.9 or higher
* SILVA Taxonomy version 123 or higher

_Pipeline overview:_
1) Run SILVA_Taxonomy_parse.R to reannotated the taxonomy
2) Generate bowtie index library from SILVA reference sequence library
3) Place all sample FASTQ files (and ONLY those) in one directory
4) Run ConTxT.sh on files generated in previous 3 steps
