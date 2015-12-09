#!/bin/bash
#source ../conf/conf.sh
source ../lib/util.sh

experimental_group=$1
control_group=$2

echo_info "Checking validation of input path..."
input_path=""
experimental_path="${output_base_path}/tmp/${experimental_group}"
control_path="${output_base_path}/tmp/${control_group}"
check_valid_path ${experimental_path}
if [ $? -eq 0 ]
then
	input_path="${input_path} ${experimental_path}/part-*"
fi
check_valid_path ${control_path}
if [ $? -eq 0 ]
then
	input_path="${input_path} ${control_path}/part-*"
fi
echo_info "Input paths are: ${input_path}"

echo_info "Checking existence of output path..."
output_path="${output_base_path}/result/e${experimental_group}-c${control_group}"
check_exist_path ${output_path}
if [ $? -ne 0 ]
then
	exit 1
fi

echo_info "Hadoop Streaming job started."
${HADOOP} streaming \
	-D mapred.job.name="${owner_tag}.meta" \
	-D stream.map.output.field.separator="\t" \
	-D stream.num.map.output.key.fields=2 \
	-D map.output.key.field.separator="\t" \
	-D num.key.fields.for.partition=1 \
	-D mapred.reduce.tasks=${step_2_reduce_task_num} \
	-D mapred.combine.input.format.local.only=false \
	-D mapred.min.split.size=${min_split_size} \
	-D mapred.job.map.capacity=${num_map_capacity} \
	-D mapred.job.reduce.capacity=${num_reduce_capacity} \
	-D mapred.job.priority="${job_priority}" \
	-partitioner "org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner" \
	-inputformat "org.apache.hadoop.mapred.CombineTextInputFormat" \
	-input ${input_path} \
	-output ${output_path} \
	-mapper "python mapper.join.py" \
	-reducer "python reducer.compute_meta.py" \
	-file "mapper.join.py" \
	-file "reducer.compute_meta.py"

ret_inter=$?
if [ ${ret_inter} -ne 0 ]
then	
	echo_error "Error! Hadoop Streaming Job was Failed."
	exit 1
else
	echo_info "Hadoop Streaming Job was successful!" 
fi
