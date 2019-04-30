#!/bin/bash

#loads appropriate modules
module load freesurfer/6.0.0
module load fsl/5.0.10
module load mricron

#starts trac scripts
sbatch tracall_prep_01.sh
sbatch tracall_prep_02.sh