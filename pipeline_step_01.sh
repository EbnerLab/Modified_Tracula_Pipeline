#!/bin/bash

#loads appropriate modules (varies by system)
module load freesurfer/6.0.0
module load fsl/5.0.10
module load mricrogl

#loops through listed subjects
for a in <subjects>

#create directories
    mkdir $a/scripts/
    mkdir $a/dmri/
    mkdir $a/dmri/xfms
    mkdir $a/dmri/mni
    mkdir $a/dlabel/
    mkdir $a/dlabel/diff/
    mkdir $a/dlabel/anatorig/
    mkdir $a/dlabel/anat/
    
    echo "directories created for " $a

#Convert the input DWI files to NIfTI, using dcm2niix and move to appropriate directories 
  dcm2niix DTI/$a/
  mv DTI/$a/*_WIP_64_dir_DT_2PACKAGES_*.nii DTI/$a/64dir.nii
  mv DTI/$a/*_WIP_64_dir_DT_2PACKAGES_*.bval DTI/$a/64dir.bvals
  mv DTI/$a/*_WIP_64_dir_DT_2PACKAGES_*.bvec DTI/$a/64dir.bvecs
  cp DTI/$a/64dir.nii tracula/$a/dmri/
  cp DTI/$a/64dir.bvals $a/dmri/
  cp DTI/$a/64dir.bvecs tracula/$a/dmri/
  cp $a/64dir.nii $a/dmri/64dir.nii
  cp $a/64dir.bvals $a/dmri/64dir.bvals
  cp $a/64dir.bvecs $a/dmri/64dir.bvecs
  mv $a/dmri/64dir.nii $a/dmri/dwi_orig.nii
  mv $a/dmri/64dir.bvals $a/dmri/dwi_orig_trans.bvals
  mv $a/dmri/64dir.bvecs $a/dmri/dwi_orig_trans.bvecs
  
  echo "nifti, bvals, and bvecs copied for " $a

#transpose bvecs and bvals
  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i
        max=(max<NF?NF:max)}
        END {for (i=1; i<=max; i++)
              {for (j=1; j<=NR; j++) 
                  printf "%s%s", a[i,j], (j==NR?RS:FS)
              }
        }' $a/dmri/dwi_orig_trans.bvals > $a/dmri/dwi_orig.bvals
        
  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i
        max=(max<NF?NF:max)}
        END {for (i=1; i<=max; i++)
              {for (j=1; j<=NR; j++) 
                  printf "%s%s", a[i,j], (j==NR?RS:FS)
              }
        }' $a/dmri/dwi_orig_trans.bvecs > $a/dmri/dwi_orig.bvecs

  echo "bvals and bvecs transposed for " $a

#reorients dwi to las space
    orientLAS $a/dmri/dwi_orig.nii $a/dmri/dwi_orig_las.nii.gz
    mv -f $a/dmri/dwi_orig_las.bvecs $a/dmri/bvecs
    mv -f $a/dmri/dwi_orig_las.bvals $a/dmri/bvals
    
    echo "dwi reoriented to las space for " $a

#performs eddy current correct
  cp scripts/eddycorrect.sh $a/

  cd $a/
  
    sbatch eddycorrect.sh
    
  cd ../
    
    echo "eddy current correct performed for " $a

done
