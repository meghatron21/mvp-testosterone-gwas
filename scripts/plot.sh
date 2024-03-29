#! /bin/bash
#SBATCH --mem=15G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-4%4
#SBATCH --partition=carter-compute

groups=(EUR AFR AMR EAS)
group=${groups[$SLURM_ARRAY_TASK_ID-1]}


date

for pheno in total free shbg hypogonad

do

if [ $pheno == "hypogonad" ]
then
python -u /cellar/users/mpagadal/scripts/manhattan-plot/plot.py --file /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/summarystats/compiled/$group.$pheno.compiled.statistics.tsv --analysis_type logistic --colors black gray --out $group.$pheno   
else
python -u /cellar/users/mpagadal/scripts/manhattan-plot/plot.py --file /cellar/users/mpagadal/projects/TestosteroneGWAS_rev/data/summarystats/compiled/$group.$pheno.compiled.statistics.tsv --analysis_type linear --colors black gray --out $group.$pheno   
fi   
done

date
