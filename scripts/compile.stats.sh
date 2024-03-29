#! /bin/bash
#SBATCH --mem=40G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=4
#SBATCH --partition=carter-compute

date

groups=(AFR AMR CSA EAS EUR MID all)
group=${groups[$SLURM_ARRAY_TASK_ID-1]}

sumstats_out=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/summarystats/compiled/
circos_out=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/circos/scatter
ldsc_out=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/summarystats/ldsc
dbsnp_out=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/dbsnp
dbsnp=/cellar/users/mpagadal/data/dbsnp/GCF_000001405.39.gz
pheno=$1

cd $sumstats_out

chunk_direct=/cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/summarystats/chunks/$pheno/$group/

# combine chunks
# python -u /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/scripts/bin/compile.stats.py --folder $chunk_direct --out $sumstats_out/$group.$pheno.compiled.statistics.tsv

# make circos input
python -u /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/scripts/bin/make-circos.py --sumstats $sumstats_out/$group.$pheno.compiled.statistics.tsv --out $circos_out/compiled.$group.$pheno.circos

# #make positions file
python -u /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/scripts/bin/make-pos.py --circos $circos_out/compiled.$group.$pheno.circos --out $pheno.$group.pos.txt

tabix -h $dbsnp -R $pheno.$group.pos.txt >> $pheno.$group.dbsnp.txt

# make rsid file

rsid=$pheno.$group.dbsnp.txt
stats=$sumstats_out/$group.$pheno.compiled.statistics.tsv

if [ $pheno == "hypogonad" ]
then
python -u /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/scripts/bin/make-rsid.py --rsid $rsid --logistic --stats $stats --out $group.$pheno.compiled.rsid.statistics.tsv
else
python -u /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/scripts/bin/make-rsid.py --rsid $rsid --stats $stats --out $group.$pheno.compiled.rsid.statistics.tsv
fi

# liftover statistics
python -u /cellar/users/mpagadal/scripts/germline/make-liftover.py --file $group.$pheno.compiled.rsid.statistics.tsv --file_type plink --chr --out $group.$pheno.hg38.bed

/cellar/users/mpagadal/Programs/liftOver $group.$pheno.hg38.bed /cellar/users/mpagadal/Programs/liftover-files/hg38ToHg19.over.chain.gz $group.$pheno.hg19.liftover.bed $group.$pheno.unmapped.bed

python -u /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/scripts/bin/liftover_stats.py --stats $group.$pheno.compiled.rsid.statistics.tsv --liftover $group.$pheno.hg19.liftover.bed --out $group.$pheno.compiled.rsid.statistics.tsv.lifted 


date

