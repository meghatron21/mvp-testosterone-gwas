#! /bin/bash
#SBATCH --mem=20G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=3
#SBATCH --partition=carter-compute

date

########################
# GET BASELINE LDSCORE #
########################

folders=(all EUR AFR AMR EAS)
folder=${folders[$SLURM_ARRAY_TASK_ID-1]}

sumstats_dir=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/summarystats/compiled
h2_dir=/cellar/users/mpagadal/projects/TestosteroneGWAS/ldsc
genome_dir=/cellar/users/mpagadal/data/ldsc/1000G_plink/$folder
frq_dir=/cellar/users/mpagadal/data/ldsc/1000G_plink/$folder\_frq/1000G.$folder.
ldsc_dir=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/ldsc2
# snp_lst=/cellar/users/mpagadal/data/ldsc/w_hm3.snplist
snp_lst=/cellar/users/mpagadal/data/ldsc/w_hm3.nohla.snplist

pheno=$1

    sumstats=$sumstats_dir/$folder.$pheno.compiled.rsid.statistics.tsv.lifted

    #############################
    # FORMAT SUMMARY STATISTICS #
    #############################

    cd $ldsc_dir
    cut -f-5,7- $sumstats > $sumstats.ldsc
    python ~/Programs/ldsc/munge_sumstats.py --snp ID --a1 ALT --a2 REF --N-col OBS_CT --sumstats $sumstats.ldsc --merge-alleles $snp_lst --chunksize 500000 --out $folder.$pheno

    ########################
    # compute heritability #
    ########################

    python ~/Programs/ldsc/ldsc.py --h2 $folder.$pheno.sumstats.gz --ref-ld-chr $genome_dir/baseline. --w-ld-chr $genome_dir/baseline. --frqfile-chr $frq_dir --out $folder.$pheno.herit.nohla


date

