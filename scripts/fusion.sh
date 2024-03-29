#! /bin/bash
#SBATCH --mem=70G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-22%2
#SBATCH --partition=carter-compute


chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}

tissue=$1

echo $tissue
echo $chrom

wd=/cellar/users/mpagadal/Programs/fusion_twas-master
cd $wd

##############
#    UKBB    #
##############

ld=/cellar/users/mpagadal/data/ldsc/1000G_plink/EUR/1000G.EUR.

# cmd="Rscript FUSION.assoc_test.R --sumstats ukbb.sumstats.tsv --weights ./WEIGHTS/WEIGHTS/$tissue.pos --weights_dir ./WEIGHTS/WEIGHTS/ --ref_ld_chr $ld --chr $chrom --out ukbb.$tissue.$chrom.dat"
# echo $cmd
# $cmd

# cat ukbb.$tissue.$chrom.dat | awk 'NR == 1 || $NF < 0.05/2058' > ukbb.$tissue.$chrom.top

# Rscript FUSION.post_process.R --sumstats ukbb.sumstats.tsv --input ukbb.$tissue.$chrom.top --out ukbb.$tissue.$chrom.top.analysis --ref_ld_chr $ld --chr $chrom --plot --locus_win 100000


##############
#    MVP    #
##############

for pheno in total free shbg hypogonad #iterate through phenotypes

do

scp /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/ldsc/EUR.$pheno.sumstats.gz EUR.$pheno.sumstats.csv

cmd="Rscript FUSION.assoc_test.R --sumstats EUR.$pheno.sumstats.csv --weights ./WEIGHTS/$tissue.pos --weights_dir ./WEIGHTS/ --ref_ld_chr $ld --chr $chrom --out eur.$pheno.$tissue.$chrom.dat"
echo $cmd
$cmd

cat eur.$pheno.$tissue.$chrom.dat | awk 'NR == 1 || $NF < 0.05/2058' > eur.$pheno.$tissue.$chrom.top

Rscript FUSION.post_process.R --sumstats EUR.$pheno.sumstats.csv --input eur.$pheno.$tissue.$chrom.top --out eur.$pheno.$tissue.$chrom.top.analysis --ref_ld_chr $ld --chr $chrom --plot --locus_win 100000

done
