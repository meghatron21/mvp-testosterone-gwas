import pandas as pd
import os
import os.path
import numpy as np
import sys
import argparse


def make_coloc_input(gtex_df,mvp_df,out):
    
    mvp=pd.read_csv(mvp_df,delimiter="\t")
    if args.type == "logistic":
        mvp["BETA"]=np.log(mvp["OR"].astype(float))
        mvp["SE"]=mvp["LOG(OR)_SE"]
    mvp=mvp[["ID","BETA","SE","P","OBS_CT"]]
    mvp["SNP"]=mvp["ID"].str.rsplit(":",2).str[0]
    mvp["SNP"]=mvp["SNP"].str.split("chr").str[1]
  
    gtex=pd.read_csv(gtex_df)
    
    for y in gtex["phenotype_id"].unique():
        print(y)
        #filter to gtex gene
        gtex_pheno=gtex[gtex["phenotype_id"]==y]
        gtex_pheno["variant"]=gtex_pheno["variant_id"].str.replace("_b38","")
        gtex_pheno["variant"]=gtex_pheno["variant"].str.split("chr").str[1]
        gtex_pheno["variant"]=gtex_pheno["variant"].str.replace("_",":")
        gtex_pheno=gtex_pheno[["variant","slope","slope_se","maf","pval_nominal"]]
        gtex_pheno.columns=["ID","BETA","SE","maf","P"]
        
        gtex_num=pd.read_csv("/cellar/users/mpagadal/data/gtex/GTEx.tissue.sample.size.csv")
        mp_gtex_num=dict(zip(gtex_num["Tissue_format"],gtex_num["# RNASeq and Genotyped samples"]))
        gtex_pheno["cell"]=gtex_df.split("/")[-1].split(".")[0]
        gtex_pheno["OBS_CT"]=gtex_pheno["cell"].map(mp_gtex_num)
        
        gtex_pheno["SNP"]=gtex_pheno["ID"].str.rsplit(":",2).str[0]
        
        #merge mvp and gtex statistics
        df_all=pd.merge(gtex_pheno,mvp,on="SNP",suffixes=("_gtex","_mvp"))
        
        #remove null values
        df_all=df_all[~(df_all["BETA_gtex"].isnull())]
        df_all=df_all[~(df_all["BETA_mvp"].isnull())]
        print(df_all.shape)
        
        tissue=gtex_df.split("/")[-1]
        tissue=tissue.split(".snps.csv")[0]
        
        df_all.to_csv(out+"/"+tissue+"."+y.split(".")[0]+".csv",index=None)

    
def main(args):
    make_coloc_input(args.gtex,args.mvp,args.out)
    
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--gtex', type=str, help='GTEx files')
    parser.add_argument('--mvp', type=str, help='MVP file')
    parser.add_argument('--out', type=str, help='name of output file')
    parser.add_argument('--type', type=str, help='logistic or linear')
    args = parser.parse_args()
    main(args)  
