import numpy as np
import pandas as pd
import os
import argparse


def main(args):
    #make chromosome mapping
    chrom=pd.read_csv("/cellar/users/mpagadal/data/dbsnp/grch38.chrom.mapping.txt",header=None)
    chrom=chrom[chrom[0].str.contains("NC")]
    chrom["chrom"]="hs"+chrom[0].str.split("_").str[1].str.split(".").str[0].astype(int).astype(str)
    chrom["chrom"]=chrom["chrom"].str.replace("23","X")
    mp_chrom=dict(zip(chrom["chrom"],chrom[0]))

    #get circos data and map to positions
    df=pd.read_csv(args.circos,delimiter="\t",header=None)
    df["chrom"]=df[0].map(mp_chrom)
    df=df[~df["chrom"].isnull()]
    df[["chrom",1,2]].to_csv(args.out,header=None,index=None,sep="\t")  
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--circos', type=str, help='circos positions file')
    parser.add_argument('--out', type=str, help='output file')
    
    args = parser.parse_args()
    main(args)