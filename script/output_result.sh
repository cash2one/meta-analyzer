#!/bin/bash
#source ../conf/conf.sh
source ../lib/util.sh

if [ ! -d "../output/${owner_tag}.${task_tag}" ]
then
	echo_info "Creating new output path."
	mkdir ../output/${owner_tag}.${task_tag}
else
	echo_warning "The output path is existed. Removing the last result."
	rm ../output/${owner_tag}.${task_tag}/*
fi

cd ../output/${owner_tag}.${task_tag}

exp_group=(`echo ${exp_group} | awk 'BEGIN{ FS=",";OFS=" " }{$1=$1;print}'`)
task_num=${#exp_group[@]}
echo ${task_num}
for (( i = 0 ; i < task_num ; i ++ ))
do
	result=`${HADOOP} fs -cat "${output_base_path}/result/e${exp_group[${i}]}-c${control}/part-00000"` 
	plot_meta_result="`echo ${result} | cut -d " " -f 11` ${exp_group[${i}]}"
	plot_avg_result="`echo ${result} | cut -d " " -f 9` `echo ${result} | cut -d " " -f 10` "${exp_group[${i}]}
	echo ${result} >> meta_result.txt
	echo ${plot_meta_result} >> ../../resource/_tmp_meta_plot.dat
	echo ${plot_avg_result} >> ../../resource/_tmp_avg_plot.dat
done

../../lib/gnuplot ../../lib/plot_meta.gp

cd ..
echo_info "All results have been retrived. Please check /output"

rm ../resource/_tmp_meta_plot.dat
rm ../resource/_tmp_avg_plot.dat
