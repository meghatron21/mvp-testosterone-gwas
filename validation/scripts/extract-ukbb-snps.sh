#! /bin/bash
#SBATCH --mem=200G
#SBATCH --partition=carter-compute
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-23%23


#############################

# Name: extract-ukbb-snps.sh
# Adapted from pre-dataloader.sh
# Description: used to extract snps from imputed snp data as input into dataloader.py
# Date: 06/15/2023

#############################


date

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}


geno=/cellar/controlled/ukb-genetic/imputation/ukb_imp_chr$chrom\_v3
extract=/cellar/users/mpagadal/projects/TestosteroneGWAS/validation/data/extract.rsid.txt
out=/cellar/users/mpagadal/projects/TestosteroneGWAS/validation/data/UKBB/genotypes

cd $out

if [[ "$chrom" == X ]]; then

/cellar/users/mpagadal/Programs/plink2 --bgen $geno.bgen ref-first --sample $geno.sample --extract $extract --make-pgen --out $out/chr$chrom

/cellar/users/mpagadal/Programs/plink2 --pfile chr$chrom --extract $extract --recode A --out chr$chrom

else

/cellar/users/mpagadal/Programs/plink2 --bgen $geno.bgen ref-first --sample $geno.sample --extract $extract --make-pgen --out $out/chr$chrom

/cellar/users/mpagadal/Programs/plink2 --pfile chr$chrom --extract $extract --recode A --out chr$chrom

fi



date
