#!/bin/bash
#source ../conf/conf.sh
source ../lib/util.sh

mkdir ../output/${owner_tag}.${created_at}
cd ../output/${owner_tag}.${created_at}

exp_group=(`echo ${exp_group} | awk 'BEGIN{ FS=",";OFS=" " }{$1=$1;print}'`)
task_num=${#exp_group[@]}
for (( i = 0 ; i < task_num ; i ++ ))
do
	result=`${HADOOP} fs -cat "${output_base_path}/result/e${exp_group[${i}]}-c${control}/part-00000"` 
	plot_meta_result="${exp_group[${i}]} `echo ${result} | cut -d " " -f 7`"
	plot_avg_result="${exp_group[${i}]} `echo ${result} | cut -d " " -f 5` `echo ${result} | cut -d " " -f 6`"
	echo ${result} >> meta_result.txt
	echo ${plot_meta_result} >> ../../resource/_tmp_meta_plot.dat
	echo ${plot_avg_result} >> ../../resource/_tmp_avg_plot.dat
done

gnuplot ../../lib/plot_meta.gp

cd ..
echo_info "All results have been retrived. Please check /output/${owner_tag}.${created_at}"

rm ../resource/_tmp_meta_plot.dat
rm ../resource/_tmp_avg_plot.dat
