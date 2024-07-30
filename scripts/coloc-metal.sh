#! /bin/bash
#SBATCH --mem=30G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-3
#SBATCH --time=4-00:00:00
#SBATCH --partition=carter-compute

cells=(Testis Liver Adrenal_Gland)
cell=${cells[$SLURM_ARRAY_TASK_ID - 1]}

pheno=$1

mvp=/cellar/users/mpagadal/Programs/metal/testosterone/$pheno/METAANALYSIS1.TBL
gtex=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/gtex_files/$cell.snps.csv
coloc_input=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/metal/coloc_input/$pheno/all/
coloc_output=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/metal/coloc_output/$pheno/all/

mkdir -p $coloc_input
mkdir -p $coloc_output

# python -u /cellar/users/mpagadal/projects/TestosteroneGWAS/scripts/bin/make-coloc-input-metal.py --gtex $gtex --mvp $mvp --type logistic --out $coloc_input

Rscript /cellar/users/mpagadal/projects/TestosteroneGWAS/scripts/bin/coloc.metal.R $coloc_input $cell $coloc_output
    
date
