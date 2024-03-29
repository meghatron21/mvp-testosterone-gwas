import numpy as np
import pandas as pd
import os
import argparse

def filter_stats(stats,threshold):
    chunksize = 10 ** 7
    compiled_rsid=pd.DataFrame()   
    for i,chunk in enumerate(pd.read_csv(stats, chunksize=chunksize,delimiter="\t")):
        chunk=chunk[chunk["P"]<=threshold]
        compiled_rsid=compiled_rsid.append(chunk)
        chunk["#CHROM"]=chunk["#CHROM"].replace("X",23)
    return(compiled_rsid)

def main(args):    
    
    #get summary statistics
    sig_df=filter_stats(args.sumstats,.00000005)
    sug_df=filter_stats(args.sumstats,.00001)
    
    #iterate through bim files and get snp sets
    files=[x for x in os.listdir(args.genome) if "bim" in x]
    files=[x for x in files if "CM" in x]
    print(files)
    
    for x in files:
        print(x)
        #reformat bim
        df=pd.read_csv(args.genome+"/"+x,delimiter="\t",header=None)

        #make annot file
        df["base"]=1
        df["significant"]=np.where(df[1].isin(sig_df["ID"].tolist()),1,0)
        df["suggestive"]=np.where(df[1].isin(sug_df["ID"].tolist()),1,0)
    
        annot=df[[0,3,1,2,"base","suggestive","significant"]]
        annot.columns=["CHR","BP","SNP","CM","base","suggestive","significant"]
        print(annot["significant"].value_counts())
        print(annot["suggestive"].value_counts())
        print(args.genome+"/baseline."+str(x.split(".")[2])+".annot")
        annot.to_csv("baseline."+str(x.split(".")[2])+".annot",index=None,sep="\t")
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--sumstats', type=str, help='summary stats file')
    parser.add_argument('--genome', type=str, help='folder with genome')
    
    args = parser.parse_args()
    main(args)