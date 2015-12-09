#!/bin/bash
source ../lib/util.sh

cur_dir=`pwd`
program="step_1.sh"
batch_size=3
exp_group=(`echo ${exp_group} | awk 'BEGIN{ FS=",";OFS=" " }{$1=$1;print}'`)
flag="0"
task_num=${#exp_group[@]}
today_date=`date +%Y%m%d`

for (( i = 0 ; ; ))
do
	if [ ${flag} -eq 1 ]
	then
		break
	fi

	for (( j = 0; j < batch_size; j ++ ))
	do
		if [ ${i} == ${task_num} ] 
		then
			echo_info "All batch tasks are finished."
			flag="1"
			break
		fi

		echo_info "Starting Task ${j}, exp=${exp_group[${i}]}"
		sh ${program} 1 ${exp_group[${i}]}> ../log/${owner_tag}.${created_at}/step_1/exp.task.${exp_group[$[i]]}.log 2>&1 &
		pid_pool[${j}]=$!
		sleep 5

		(( i ++ ))
	done

	echo_info "Current tasks has reached maximum of batch size. Waitting until current tasks all finish."
	echo_info "PID pool detail as follow:"
	echo_info ${pid_pool[@]}
	
	for (( k = 0; k < j; k++ ))
	do
		wait ${pid_pool[${k}]}
		if [ $? -ne 0 ]
		then
			echo_error "job failed, job_index = ${k}, pid = ${pid_pool[${k}]}"
			exit 1
		else
			echo_info "job complete, job_index = ${k}, pid = ${pid_pool[${k}]}"
		fi
	done
done
echo_info "All jobs finished!"
