#!/usr/bin/env python

import collections
import sys
import string

# extract the taxa information
taxa = {}
infile = open(sys.argv[2], "r")
for line in infile:
	line = line.strip()
	if line != "":
		fields = line.split()
		taxa[fields[0]] = fields[1:]
infile.close()

def process(reads):
	# map the reads to the taxa
	levels = map(lambda x: taxa[x[1]], reads)
	# compute the min common level
	minLevel = min(map(lambda x: len(x), levels))
	# iterate through the levels to get the counts
	lastLevel = None
	for i in range(minLevel):
		counts = {}
		for level in levels:
			if not counts.has_key(level[i]):
				counts[level[i]] = 0
			counts[level[i]] += 1
		maxPercentage = float(max(map(lambda x: counts[x], counts.keys()))) / len(reads)
		if maxPercentage > 0.51:
			lastLevel = i
		else:
			break	
	if lastLevel == None:
		return "Anything"
	else:
		return ",".join(levels[0][:lastLevel+1])
# extract the reads
results = []
reads = []
infile =open(sys.argv[1], "r")
for line in infile:
	line = line.strip()
	if line != "":
		fields = line.split()
		if len(reads) > 0 and fields[0] != reads[-1][0]:
			results.append(process(reads))
			reads = []
		reads.append(tuple(fields))
infile.close()

results.append(process(reads))

cnt = collections.Counter()
for line in results:
	cnt[line] += 1
count_taxa = cnt.items()

outfile = open(sys.argv[3], "w")
outfile.write("\n".join(map(lambda x: "%s\t%d" % x, count_taxa)))
outfile.close()


