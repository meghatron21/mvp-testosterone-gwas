#! /bin/bash
#SBATCH --mem=60G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1
#SBATCH --partition=carter-compute

tissues=(Testis Spleen Ovary Skin_Not_Sun_Exposed_Suprapubic Liver Brain_Substantia_nigra Nerve_Tibial Breast_Mammary_Tissue Artery_Tibial Skin_Sun_Exposed_Lower_leg Thyroid Brain_Cerebellum Small_Intestine_Terminal_Ileum Artery_Aorta Brain_Cortex Brain_Amygdala Adipose_Visceral_Omentum Vagina Esophagus_Gastroesophageal_Junction Uterus Adipose_Subcutaneous Esophagus_Muscularis Minor_Salivary_Gland Pancreas Cells_Transformed_fibroblasts Brain_Caudate_basal_ganglia Brain_Cerebellar_Hemisphere Prostate Esophagus_Mucosa Artery_Coronary Colon_Sigmoid Pituitary Brain_Frontal_Cortex_BA9 Heart_Atrial_Appendage Heart_Left_Ventricle Adrenal_Gland Brain_Hippocampus Brain_Nucleus_accumbens_basal_ganglia Brain_Anterior_cingulate_cortex_BA24 Brain_Spinal_cord_cervical_c-1 Muscle_Skeletal Brain_Putamen_basal_ganglia Brain_Hypothalamus Whole_Blood Stomach Lung Colon_Transverse Cells_EBV-transformed_lymphocytes)
tissue=${tissues[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $tissue

date

sbatch fusion.sh $tissue

date
