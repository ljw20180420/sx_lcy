#!/bin/bash
# usage: rearr_run.sh input ref sgRNA [ext1 [ext2]]
# example: rearr_run.sh ljhlyz/AN1-SG4-M1B-1-1_R1.fq.gz "CTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGCTGTTGCTGTTGCTGGTGCTGATGGTGATGTGTTGAGACTGGTGGGTGGGCGGTGGACTGGGCCCCAGTAGAGGGAGGGAAGGGGCCTGGATGGGCATTGCTGTT" "GGTGATGTGTTGAGACTGGT" 30 30 16

# input can be (compressed) fasta/fastq
# ref and sgRNA are given in command line
# ext1 is upstream end downstream extension for template inserion (default: 30)
# ext2 is downstream end upstream extension (default: 30)

get_indel()
{
    # infer random insertion and left/right template indel
    cat >get_indel_tmp
    count=$(awk '{count += $2} END{print count}' <get_indel_tmp)
    awk -F "\t" -v OFS="\t" -v count="$count" '
        BEGIN{print "index", "count", "score", "updangle", "ref_start1", "query_start1", "ref_end1", "query_end1", "random_insertion", "ref_start2","query_start2", "ref_end2", "query_end2", "downdangle", "cut1", "cut2", "percent", "left_del", "right_del", "temp_left_ins", "temp_right_ins", "random_ins", "indel_type"}
        {
            printf("%s\t%.2f\t", $0, $2/count*100)
            ldel = ($15 > $7 ? $15 - $7 : 0);
            rdel = ($10 > $16 ? $10 - $16 : 0);
            del = ldel + rdel;
            tlins = ($7 > $15 ? $7 - $15 : 0);
            trins = ($16 > $10 ? $16 - $10 : 0);
            rins = length($9);
            ins = tlins + trins + rins
            printf("%d\t%d\t%d\t%d\t%d\t", ldel, rdel, tlins, trins, rins)
            if (del > 0 && ins > 0) print "indel";
            else if (del > 0 && ins == 0) print "del";
            else if (del == 0 && ins > 0) print "ins";
            else print "WT";
        }' <get_indel_tmp
    rm -f get_indel_tmp
}

input=$1 # the input file
case $input in # count duplicate reads, support fasta, fastq, and their compressions
    *.fq.gz|*.fastq.gz)
        echo "the input is gzip fastq file"
        zcat $input | sed -n '2~4p' | sort | uniq -c | sort -k1,1nr | awk -v OFS="\t" '{print $2, $1}' >$input.count;;
    *.fa.gz|*.fasta.gz)
        echo "the input is gzip fasta file"
        zcat $input | sed -n '2~2p' | sort | uniq -c | sort -k1,1nr | awk -v OFS="\t" '{print $2, $1}' >$input.count;;
    *.fq|*.fastq)
        echo "the input is fastq file"
        sed -n '2~4p' $input | sort | uniq -c | sort -k1,1nr | awk -v OFS="\t" '{print $2, $1}' >$input.count;;
    *.fa|*.fasta)
        echo "the input is fasta file"
        sed -n '2~2p' $input | sort | uniq -c | sort -k1,1nr | awk -v OFS="\t" '{print $2, $1}' >$input.count;;
esac
ref1=$2 # reference1
ref2=$3 # reference2
sgRNA1=$4 # sgRNA1
sgRNA2=$5 # sgRNA2

read cut1 NGGCCNtype1 cut2 NGGCCNtype2 <<< $(generate_ref_file.py $input $ref1 $ref2 $sgRNA1 $sgRNA2) # prepare the reference file and return the cut point

rearrangement <$input.count 3<$input.ref.$cut1.$cut2.${#ref1} -u -3 -v -9 -s0 -6 -s1 4 -s2 2 -qv -9 | correct_micro_homology.py $cut1 $NGGCCNtype1 $cut2 $NGGCCNtype2 ${#ref1} | tee $input.alg.$cut1.$cut2.${#ref1} | awk -v OFS="\t" -v cut1=$cut1 -v cut2=$((${#ref1} + $cut2)) 'NR%3==1{print $0, cut1, cut2}' | get_indel >$input.table.$cut1.$cut2.${#ref1} # align reads (input.alg), correct micro homology (input.correct)