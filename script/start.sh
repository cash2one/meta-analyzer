#!/bin/bash
source ../conf/conf.sh
source ../lib/util.sh

para_num=$#
if [ ${para_num} -lt 5 ]
then
	mkdir ../log/${owner_tag}.${created_at}
	echo_warning "Only ${para_num} parameters are given. Default path/index/filter will be used. if you want to set your own path, 5 parameters are expected at least which represent owner_tag, input_base_path, output_base_path, exp_group and control respectively."
elif [ ${para_num} -gt 9 ]
then
	mkdir ../log/${owner_tag}.${created_at}
	echo_error "Invalid command. ${para_num} parameters are given. 9 parameters are expected at most."
	exit 1
else
	export owner_tag=$1
	export input_base_path=$2
	export output_base_path=$3
	#export exp_group=(`echo $4 | awk 'BEGIN{ FS=",";OFS=" " }{print}'`)
	export exp_group=$4
	export control=$5
	if [ ${para_num} -ge 6 ]
	then
		export key_index=$6
	fi
	if [ ${para_num} -ge 7 ]
	then
		export value_index=$7
	fi
	if [ ${para_num} -ge 8 ]
	then
		export count_index=$8
	fi
	if [ ${para_num} -ge 9 ]
	then
		export count_filter=$9
	fi
	mkdir ../log/${owner_tag}.${created_at}
fi

mkdir ../log/${owner_tag}.${created_at}/step_1
mkdir ../log/${owner_tag}.${created_at}/step_2

echo_info "==================== Configuration ===================="
echo_info "Owner tag:\t${owner_tag}"
echo_info "Input Base path:\t${input_base_path}"
echo_info "Output Base path:\t${output_base_path}"
echo_info "Experimental Group:\t${exp_group}"
echo_info "Control:\t${control}"
echo_info "Index of key:\t${key_index}"
echo_info "Index of value:\t${value_index}"
if [ ${count_index} -eq -1 ]
then
	echo_warning "Each tuple doesn't have count & count_filter attribute."
else
	echo_info "Index of count:\t${count_index}"
	echo_info "Threshold of count filter:\t${count_filter}"
fi

sh bat.step_1.sh > ../log/${owner_tag}.${created_at}/step_1/batch.log
sh step_1.sh 0 ${control} > ../log/${owner_tag}.${created_at}/step_1/con.task.${control}.log

sh bat.step_2.sh > ../log/${owner_tag}.${created_at}/step_2/batch.log

sh output_result.sh
