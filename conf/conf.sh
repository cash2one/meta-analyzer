#!/bin/bash

export HADOOP="/home/work/hadoop-client/hadoop/bin/hadoop"

# Input base path & sub path
export input_base_path="/app/ecom/fcr-ad/zhushixiang/medical_bid/bidword_key/fix_control/raw_data/wise"
export output_base_path="/app/ecom/fcr-ad/zhushixiang/meta_analyzer_tool"
export exp_group="08,09,10"
export control="11"
# Input attributes index
export key_index=0
export value_index=3
export count_index=7
# A threshold of filtering tuple by count
export count_filter=5
# Basic config 
export owner_tag="zhushixiang"
export task_tag="meta_analysis"
export created_at=`date +%Y%m%d-%H%M%S`
# Hadoop parameter
export batch_size=3
export step_1_reduce_task_num=20
export step_2_reduce_task_num=1
export min_split_size=100000000
export num_map_capacity=1000
export num_reduce_capacity=1000
export job_priority="NORMAL"
#export job_priority="VERY_HIGH"
