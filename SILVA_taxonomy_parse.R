# Before running this script, edit the following variables with suitable
# folder names and file names

wd <- "/path/to/SILVA/taxonomy"                             # SILVA folder
taxLegFileName <- "tax_slv_ssu_123.txt"                     # Taxonomy legend
inputFileName <- "SILVA_123_SSURef_tax_silva.txt"           # Taxonomy file

                            ### SCRIPT START ###

setwd(wd)

taxonomyLegend <- read.delim(taxLegFileName, stringsAsFactors=FALSE,
  row.names=1, header=FALSE)
colnames(taxonomyLegend) <- c("num", "rank", "remark", "ver")
rownames(taxonomyLegend) <- sub(";$", "", rownames(taxonomyLegend))

ranks <- unique(taxonomyLegend$rank)  

input <- file(inputFileName)
outputFileName1 <- sub("\\.txt", "_parsed.txt", inputFileName)
output <- file(outputFileName1)

open(input, "r")
open(output, "w")

writeLines(paste(c("OTUid", ranks, "species"), collapse="\t"), output)
while(length(l <- readLines(input, 1)) > 0) {
	OTUid <- sub(">(\\S+) (.+$)", "\\1", l)
	taxonomy <- sub(">(\\S+) (.+$)", "\\2", l)
	tax <- unlist(strsplit(taxonomy, split=";"))
	out <- vector(mode = "character", length=length(ranks))
	names(out) <- ranks
	out["species"] <- tax[length(tax)]
	for(i in (length(tax)-1):1) {
    out[taxonomyLegend[paste(tax[1:i], collapse=";"), "rank"]] <- tax[i]		
	}
	writeLines(paste(c(OTUid, out), collapse="\t"), output)
}

close(input)
close(output)

###

parsedTaxonomy <- readLines(outputFileName1)
parsedTaxonomy <- strsplit(parsedTaxonomy, split="\t")
numCols <- max(as.integer(names(table(sapply(parsedTaxonomy, length)))))
parsedTaxonomy <- t(sapply(parsedTaxonomy, function(x)
  c(x, rep("", numCols-length(x)))))
colnames(parsedTaxonomy) <- parsedTaxonomy[1, ]
parsedTaxonomy <- parsedTaxonomy[-1, ]
myTaxRanks <- c("domain", "kingdom", "phylum", "class", "order", "family",
  "genus", "species")
names(myTaxRanks) <- c("D", "K", "P", "C", "O", "F", "G", "S")
parsedTaxonomy <- parsedTaxonomy[, c("OTUid", myTaxRanks)]

outputFileName2 <- sub("\\.txt", "_8-levels.txt", inputFileName)
write.table(parsedTaxonomy, file=outputFileName2, quote=FALSE, sep="\t",
  row.names=FALSE)

###

terms2remove <- c("unidentified", "uncultured", "incertae", "unknown",
  "unculturable", "uncultivated", "unclassified", "metagenome")
reannotatedTaxonomy <- apply(parsedTaxonomy, 2, function(r) {
  r[grepl(paste(terms2remove, collapse="|"), r, ignore.case=TRUE)] <- ""
  gsub(" ", "_", r)
})

invisible(sapply(myTaxRanks, function(tr) {
  reannotatedTaxonomy[, tr] <<- paste(names(myTaxRanks[myTaxRanks == tr]),
    reannotatedTaxonomy[, tr], sep="__")  
}))

# replace blank terms by inheriting from higher ranking terms
reannotatedTaxonomy <- t(apply(reannotatedTaxonomy, 1, function(otu) {
  if(any(empty <- grepl("^.__$", otu))) {
    for(i in which(empty)) otu[i] <- paste(otu[i], otu[i-1], sep="")
  }
  otu 
}))

# split 'species' column into 'species' and 'strain' columns
reannotatedTaxonomy <- cbind(reannotatedTaxonomy,
  strain=reannotatedTaxonomy[, ncol(reannotatedTaxonomy)])
reannotatedTaxonomy[, "species"] <- sub("(^S__[A-Z][a-z]+_[a-z]+)(\\.?)(.*$)",
  "\\1\\2", reannotatedTaxonomy[, "strain"])

outputFileName3 <- sub("\\.txt", "_9-levels_reannotated.txt", inputFileName)
write.table(reannotatedTaxonomy, file=outputFileName3, quote=FALSE,
  row.names=FALSE, col.names=FALSE)

# collapse taxonomic terms back into a single string
collapsedTaxonomy <- t(apply(reannotatedTaxonomy, 1, function(otu) {
  c(otu[1], paste(otu[2:length(otu)], collapse=";"))
}))

outputFileName4 <- sub("\\.txt", "_collapsed.txt", outputFileName3)
write.table(collapsedTaxonomy, file=outputFileName4, quote=FALSE,
  row.names=FALSE, col.names=FALSE)

                            ### SCRIPT END ###
