import sys

for line in sys.stdin:
   key, tag, value, count = line.strip().split("\t")
   # Sorted by key and tag
   print "\t".join((key, tag, value, count))
