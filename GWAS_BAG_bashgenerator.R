# Generate shell commands for PCA and GWAS for PLINK

#########################
# Replace the file/folder paths with your own and you are good to go!
PCA_directory <- "/data/brutus_data24/yezhipan/GWAS_BAG/PCA"
GWAS_directory <- "/data/brutus_data24/yezhipan/GWAS_BAG/GWAS"
EID_file <- "/data/brutus_data24/yezhipan/GWAS_BAG/BAGeid.txt"
outcome_file <- "/data/brutus_data24/yezhipan/GWAS_BAG/BAG.txt"
covar_directory <- "/data/brutus_data24/zhenyao.ye/PropensityScore/reBAG/GWAS"
#########################

###Generate PCA bash code
code=c()
for (i in 1:22) {
  temp <- paste("cd ", PCA_directory, " \n",
                "mkdir chr", i, " \n",
                "cd chr", i, " \n",
                "nohup ",
                "/data/mprc_data2/BrightData/chen.mo/software/plink2 ",
                "--bfile /data/mprc_data2/BrightData/chen.mo/ukb_gwas/after_filtration/maf0.01/chr",i,"/filter_white_chr",i,
                " --chr ",i,
                " --pca 10 approx allele-wts ",
                "--keep ", EID_file,
                " --out ", PCA_directory, "/chr",i,"/PCA_TestsetBAG_chr",i," ",
                " & ",
                sep = "")
  code=append(code, temp)
}
write.table(code, 
            file = "PCAcode.txt", 
            row.names = F, col.names = F, quote = F)


###Generate GWAS bash code
code=c()
for (i in 1:22) {
  temp <-paste("cd ", GWAS_directory, " \n",
               "mkdir chr", i, " \n",
               "cd chr", i, " \n",
               "nohup ",
               "/data/mprc_data1/home/yezhenya/MPRC.lib/tools/plink_linux_x86_64_20200121/plink " ,
               "--bfile /data/mprc_data2/BrightData/chen.mo/ukb_gwas/after_filtration/maf0.01/chr",i,"/filter_white_chr",i,
               " --keep ", EID_file,
               " --pheno ", outcome_file,
               " --all-pheno --covar ", covar_directory, "/cov_TestsetBAG_chr",i,".txt",
               " --linear",
               " --out /data/brutus_data24/yezhipan/GWAS_BAG/GWAS/chr",i,"/GWAS_TestsetBAG_chr",i," ",
               " & ",
               sep = "")
  code=append(code, temp)
}
write.table(code, 
            file = "GWAScode1.txt", 
            row.names = F, col.names = F, quote = F)