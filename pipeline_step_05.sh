#!/bin/bash

for i in <subjects>
do

  unlink $i/data.nii.gz
  unlink $i/dmri/nodif_brain_mask.nii.gz
  rm $i/bedpostx.sh
  cp scripts/bedpostx.sh $i
  cp $i/dmri/dwi.nii.gz $i/dmri/data_cp.nii.gz
  mv $i/dmri/data_cp.nii.gz $i/dmri/data.nii.gz
  cp $i/dlabel/diff/aparc+aseg_mask.bbr.nii.gz $i/dmri/aparc+aseg_mask.bbr.nii.gz
  mv $i/dmri/aparc+aseg_mask.bbr.nii.gz $i/dmri/nodif_brain_mask.nii.gz

  cd $i
  
    sbatch bedpostx.sh
  
  cd ../

  echo "bedpostx started for " $i

done
