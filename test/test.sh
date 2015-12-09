cur_path=`pwd`
cd ../script

#cat ../resource/exp_sample | python mapper.set_tag.py 0 1 2 0 1 | sort -k 1,1 | python reducer.merge_key.py > ../test/tmp.exp.merge.output
#cat ../resource/con_sample | python mapper.set_tag.py 0 1 2 0 0 | sort -k 1,1 | python reducer.merge_key.py > ../test/tmp.con.merge.output

#cat ../resource/sample_tag_0 ../resource/sample_tag_1 | python mapper.join.py | sort -k 1,1 -k 2,2 #| python reducer.compute_meta.py > ../test/meta.output 

#cat ../resource/sample_tag_0 ../resource/sample_tag_1 | python mapper.join.py | sort -k 1,1 -k 2,2 
cat ../resource/part-00019 | python reducer.compute_meta.py > ../test/test.meta.output 
cd ${cur_path}
