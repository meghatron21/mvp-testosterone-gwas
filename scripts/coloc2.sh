#! /bin/bash
#SBATCH --mem=30G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-3
#SBATCH --time=4-00:00:00
#SBATCH --partition=carter-compute

cells=(Testis Liver Adrenal_Gland)
cell=${cells[$SLURM_ARRAY_TASK_ID - 1]}

pheno=hypogonad
group=$1

mvp=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/summarystats/compiled/$group.$pheno.compiled.statistics.tsv
gtex=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/gtex_files/$cell.snps.csv
coloc_input=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/coloc_input/hypogonad2/$group/
coloc_output=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/coloc_output/hypogonad2/$group/

mkdir -p $coloc_input
mkdir -p $coloc_output

python -u /cellar/users/mpagadal/projects/TestosteroneGWAS/scripts/bin/make-coloc-input.py --gtex $gtex --mvp $mvp --type logistic --out $coloc_input

Rscript /cellar/users/mpagadal/projects/TestosteroneGWAS/scripts/bin/coloc.R $coloc_input $cell $coloc_output
    
date
