import sys

sum_value = 0.0
sum_count = 0.0
total_count = 0.0
last_key = "Null"

for line in sys.stdin:
    key, tag, value, count = line.strip().split("\t")

    if key == "total_count":
        total_count += float(count)
        continue

    if key == last_key:
        sum_value += float(value) * float(count)
        sum_count += float(count)
    elif key != last_key and last_key != "Null":
        print "\t".join((last_key, tag, str(sum_value/sum_count), str(sum_count)))
        sum_value = float(value) * float(count)
        sum_count = float(count)
    elif last_key == "Null":
        sum_value = float(value) * float(count)
        sum_count = float(count)
    last_key = key

print "\t".join((last_key, tag, str(sum_value/sum_count), str(sum_count)))
print "\t".join(("total_count", tag, "\N", str(total_count)))

