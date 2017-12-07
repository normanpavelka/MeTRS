# MeTRS
Meta-Total RNA-sequencing (MeTRS) allows unbiased taxonomic characterization of a complex microbial community

_Requirements:_
* SILVA (version 123 or higher)
* R (version 3.1.2 or higher)
* bowtie (version 1.1.2 or higher)
* python (version 2.7.9 or higher)

_Resources:_
* SILVA 123 reference sequences: https://www.arb-silva.de/fileadmin/silva_databases/release_123/Exports/SILVA_123_SSURef_tax_silva.fasta.gz
* SILVA 123 taxonomy legend: https://www.arb-silva.de/fileadmin/silva_databases/release_123/Exports/taxonomy/tax_slv_ssu_123.txt
* R: https://cran.r-project.org/
* bowtie: http://bowtie-bio.sourceforge.net/index.shtml
* python: https://www.python.org/

_Pipeline overview:_
1) Extract FASTA headers from SILVA reference sequence file and run 'SILVA_taxonomy_parse.R' on them to generate the taxonomy file
2) Generate bowtie index library from SILVA reference sequence library
3) Place all sample FASTQ files (and *only* those) in one directory
4) Run 'ConTxT.sh' on files generated in previous 3 steps
