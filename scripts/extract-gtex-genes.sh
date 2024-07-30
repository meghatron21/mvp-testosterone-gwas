#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-3
#SBATCH --partition=carter-compute

# '''
# Description: extract variants from each cell type
# '''

# cells=(Whole_Blood Brain_Caudate_basal_ganglia Skin_Sun_Exposed_Lower_leg Stomach Brain_Cerebellar_Hemisphere Brain_Amygdala Minor_Salivary_Gland Artery_Coronary Cells_EBV-transformed_lymphocytes Esophagus_Gastroesophageal_Junction Testis Brain_Anterior_cingulate_cortex_BA24 Kidney_Cortex Brain_Substantia_nigra Brain_Cortex Artery_Tibial Liver Adrenal_Gland Skin_Not_Sun_Exposed_Suprapubic Heart_Atrial_Appendage Colon_Transverse Brain_Nucleus_accumbens_basal_ganglia Brain_Spinal_cord_cervical_c-1 Cells_Cultured_fibroblasts Muscle_Skeletal Brain_Putamen_basal_ganglia Nerve_Tibial Brain_Hypothalamus Uterus Brain_Hippocampus Colon_Sigmoid Spleen Heart_Left_Ventricle Brain_Cerebellum Small_Intestine_Terminal_Ileum Pancreas Ovary Artery_Aorta Brain_Frontal_Cortex_BA9 Esophagus_Mucosa Esophagus_Muscularis Adipose_Visceral_Omentum Pituitary Prostate Vagina Breast_Mammary_Tissue Thyroid Lung Adipose_Subcutaneous)
cells=(Testis Liver Adrenal_Gland)
cell=${cells[$SLURM_ARRAY_TASK_ID - 1]}


map=/cellar/users/mpagadal/data/gtex/GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt
gtex=/cellar/users/mpagadal/data/gtex/GTEx_Analysis_v8_QTLs/GTEx_Analysis_v8_EUR_eQTL_all_associations
genes=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/gtex.significant.genes.metal.txt
out=/cellar/users/mpagadal/projects/TestosteroneGWAS/data/coloc/metal/gtex_files

mkdir -p $out

python -u /cellar/users/mpagadal/projects/TestosteroneGWAS/scripts/bin/compile_gtex_genes.py --mapping $map --direct $gtex --cell $cell --genes $genes --out $out/$cell.snps.csv


date
