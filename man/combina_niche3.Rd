% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/combina_niche3.R
\name{combina_niche3}
\alias{combina_niche3}
\title{Estimate the degree of niche overlapping among species from their chromatograms.}
\usage{
combina_niche3(sp_chr, Thres_T)
}
\arguments{
\item{sp_chr}{a matrix with the species chromatograms (alpha categories by p-environmental variables by species). Outputs of 'chromato_env16.R'}

\item{Thres_T}{an integer corresponding to the threshold of minimal abundance in a category for niche breadth estimation}
}
\value{
Return a list composed of three matrices:

combi_dim, which contains the mean degree of niche overlapping. In combi_dim, the first column displays the number of dimensions
considered simultaneously and the last column displays the index D associated with the combination of dimensions.
Columns between the first and the last display the combinations of dimensions considered.

sp_by_sp, a matrix with the degree of niche overlapping (index D) species by species when all the dimensions are considered.

dim_alone, a vector with the mean degree of niche overlapping (index D) when each dimension is considered alone.

D=0 when species niches are fully different and D=100 when species niches are identical;
the higher the number of dimensions, the lower the value of index D.
}
\description{
Function that returns the lowest degree of niche overlapping (index D) among all the species when 1 to p environmental variables
are considered. Also return the degree of niche overlapping (index D) among each couple of species when all the environmental
variables are considered simultaneously and the lowest degree of niche overlapping (index D) when each environmental variable is considered alone.
}
\examples{
# Load the example datasets
data("data_abundance")
data("environment")
# Characterise and display the ecological niche of 2 pseudo-species
# `alpha`=50 categories, `m`=1 sample, `k`=5 and `order_smth`=2
sp_chrom_PS3<-chromato_env16(environment,data_abundance[,3],50,1,5,2)
sp_chrom_PS8<-chromato_env16(environment,data_abundance[,8],50,1,5,2)
# Combine the species chromatograms along a third dimension with `abind`
library(abind)
test_PS<-abind::abind(sp_chrom_PS3,sp_chrom_PS8,along=3)
# Apply the function `combina_niche3.R` on the matrix `test_PS` with `Thres_T`=0
Index_D_PS<-combina_niche3(test_PS,0)
}
