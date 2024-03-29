#!/usr/bin/env Rscript

args<-commandArgs(TRUE)

genes=read.csv(args[1],header=TRUE,sep="\t")

print(length(genes))
columns<-colnames(genes)[3:length(genes)]

for (x in columns){
    z<-qnorm((rank(genes[[x]],na.last="keep")-0.5)/sum(!is.na(genes[[x]])))
    genes[[x]] <- z
}

write.table(genes, file=args[2],sep="\t",row.names=FALSE,quote=FALSE)
