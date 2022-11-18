GWAS procedure on Brain Age Gap

1. Derive covariates and save as a txt file:
- /data/brutus_data24/zhenyao.ye/PropensityScore/reBAG/GWAS/cov_TestsetBAG_chr1.txt
- PCA:
```bash
# Example of chr21
cd /data/brutus_data24/yezhipan/GWAS_BAG/PCA 
mkdir chr1 
cd chr1 
nohup /data/mprc_data2/BrightData/chen.mo/software/plink2 --bfile /data/mprc_data2/BrightData/chen.mo/ukb_gwas/after_filtration/maf0.01/chr1/filter_white_chr1 --chr 1 --pca 10 approx allele-wts --keep /data/brutus_data24/yezhipan/GWAS_BAG/BAGeid.txt --out /data/brutus_data24/yezhipan/GWAS_BAG/PCA/chr1/PCA_TestsetBAG_chr1  & 
```
   - UKBB phenotype data saved in :
     - /data/mprc_data2/BrightData/zhenyao.ye/ukb_phenotype
     - /data/mprc_data3/zhenyao.ye/UKBBshowcases/ukb41153
   - Common phenotype field number: 
     - age 21022
     - BMI 21001
     - sex 31
     - genotype chip, UKBBvsUKBL 22000
```r
# derive UKBBvsUKBL
datafield22000$UKBBvsUKBL <- NA
for (i in 1:nrow(datafield22000)){
if (datafield22000$X22000.0.0[i] %in% c(-1:-11)){
    datafield22000$UKBBvsUKBL[i]<- 1 #UKBL
}else{
    datafield22000$UKBBvsUKBL[i]<- 0 #UKBB
}
}

# combine baseline covars
cov <- merge(merge(merge(datafield21022,datafield31,by="eid"),
                   datafield21001[,c(1:2)],by="eid"),
             datafield22000[,c(1,3)],by="eid")
cov <- cbind.data.frame(cov[,1],cov)
colnames(cov) <- c("FID","IID","Age","Sex","BMI","UKBBvsUKBL")
saveRDS(cov,file="G:/PropensityScore/Paper/Step2/Python/Forsex/GWAScov.Rds")
write.table(cov,file="G:/PropensityScore/Paper/Step2/Python/Forsex/GWAScov.txt",quote = F,col.names = T,row.names = F)

cov_rmna <- cov[complete.cases(cov),]
saveRDS(cov_rmna,file="G:/PropensityScore/Paper/Step2/Python/Forsex/GWAScov_rmna.Rds")
write.table(cov_rmna,file="G:/PropensityScore/Paper/Step2/Python/Forsex/GWAScov_rmna.txt",quote = F,col.names = T,row.names = F)

#append PCs to covars
setwd("/data/brutus_data24/zhenyao.ye/PropensityScore/reBAG/")
cov_rmna <- read.csv("/data/brutus_data24/zhenyao.ye/PropensityScore/reBAG/GWAScov_rmna.txt", sep="", stringsAsFactors=FALSE)
chr <- c(1:22) #c(1:3) #c(4:8,10:12)#c(9,13:22)
for (i in 1:length(chr)){
  PCA <-  read.delim(paste0("PCA/chr",chr[i],"/PCA_TestsetBAG_chr",chr[i],".eigenvec"), header=FALSE, comment.char="#", stringsAsFactors=FALSE)
  colnames(PCA) <- c("FID","IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10")
  PCA_v2 <- merge(cov_rmna,PCA,by=c("FID","IID"))
  write.table(PCA_v2,file=paste0("GWAS/cov_TestsetBAG_chr",chr[i],".txt"),quote = F,col.names = T,row.names = F)
}
```



2. Derive outcomes and save it as a TXT file: Brain Age Gap
   - /data/brutus_data24/yezhipan/GWAS_BAG/BAG.txt

3. GWAS in PLINK
```bash
cd /data/brutus_data24/yezhipan/GWAS_BAG/GWAS 
mkdir chr21 
cd chr21 
nohup /data/mprc_data1/home/yezhenya/MPRC.lib/tools/plink_linux_x86_64_20200121/plink --bfile /data/mprc_data2/BrightData/chen.mo/ukb_gwas/after_filtration/maf0.01/chr21/filter_white_chr21 --keep /data/brutus_data24/yezhipan/GWAS_BAG/BAGeid.txt --pheno /data/brutus_data24/yezhipan/GWAS_BAG/BAG.txt --all-pheno --covar /data/brutus_data24/zhenyao.ye/PropensityScore/reBAG/GWAS/cov_TestsetBAG_chr21.txt --linear --out /data/brutus_data24/yezhipan/GWAS_BAG/GWAS/chr21/GWAS_TestsetBAG_chr21  & 
```