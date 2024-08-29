#!/bin/sh

FILES="
DRR0.all_minimap2.txt.zst
DRR1.all_minimap2.txt.zst
DRR2.all_minimap2.txt.zst
DRR3.all_minimap2.txt.zst
DRR4.all_minimap2.txt.zst
DRR5.all_minimap2.txt.zst
DRR6.all_minimap2.txt.zst
DRR7.all_minimap2.txt.zst
DRR8.all_minimap2.txt.zst
DRR9.all_minimap2.txt.zst
ERR0.all_minimap2.txt.zst
ERR10.all_minimap2.txt.zst
ERR11.all_minimap2.txt.zst
ERR12.all_minimap2.txt.zst
ERR13.all_minimap2.txt.zst
ERR14.all_minimap2.txt.zst
ERR15.all_minimap2.txt.zst
ERR16.all_minimap2.txt.zst
ERR17.all_minimap2.txt.zst
ERR18.all_minimap2.txt.zst
ERR19.all_minimap2.txt.zst
ERR2.all_minimap2.txt.zst
ERR3.all_minimap2.txt.zst
ERR4.all_minimap2.txt.zst
ERR5.all_minimap2.txt.zst
ERR6.all_minimap2.txt.zst
ERR7.all_minimap2.txt.zst
ERR8.all_minimap2.txt.zst
ERR9.all_minimap2.txt.zst
SRR0.all_minimap2.txt.zst
SRR10.all_minimap2.txt.zst
SRR11.all_minimap2.txt.zst
SRR12.all_minimap2.txt.zst
SRR13.all_minimap2.txt.zst
SRR14.all_minimap2.txt.zst
SRR15.all_minimap2.txt.zst
SRR16.all_minimap2.txt.zst
SRR17.all_minimap2.txt.zst
SRR18.all_minimap2.txt.zst
SRR19.all_minimap2.txt.zst
SRR20.all_minimap2.txt.zst
SRR21.all_minimap2.txt.zst
SRR22.all_minimap2.txt.zst
SRR23.all_minimap2.txt.zst
SRR24.all_minimap2.txt.zst
SRR25.all_minimap2.txt.zst
SRR26.all_minimap2.txt.zst
SRR27.all_minimap2.txt.zst
SRR28.all_minimap2.txt.zst
SRR29.all_minimap2.txt.zst
SRR3.all_minimap2.txt.zst
SRR4.all_minimap2.txt.zst
SRR5.all_minimap2.txt.zst
SRR6.all_minimap2.txt.zst
SRR7.all_minimap2.txt.zst
SRR8.all_minimap2.txt.zst
SRR9.all_minimap2.txt.zst
"

for f in $FILES; do
  echo $f
  aws s3 cp s3://serratus-rayan/beetles/logan_aug26_run/minimap2-concat/$f . --no-sign-request
  dx upload --destination alignments/ $f
  rm $f
done
