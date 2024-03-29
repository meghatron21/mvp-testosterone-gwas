library(tidyverse)
library(coloc)

args=commandArgs(TRUE)

for (y in list.files(path=args[1],pattern=args[2]))tryCatch({
    
    print(y)
    df=read.table(paste(args[1],y,sep=""),header=TRUE,sep=",")
    print(dim(df))
    
    tissue=unlist(strsplit(y, "\\."))[[1]]
    gene=unlist(strsplit(y, "\\."))[[2]]
    
    #run coloc with beta values
    my.res <- coloc.abf(dataset1=list(beta=df$BETA_mvp, varbeta=df$SE_mvp, N=df[1,"OBS_CT_mvp"],type="quant"), dataset2=list(beta=df$BETA_gtex, varbeta=df$SE_gtex, N=df[1,"OBS_CT_gtex"],type="quant"),MAF=df$maf)
    write.csv(my.res$summary,file=paste(args[3],tissue,".",gene,".beta.summary.csv",sep=""))
    write.csv(my.res$results,file=paste(args[3],tissue,".",gene,".beta.results.csv",sep=""))
    
    #run coloc with p-values
    my.res <- coloc.abf(dataset1=list(pvalues=df$P_mvp, N=df[1,"OBS_CT_mvp"],type="quant"), dataset2=list(pvalues=df$P_gtex, N=df[1,"OBS_CT_gtex"],type="quant"), MAF=df$maf)
    write.csv(my.res$summary,file=paste(args[3],tissue,".",gene,".p.summary.csv",sep=""))
    write.csv(my.res$results,file=paste(args[3],tissue,".",gene,".p.results.csv",sep=""))

},error=function(e){})