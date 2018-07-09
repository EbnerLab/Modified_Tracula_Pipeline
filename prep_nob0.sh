#!/bin/bash

#loads appropriate modules (this varies by system)
module load freesurfer/6.0.0
module load fsl/5.0.10
module load mricron

#loops through listed subjects
for a in $a
do

#create directories
    mkdir tracula/$a/
    mkdir tracula/$a/scripts/
    mkdir tracula/$a/dmri/
    mkdir tracula/$a/dmri/xfms
    mkdir tracula/$a/dmri/mni
    mkdir tracula/$a/dlabel/
    mkdir tracula/$a/dlabel/diff/
    mkdir tracula/$a/dlabel/anatorig/
    mkdir tracula/$a/dlabel/anat/

#Convert the input DWI files to NIfTI, using dcm2niix and move to appropriate directories
    dcm2niix DTI/N${a}_64_DTI/DICOM/
    mv DTI/N${a}_64_DTI/DICOM/*64_dir*.nii DTI/N${a}_64_DTI/DICOM/64dir.nii
    mv DTI/N${a}_64_DTI/DICOM/*64_dir*.bval DTI/N${a}_64_DTI/DICOM/64dir.bval
    mv DTI/N${a}_64_DTI/DICOM/*64_dir*.bvec DTI/N${a}_64_DTI/DICOM/64dir.bvec  
    cp DTI/N${a}_64_DTI/DICOM/64dir.nii tracula/$a/dmri/dwi_orig.nii
    cp DTI/N${a}_64_DTI/DICOM/64dir.bval tracula/$a/dmri/dwi_orig_trans.bvals
    cp DTI/N${a}_64_DTI/DICOM/64dir.bvec tracula/$a/dmri/dwi_orig_trans.bvecs

#transpose bvecs and bvals
  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i
        max=(max<NF?NF:max)}
        END {for (i=1; i<=max; i++)
              {for (j=1; j<=NR; j++) 
                  printf "%s%s", a[i,j], (j==NR?RS:FS)
              }
        }' tracula/$a/dmri/dwi_orig_trans.bvals > tracula/$a/dmri/dwi_orig.bvals
        
  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i
        max=(max<NF?NF:max)}
        END {for (i=1; i<=max; i++)
              {for (j=1; j<=NR; j++) 
                  printf "%s%s", a[i,j], (j==NR?RS:FS)
              }
        }' tracula/$a/dmri/dwi_orig_trans.bvecs > tracula/$a/dmri/dwi_orig.bvecs

#reorients dwi to las space
    orientLAS tracula/$a/dmri/dwi_orig.nii tracula/$a/dmri/dwi_orig_las.nii.gz
    mv -f tracula/$a/dmri/dwi_orig_las.bvecs tracula/$a/dmri/bvecs
    mv -f tracula/$a/dmri/dwi_orig_las.bvals tracula/$a/dmri/bvals

#performs eddy current correct
    eddy_correct tracula/$a/dmri/dwi_orig_las.nii.gz tracula/$a/dmri/dwi.nii.gz 0

#rotates bvecs to adjust for eddy current
    mv -f tracula/$a/dmri/bvecs tracula/$a/dmri/bvecs.norot
    xfmrot tracula/$a/dmri/dwi.ecclog tracula/$a/dmri/bvecs.norot tracula/$a/dmri/bvecs

#creates a symbolic link between dwi.nii.gz and data.nii.gz
    ln -sf tracula/$a/dmri/dwi.nii.gz tracula/$a/dmri/data.nii.gz

#creates low-b image and mask
    mri_convert --frame 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 tracula/$a/dmri/dwi.nii.gz tracula/$a/dmri/lowb.nii.gz
    mri_concat --i tracula/$a/dmri/lowb.nii.gz --mean --o tracula/$a/dmri/lowb.nii.gz
    bet tracula/$a/dmri/lowb.nii.gz tracula/$a/dmri/lowb_brain.nii.gz -m -f 0.3
    mv -f tracula/$a/dmri/lowb_brain_mask.nii.gz tracula/$a/dlabel/diff

#quantifies motion in dwi data
##check T value
    dmri_motion --dwi tracula/$a/dmri/dwi_orig.nii --mat tracula/$a/dmri/dwi.ecclog --bval tracula/$a/dmri/bvals --T 41.387096 --out tracula/$a/dmri/dwi_motion.txt

done

#performs steps 1.3-1.7 of freesurfer 6.0.0 tracula pipleine. description found at https://surfer.nmr.mgh.harvard.edu/fswiki/trac-all
trac-all -prep -c tracula_config.txt -nocorr -noqa
