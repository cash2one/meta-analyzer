import sys

exp_value = 0.0
exp_count = 0.0
con_value = 0.0
con_count = 0.0
sum_theta = 0.0
sum_w = 0.0
sum_con_value = 0.0
sum_con_count = 0.0
sum_exp_value = 0.0
sum_exp_count = 0.0

last_key = "Null_key"
last_tag = "Null_tag"

for line in sys.stdin:
    key, tag, value, count = line.strip().split("\t")
    
    if key == last_key:
        if tag == "1" and last_tag == "0":
            exp_value = float(value)
            exp_count = float(count)
            # Compute theta i
            theta_i = exp_value - con_value
            std_error = 1.0 / exp_count + 1.0 / con_count
            w_i = 1.0 / std_error
            # For Computing final theta
            sum_theta += theta_i * w_i
            sum_w += w_i
            # For computing average value in control
            sum_con_value += con_value * con_count
            sum_con_count += con_count
            # For computing average value in experimental
            sum_exp_value += exp_value * exp_count
            sum_exp_count += exp_count
        else:
            print >> sys.stderr, "invalid tag, last_tag=%s, tag=%s, line: %s" % (last_tag, tag, line)
            exit(1)

    elif key != last_key:
        if tag == "0":
            con_value = float(value)
            con_count = float(count)
            
    last_key = key
    last_tag = tag

print "\t".join((str(sum_exp_value), str(sum_exp_count), str(sum_con_value), str(sum_con_count), str(sum_exp_value/sum_exp_count), str(sum_con_value/sum_con_count), str(sum_theta/sum_w)))
