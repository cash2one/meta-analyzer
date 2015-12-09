import sys

key_index = int(sys.argv[1])
value_index = int(sys.argv[2])
count_index = int(sys.argv[3])
count_filter = float(sys.argv[4])
# exp = 1
# con = 0
exp_or_con = sys.argv[5]
# Sorted by key
for line in sys.stdin:
    if line == "":
        continue
    line = line.strip().split("\t")
    key = line[key_index]
    value = line[value_index]
    # Set default count if count index is invalid.
    if count_index == -1:
        count = "1"
    else:
        count = line[count_index]
    # Filtering
    if float(count) < count_filter:
        continue
    print "\t".join((key, exp_or_con, value, count))

