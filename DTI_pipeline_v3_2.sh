#!/bin/bash

#loads appropriate modules (varies by system)
module load freesurfer/6.0.0
module load fsl/5.0.10

#loops through listed subjects
for a in 2103801 2103802 #2100301 2100302 2100501 2100502 2100901 2100902 2101001 2101002 2101101 2101102 2101201 2101202 2101301 2101302 2101401 2101402 2101601 2101602 2101701 2101702 2101901 2101902 2102101 2102102 2102701 2102702 2103101 2103102 2103201 2103202 2103501 2103502 2103801 2103802 2104101 2104102 2104401 2104402 2104701 2104702 2104801 2104802 2105001 2105002 2105101 2105102 2106001 2106002 2106101 2106102 2106401 2106402 2106801 2106802 2106901 2106902 2107001 2107002 2107401 2107402 2107601 2107602 2107801 2107802 2108301 2108302 2108601 2108602 2109001 2109002 2109101 2109102
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


