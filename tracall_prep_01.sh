#!/bin/bash
#SBATCH --account=<hpg_account>
#SBATCH --qos=<hpg_cores>
#SBATCH --job-name=dti_preprocess
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email>
#SBATCH --ntasks=1
#SBATCH --mem=5gb
#SBATCH --time=48:00:00
#SBATCH --output=dti_preprocess_%j.out
pwd; hostname; date

module load freesurfer/6.0.0 
module load fsl/5.0.10
 
trac-all -prep -c tracula_config.txt -nocorr -noqa -noprior -no-isrunning

date