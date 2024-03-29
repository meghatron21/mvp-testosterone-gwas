#! /bin/bash
#SBATCH --mem=250G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-8%2
#SBATCH --partition=carter-compute


# Author: Meghana Pagadala
# Date: 10/19/2021
#
# Inputs:
# chrom: list of chromosomes
# PHENO: phenotype file with testosterone values from UKBB
# GENO: genotype file
# COVAR: covariate file
# OUT: output directory
#
# Outputs:
# $pheno: plink association file 
#

chroms=(5 8 9 11 13 18 20 21)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $chrom

date

# Testosterone GWAS associations


OUT=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/UKBB/summarystats
GENO=/cellar/controlled/ukb-genetic/imputation/ukb_imp_chr$chrom\_v3
COVAR=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/UKBB/covariates/cov.tsv
PHENO=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/UKBB/phenotypes/pheno.rank.csv
EXTRACT=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/extract.txt

/cellar/users/mpagadal/Programs/plink2 --bgen $GENO.bgen ref-first --sample $GENO.sample --extract $EXTRACT --pheno $PHENO --pheno-name Testosterone --covar $COVAR --covar-name AGE,PC1-PC10 --covar-variance-standardize --glm firth-fallback cols=+err --out $OUT/Testosterone.$chrom

/cellar/users/mpagadal/Programs/plink2 --bgen $GENO.bgen ref-first --sample $GENO.sample --extract $EXTRACT --pheno $PHENO --pheno-name SHBG --covar $COVAR --covar-name AGE,PC1-PC10 --covar-variance-standardize --glm firth-fallback cols=+err --out $OUT/SHBG.$chrom


date
