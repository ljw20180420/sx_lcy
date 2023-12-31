#!/bin/bash
# usage: view.sh algfile [readnum]
# example: view.sh ljhlyz/AN1-SG4-M1B-1-1_R1.fq.gz.alg.75.30.30 50

# display the first readnum (default: 50) read's alignments in ANSI format, the cut points and random insertions are aligned

algfile=$1 # alignments (input.alg.cut.ext1.ext2)
tablefile=$(sed -r 's/.alg./.table./' <<<$algfile)
read cut1 cut2 ref1len <<<$(awk -F "." -v OFS=" " '{print $(NF-2), $(NF-1), $NF}' <<<$algfile)
readnum=${2:-50} # read number to display (default: 50)
head -n$(($readnum * 3)) <$algfile | align_align.py $(($ref1len)) $cut1 $(($ref1len + $cut2)) | paste - <(head -n$(($readnum + 1)) $tablefile | awk -F "\t" 'NR==1{for(i=1;i<NF;++i) if($i=="percent"){pf=i;break} print ""} NR>1{printf("%.2f%\n",$pf)}') | column -ts $'\t' | less-643/less -SNR --header 1 --no-number-headers # view the first 50 (150/3) read alignments