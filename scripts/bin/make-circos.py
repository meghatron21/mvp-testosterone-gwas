import numpy as np
import pandas as pd
import os
import argparse


def make_circos(df):
    df["chr"]="hs"+df["#CHROM"].astype(str)
    df["bp1"]=df["POS"]
    df["bp2"]=df["POS"]+1
    df["P_pseudo"]=df["P"]+.00000000000000000001
    df["p"]=-np.log10(df["P_pseudo"])
    df=df[~df["p"].isnull()]
    return(df[["chr","bp1","bp2","p"]])

def main(args): 
    
    #read in summary statistics file
    compiled_stat=pd.DataFrame()
    chunksize = 10 ** 7
    with pd.read_csv(args.sumstats, chunksize=chunksize,delim_whitespace=True) as reader:
        for chunk in reader:
            compiled_stat=compiled_stat.append(chunk)
    
    #make circos input
    circos=make_circos(compiled_stat)
    print(circos.shape)
    print(circos.shape)
    if args.filter:
        circos=circos[circos["p"]>=args.filter]
        
    circos.to_csv(args.out,index=None,header=None,sep="\t")
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--sumstats', type=str, help='sumstats file')
    parser.add_argument('--out', type=str, help='output for circos files')
    parser.add_argument('--filter', type=int, help='p-value cutoff to make circos input smaller')
    args = parser.parse_args()
    main(args)
