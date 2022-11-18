#How to Conduct Genome-Wide Association Studies using PLINK & UKBB


## Setup
  - Command line software, Plink: https://zzz.bwh.harvard.edu/plink/anal.shtml

## Procedure
_Ex. outcome - Brain Age Gap_
_Ex. chromosome - chr 1_
1. Derive covariates for each chromosome and save as a txt file:
   * UKBB phenotype data saved in :
        - /data/mprc_data2/BrightData/zhenyao.ye/ukb_phenotype
        - /data/mprc_data3/zhenyao.ye/UKBBshowcases/ukb41153
   * Common covariate field number: 
        - age 21022
        - BMI 21001
        - sex 31
        - genotype chip, UKBBvsUKBL 22000
          - how to derive UKBBvsUKBL:
              ```r
              datafield22000$UKBBvsUKBL <- NA
              for (i in 1:nrow(datafield22000)){
                datafield22000$UKBBvsUKBL <- ifelse(datafield22000$X22000.0.0 %in% c(-1:-11), 1, 0)
              }
              ```
   * If desired data not present in existing folders, download using ukbconv
      ```bash
      #cd to desired saving location
      cd /data/brutus_data24/yezhipan/UKBB_DATA
      #download <data field> and save as csv
      nohup /data/brutus_data16/UKBData/Comma_Key_Files/./ukbconv /data/mprc_data2/ukbb/ukb41153.enc_ukb csv -s<data field> -o<save name> &
      ```
   * Principle components are commonly included as covariates:
      ```bash
      #create a directory for each chr
      cd /data/brutus_data24/yezhipan/GWAS_BAG/PCA
      mkdir chr1 
      cd chr1 
      #compute PCs using PLINK functions
      nohup /data/mprc_data2/BrightData/chen.mo/software/plink2 --bfile /data/mprc_data2/BrightData/chen.mo/ukb_gwas/after_filtration/maf0.01/chr1/filter_white_chr1 --chr 1 --pca 10 approx allele-wts --keep /data/brutus_data24/yezhipan/GWAS_BAG/BAGeid.txt --out /data/brutus_data24/yezhipan/GWAS_BAG/PCA/chr1/PCA_TestsetBAG_chr1  & 
      ```
   * Append calculated PCs to the remaining covariates and save as a comprehensive covariate file for each chromosome



2. Derive outcomes and save it as a TXT file: Brain Age Gap
   - ex. location: /data/brutus_data24/yezhipan/GWAS_BAG/BAG.txt

3. GWAS in PLINK
```bash
cd /data/brutus_data24/yezhipan/GWAS_BAG/GWAS 
mkdir chr21 
cd chr21 
nohup /data/mprc_data1/home/yezhenya/MPRC.lib/tools/plink_linux_x86_64_20200121/plink --bfile /data/mprc_data2/BrightData/chen.mo/ukb_gwas/after_filtration/maf0.01/chr21/filter_white_chr21 --keep /data/brutus_data24/yezhipan/GWAS_BAG/BAGeid.txt --pheno /data/brutus_data24/yezhipan/GWAS_BAG/BAG.txt --all-pheno --covar /data/brutus_data24/zhenyao.ye/PropensityScore/reBAG/GWAS/cov_TestsetBAG_chr21.txt --linear --out /data/brutus_data24/yezhipan/GWAS_BAG/GWAS/chr21/GWAS_TestsetBAG_chr21  & 
```
_Documentation of various command utilities in PLINK can be found [here](https://zzz.bwh.harvard.edu/plink/reference.shtml#options)._

4. R code for auto generating bash scripts of PCA and GWAS for each chromosome