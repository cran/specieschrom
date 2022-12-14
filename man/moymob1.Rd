% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/moymob1.R
\name{moymob1}
\alias{moymob1}
\title{m order simple moving average.}
\usage{
moymob1(x, m)
}
\arguments{
\item{x}{a matrix with in line the observations and in column the variables}

\item{m}{an integer corresponding to the window size (2m+1)}
}
\value{
smoothed matrix
}
\description{
Apply a m order simple moving average on each column of a matrix.
}
