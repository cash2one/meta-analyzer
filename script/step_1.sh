#!/bin/bash
#source ../conf/conf.sh
source ../lib/util.sh

#input_base_path=$1
#output_base_path=$2
#key_index=$4
#value_index=$5
#count_index=$6
#count_filter=$7
exp_or_con=$1
sub_path=$2

echo_info "Checking validation of input path: ${sub_path}"
input_path="${input_base_path}/${sub_path}"
check_valid_path ${input_path}
if [ $? -ne 0 ]
then
	echo_error "Invalid input path."
	exit 1
else
	input_path="${input_path}/*/*"
fi
echo_info "Input path are: ${input_path}"

echo_info "Checking existence of output path..."
output_path="${output_base_path}/tmp/${sub_path}"
check_exist_path ${output_path}
if [ $? -ne 0 ]
then
	exit 1
fi

echo_info "Hadoop Streaming job started."
${HADOOP} streaming \
	-D mapred.job.name="${owner_tag}.${task_tag}.merge" \
	-D mapred.reduce.tasks=${step_1_reduce_task_num} \
	-D mapred.combine.input.format.local.only=false \
	-D mapred.min.split.size=${min_split_size} \
	-D mapred.job.map.capacity=${num_map_capacity} \
	-D mapred.job.reduce.capacity=${num_reduce_capacity} \
	-D mapred.job.priority="${job_priority}" \
	-partitioner "org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner" \
	-inputformat "org.apache.hadoop.mapred.CombineTextInputFormat" \
	-input ${input_path} \
	-output ${output_path} \
	-mapper "python mapper.set_tag.py ${key_index} ${value_index} ${count_index} ${count_filter} ${exp_or_con}" \
	-reducer "python reducer.merge_key.py" \
	-file "mapper.set_tag.py" \
	-file "reducer.merge_key.py"

ret_inter=$?
if [ ${ret_inter} -ne 0 ]
then	
	echo_error "Error! Hadoop Streaming Job was Failed."
	exit 1
else
	echo_info "Hadoop Streaming Job was successful!" 
fi
