#! /bin/bash
#SBATCH --mem=70G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --partition=carter-compute


# Author: Meghana Pagadala
# Date: 10/23/2021
#

# submit plink script to run glm
sbatch plink-glm-ukbb.sh --wait

# format summary statistics
#head -1 Testosterone.1.Testosterone.glm.linear > Testosterone.GWAS.ADD
#awk '{ if ($7 == "ADD") { print $0} }' *linear >> Testosterone.GWAS.ADD 

# extract MVP variants from summary statistics




date
