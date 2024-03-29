#! /bin/bash
#SBATCH --mem=40G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-4%4
#SBATCH --partition=carter-compute

date

########################
#   GET GENETIC CORR   #
########################

folders=(EUR AFR AMR EAS)
folder=${folders[$SLURM_ARRAY_TASK_ID-1]}

ldsc_dir=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/ldsc
genome_dir=/cellar/users/mpagadal/data/ldsc/1000G_plink/$folder

date
cd $ldsc_dir

for pheno1 in total free shbg hypogonad

    do
    
    for pheno2 in total free shbg hypogonad
    
        do
    
        python ~/Programs/ldsc/ldsc.py --rg $folder.$pheno1.sumstats.gz,$folder.$pheno2.sumstats.gz --ref-ld-chr $genome_dir/baseline. --w-ld-chr $genome_dir/baseline. --out $folder.$pheno1.$pheno2.corr
        
        done
        
    done
    


date

