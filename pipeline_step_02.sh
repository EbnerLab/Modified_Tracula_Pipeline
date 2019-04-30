#!/bin/bash

#loads appropriate modules (varies by system)
module load freesurfer/6.0.0
module load fsl/5.0.10

#loops through listed subjects
for a in <subjects>
do

#rotates bvecs to adjust for eddy current
    mv -f $a/dmri/bvecs $a/dmri/bvecs.norot
    xfmrot $a/dmri/dwi.ecclog $a/dmri/bvecs.norot $a/dmri/bvecs
    
    echo "bvecs rotated to adjust for eddy current for " $a

#creates low-b image and mask
    mri_convert --frame 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 $a/dmri/dwi.nii.gz $a/dmri/lowb.nii.gz
    mri_concat --i $a/dmri/lowb.nii.gz --mean --o $a/dmri/lowb.nii.gz
    bet $a/dmri/lowb.nii.gz $a/dmri/lowb_brain.nii.gz -m -f 0.3
    mv -f $a/dmri/lowb_brain_mask.nii.gz $a/dlabel/diff

    echo "low-b image and mask created for " $a

#quantifies motion in dwi data
##check T value
    dmri_motion --dwi $a/dmri/dwi_orig.nii --mat $a/dmri/dwi.ecclog --bval $a/dmri/bvals --T 41.387096 --out $a/dmri/dwi_motion.txt

    echo "motion quantified for " $a

done


