#! /bin/bash
#SBATCH --mem=30G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-23%23
#SBATCH --partition=carter-compute

# Author: Meghana Pagadala
# Date: 10/23/2021
#
# Inputs:
# pheno: phenotype to run association on
# PHENO: phenotype file with column of phenotype values
# GENO: genotype file
# COVAR: covariate file
# OUT: output directory
#
# Outputs:
# $pheno: plink association file 
#

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $chrom

date

# Testosterone GWAS associations

GENO=/cellar/controlled/dbgap-genetic/phs000209_mesa/imputed/chr$chrom
PHENO=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/mesa/phenotypes/pheno.rank.norm.tsv
KEEP=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/mesa/patients/african.pts.txt
REMOVE=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/mesa/patients/remove.related.first.degree.pedigree.txt
COVAR=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/mesa/covariates/cov.tsv
EXTRACT=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/extract.testosterone.snps.hg19.txt

for pheno in tottst1 freetst1 shbg1
do

OUT=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/validation/data/mesa/summarystats/$pheno
mkdir $OUT
cd $OUT

/cellar/users/mpagadal/Programs/plink2 --keep $KEEP --bgen $GENO.bgen ref-last --sample $GENO.sample --extract $EXTRACT --pheno $PHENO --pheno-name $pheno --covar $COVAR --remove $REMOVE --covar-name Age,Gender,PC1-PC10 --covar-variance-standardize --glm firth-fallback cols=+err --out $OUT/$pheno.$chrom

done

date
