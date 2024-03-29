import numpy as np
import pandas as pd
import os
import argparse

def make_rsid_dict(file,chrom_dict):
    
    chunksize = 10 ** 7
    compiled_rsid=pd.DataFrame()
    for i,chunk in enumerate(pd.read_csv(file, chunksize=chunksize,comment="#",delimiter="\t",header=None)):
        print(i)
        chunk["chrom"]=chunk[0].map(chrom_dict)
        chunk["chrom"]=chunk["chrom"].str.replace("hs","")
        chunk["ID"]="chr"+chunk["chrom"]+":"+chunk[1].astype(str)
        compiled_rsid=compiled_rsid.append(chunk)
    mp_rsid=dict(zip(compiled_rsid["ID"],compiled_rsid[2]))
    return(mp_rsid)

def map_summary(file, mp_rsid):
    
    chunksize = 10 ** 7
    compiled_summary=pd.DataFrame()
    
    for i,chunk in enumerate(pd.read_csv(file, chunksize=chunksize,delimiter="\t")):
        #map to rsid
        print(i)
        chunk["snp_noallele"]=chunk["ID"].str.rsplit(":",2).str[0]
        chunk["rsid"]=chunk["snp_noallele"].map(mp_rsid)
        chunk=chunk[~chunk["rsid"].isnull()]
        
        #flip allele
        if args.logistic:
            chunk["OR"]=pd.to_numeric(chunk["OR"],errors="coerce")
            chunk["BETA"]=np.log10(chunk["OR"])
            chunk["BETA"]=np.where(chunk["ALT"]!=chunk["A1"],chunk["BETA"]*-1,chunk["BETA"])
            chunk['OR'] = chunk['BETA'].apply(lambda x: 10**x)
            del chunk["BETA"]
            
        else:
            chunk["BETA"]=np.where(chunk["ALT"]!=chunk["A1"],chunk["BETA"]*-1,chunk["BETA"])
            
        del chunk["A1"]
        compiled_summary=compiled_summary.append(chunk)
        
    compiled_summary["ID"]=compiled_summary["rsid"]
    del compiled_summary["rsid"]
    del compiled_summary["snp_noallele"]
    return(compiled_summary)

def main(args):    
    
    #get chromosome mapping
    chrom=pd.read_csv("/cellar/users/mpagadal/data/dbsnp/grch38.chrom.mapping.txt",header=None)
    chrom=chrom[chrom[0].str.contains("NC")]
    chrom["chrom"]="hs"+chrom[0].str.split("_").str[1].str.split(".").str[0].astype(int).astype(str)
    chrom["chrom"]=chrom["chrom"].str.replace("23","X")
    chrom["chrom"]=chrom["chrom"].str.replace("24","Y")
    mp_chrom=dict(zip(chrom[0],chrom["chrom"]))

    mp_rsid=make_rsid_dict(args.rsid, mp_chrom)
    stats=map_summary(args.stats,mp_rsid)
    stats.to_csv(args.out,index=None,sep="\t")
    
    if args.ldsc_snps:
        snps=pd.read_csv("/cellar/users/mpagadal/data/ldsc/w_hm3.snplist",delimiter="\t")
        stats[stats["ID"].isin(snps["SNP"].tolist())].to_csv(args.out+".w_hm3",index=None,sep="\t")
        
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--rsid', type=str, help='rsid file')
    parser.add_argument('--stats', type=str, help='sumstats file')
    parser.add_argument('--out', type=str, help='output file')
    parser.add_argument('--ldsc_snps', action='store_true')
    parser.add_argument('--logistic', action='store_true')
    args = parser.parse_args()
    main(args)