import numpy as np
import pandas as pd
import os
import argparse


def main(args):    
    
    #load in stats file
    stats=pd.read_csv(args.stats,delimiter="\t")
    
    #load in liftover
    liftover_map=pd.read_csv(args.liftover,header=None,delimiter="\t")
    mp_liftover=dict(zip(liftover_map[3],liftover_map[1]))
    
    #map file
    stats["LIFTOVER_POS"]=stats["ID"].map(mp_liftover)
    stats=stats[~stats["LIFTOVER_POS"].isnull()]
    stats["POS"]=stats["LIFTOVER_POS"]
    del stats["LIFTOVER_POS"]
    stats["POS"]=stats["POS"].astype(int)
    stats.to_csv(args.out,index=None,sep="\t")
        
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--liftover', type=str, help='liftover file')
    parser.add_argument('--stats', type=str, help='sumstats file')
    parser.add_argument('--out', type=str, help='output file')
    args = parser.parse_args()
    main(args)