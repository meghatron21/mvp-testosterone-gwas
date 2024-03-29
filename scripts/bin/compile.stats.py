import numpy as np
import pandas as pd
import os
import argparse


def compile_statistics(direct):
    
    #make empty dataframes
    compiled_df=pd.DataFrame()
    sig_compiled_df=pd.DataFrame()
    
    #collect files
    files=[x for x in os.listdir(direct)]
    print("compiling {} files".format(len(files)))
    filename=files[0].rsplit(".",2)[0]

    #iterate and append
    for x in range(0,len(files)):
        print(x)
        print(filename)
        df=pd.read_csv(direct+filename+"."+str(x)+".tsv",delimiter="\t")
        compiled_df=compiled_df.append(df)
        sig_compiled_df=sig_compiled_df.append(df[df["P"]<.00000005])
    return(compiled_df,sig_compiled_df)

def main(args): 
    df_total,df_sig=compile_statistics(args.folder)
    df_total.to_csv(args.out,index=None,sep="\t")
    df_sig.to_csv(args.out+".sig",index=None,sep="\t")
    

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--folder', type=str, help='folder with all stats')
    parser.add_argument('--out', type=str, help='new covariate file')
    
    args = parser.parse_args()
    main(args)
