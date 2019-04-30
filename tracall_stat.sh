#!/bin/bash
#SBATCH --account=<hpg_account>
#SBATCH --qos=<hpg_cores>
#SBATCH --job-name=dti_stat
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email>
#SBATCH --ntasks=1
#SBATCH --mem=5gb
#SBATCH --time=2:00:00
#SBATCH --output=dti_stat_%j.out
pwd; hostname; date

module load freesurfer/6.0.0 
module load fsl/5.0.10
 
trac-all -stat -c tracall_stat.txt -no-isrunning

date