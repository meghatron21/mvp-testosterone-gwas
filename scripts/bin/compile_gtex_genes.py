import pandas as pd
import os
import os.path
from matplotlib import pyplot as plt
import numpy as np
import seaborn as sns
import sys
import argparse


def compile_gtex(mapping,prefix,direct,gene_df):
    #map to b37 coordinates
    mp=pd.read_csv(mapping,delimiter="\t")
    mp_b38_b37=dict(zip(mp.variant_id,mp.variant_id_b37))
    
    #create pandas dataframe to compile files
    chroms=[str(x) for x in range(1,23)]+["X"]
    files=[prefix+".v8.EUR.allpairs.chr"+x+".parquet" for x in chroms]
    files=[direct+"/"+x for x in files]
    
    #ensure that all chromosome files are found
    if len([path for path in files if os.path.exists(path)]) == 23:
        print("All file paths exist")
    else:
        print("Paths for the following files were not found!")
        found=[path for path in files if os.path.exists(path)]
        print([x for x in files if x not in found])
      
        sys.exit()
    
    #get genes
    genes=pd.read_csv(gene_df,header=None)[0].tolist()
    print("{} genes provided".format(len(genes)))
    
    #get dataframe
    compiled_cis=pd.DataFrame()
    for i,x in enumerate(files):
        print("{} gtex files compiled".format(i))
        eqtl=pd.read_parquet(x,engine="pyarrow")
        eqtl["variant_b37"] = eqtl["variant_id"].map(mp_b38_b37)
        eqtl["variant"] = eqtl["variant_b37"].str.split("_").str[0]+":"+eqtl["variant_b37"].str.split("_").str[1]+":"+eqtl["variant_b37"].str.split("_").str[2]+":"+eqtl["variant_b37"].str.split("_").str[3]
        
        #filter for files with genes
       
        eqtl_filt=eqtl[eqtl["phenotype_id"].isin(genes)]
        print("{} genes found in gtex file - {}".format(len(eqtl_filt["phenotype_id"].unique()),x))
        compiled_cis=compiled_cis.append(eqtl_filt)
    
    return(compiled_cis)


def main(args):
    df=compile_gtex(args.mapping,args.cell,args.direct,args.genes)
    df.to_csv(args.out)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--mapping', type=str, help='GTEx variant mapping file')
    parser.add_argument('--direct', type=str, help='folder with GTEx eQTLs')
    parser.add_argument('--cell', type=str, help='GTEx cell type')
    parser.add_argument('--genes', type=str, help='extract genes text file')
    parser.add_argument('--out', type=str, help='name of output file')
    args = parser.parse_args()
    main(args)  