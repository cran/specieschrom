#' Optimums and amplitudes estimations along each niche dimension.
#'
#' @description Function that estimates niche optimums and amplitudes along each environmental variable and for each species.
#'
#' @param sp_chr a matrix with the species chromatograms (categories by environmental variables by species). Outputs of 'chromato_env16.R'
#' @param Thres_T an integer corresponding to the min abundance threshold for niche amplitudes estimations
#' @param z a matrix with n samples by p environmental variables (i.e. the value of each environmental variable in each sample). Same matrix as in 'chromato_env16.R'.
#' @param y a matrix with the species abundance in the n samples
#' @param k an integer corresponding to the percentage of samples with the highest abundance values to use to estimate the mean abundance in a given category. Should have the same value as in 'chromato_env16.R'
#'
#' @return Three matrices are returned:
#' @return amplitudes, a matrix with the degree of euryoecie (niche breadth) of each species (in column) along each environmental dimension (in line)
#' @return mean_amplitudes, a matrix with the mean degree of euryoecie of each species
#' @return optimums, a matrix with the niche optimum values of each species (in column) along each environmental dimension (in line)
#' @export
#'
#' @examples
#' # Load the example datasets
#' data("data_abundance")
#' data("environment")
#' # Characterise and display the ecological niche of 2 pseudo-species
#' # `alpha`=50 categories, `m`=1 sample, `k`=5 and `order_smth`=2
#' sp_chrom_PS3<-chromato_env16(environment,data_abundance[,3],50,1,5,2)
#' sp_chrom_PS8<-chromato_env16(environment,data_abundance[,8],50,1,5,2)
#' # Combine the species chromatograms along a third dimension with `abind`
#' library(abind)
#' test_PS<-abind::abind(sp_chrom_PS3,sp_chrom_PS8,along=3)
#' # `opti_eury_niche2.R` can then be applied, with `Thres_T`=0 and `k`=5
#' opti_ampli_niche<-opti_eury_niche2(test_PS,0,environment,data_abundance[,c(3,8)],5)

opti_eury_niche2<-function(sp_chr,Thres_T,z,y,k){
  n<-dim(sp_chr)
  deg_eury=matrix(nrow = n[2],ncol = n[3])
  opti_val=matrix(nrow = n[2],ncol = n[3])

  # estimation of niche breadth
  for (j in 1:n[3]) {
    for (i in 1:n[2]) {
      temp<-sp_chr[,i,j]

      if (Thres_T==0) {
        f1<-which(temp>Thres_T)
      }else{
        f1<-which(temp>=Thres_T)
      }

      temp[f1[1]:f1[length(f1)]]<-1
      f2<-which(!is.na(temp))

      if (Thres_T==0) {
        f3<-which(temp>Thres_T)
      }else{
        f3<-which(temp>=Thres_T)
      }

      deg_eury[i,j]<-(length(f3)*100)/length(f2)
      rm(temp,f1,f2,f3)
    }
  }

  mean_deg_eury<-colMeans(deg_eury)

  #estimation of niche optimums
  catego<-seq(0, 1, by = (1/n[1]))
  z1<-catego[1:length(catego)-1]
  z2<-catego[2:length(catego)]

  n2<-dim(z)
  env_st<-matrix(nrow = n2[1],ncol = n2[2])

  for (i in 1:n[2]){
    env_st[,i]<-(z[,i]-min(z[,i],na.rm = TRUE))/(max(z[,i],na.rm = TRUE)-min(z[,i],na.rm = TRUE))
  }

  for (j in 1:n[3]) {
    for (i in 1:n[2]) {
      temp<-sp_chr[,i,j]
      f1<-which(temp==max(temp,na.rm = TRUE))
      f2<-which(env_st[,i]>=z1[f1[1]] & env_st[,i]<z2[f1[length(f1)]])
      temp_abund<-y[f2,j]
      temp_env<-z[f2,i]
      p1<-ceiling((k*length(temp_abund))/100)
      ind<-order(temp_abund,decreasing = TRUE)
      opti_val[i,j]<-mean(temp_env[ind[1:p1]],na.rm = TRUE)
      rm(temp,temp_abund,temp_env,p1,ind,f1,f2)
    }
  }

  opti_ampli_niche<-list(opti_val,deg_eury,mean_deg_eury)
  names(opti_ampli_niche)<-c('optimums','amplitudes','mean_amplitudes')
  return(opti_ampli_niche)
}
