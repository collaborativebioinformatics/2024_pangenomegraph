#!/bin/bash
####depends on "filter_parse_script.sh"
####installing gnu parallel
#wget https://ftpmirror.gnu.org/parallel/parallel-latest.tar.bz2
#tar -xf parallel-latest.tar.bz2
#./configure prefix=/home/dnanexus/Software/parallel-20240822
#make
#make install
#export PATH=/home/dnanexus/Software/parallel-20240822/bin:$PATH

#dx ls alignments/SRR* |wc -l
# 28 files here
#dx download filter_parse_script.sh
#chmod u+x filter_parse_script.sh

i=1
for j in {1..2}
do
    #work on 14 files at a time to avoid disk space issues
    while read line && [[ i -le $((14*$j)-1) ]] && [[ $i -gt $((14*($j-1))) ]]
    do
        echo "lower bound: $((14*($j-1)))" "upper bound: $((14*j))"
        dx download ./alignments/${line}
        i=$((i+1))
    done <"align_list.txt"
    parallel --progress -j 7 zstd -dk ::: *all_minimap2.txt.zst
    ls *all_minimap2.txt >align_list_decomp.txt
    #or use "-j +0" to use all available cores
    parallel --progress -j +0 ./filter_parse_script.sh ::: `cat align_list_decomp.txt`
    rm *all_minimap2.txt *all_minimap2.txt.zst
    parallel --progress -j 4 dx upload --destination /filt_csv/ {} ::: *.all_minimap2.csv
done
