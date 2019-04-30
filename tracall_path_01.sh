#!/bin/bash
#SBATCH --account=<hpg_account>
#SBATCH --qos=<hpg_cores>
#SBATCH --job-name=dti_path
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email>
#SBATCH --ntasks=1
#SBATCH --mem=5gb
#SBATCH --time=48:00:00
#SBATCH --output=dti_path_%j.out
pwd; hostname; date

module load freesurfer/6.0.0 
module load fsl/5.0.10
 
trac-all -path -c tracula_config.txt -no-isrunning

date