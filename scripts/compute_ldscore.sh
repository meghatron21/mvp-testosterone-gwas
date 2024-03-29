#! /bin/bash
#SBATCH --mem=20G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1,2,3,5,6,8,11
#SBATCH --partition=carter-compute

date

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}

folder=$1
out=/cellar/users/mpagadal/data/ldsc/1000G_plink/$folder
cd $out

python ~/Programs/ldsc/ldsc.py --yes-really --l2 --bfile 1000G.$folder.$chrom.CM --ld-wind-cm 1 --out baseline.$chrom

date

