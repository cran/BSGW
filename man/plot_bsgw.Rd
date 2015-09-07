\name{plot.bsgw}
\alias{plot.bsgw}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plot diagnostics for a bsgw object
}
\description{
Four sets of MCMC diagnostic plots are currently generated: 1) log-likelihood and log-posterior (including shrinkage effect) as a function of iteration number, 2) coefficient trace plots, 3) coefficient autocorrelation plots, 4) coefficient histograms.
}
\usage{
\method{plot}{bsgw}(x, pval=0.05, burnin=round(x$control$iter/2), nrow=2, ncol=3, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A \code{bsgw} object, typically the output of \link{bsgw} function.}
  \item{pval}{The P-value at which lower/upper bounds on coefficients are calculated and overlaid on trace plots and historgrams.}
  \item{burnin}{Number of samples discarded from the beginning of an MCMC chain, after which parameter quantiles are calculated.}
  \item{nrow}{Number of rows of subplots within each figure, applied to plot sets 2-4.}
  \item{ncol}{Number of columns of subplots within each figure, applied to plot sets 2-4.}
  \item{...}{Further arguments to be passed to/from other methods.}
}

\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\examples{
data(lung)
est <- bsgw(Surv(futime, fustat) ~ ecog.ps + rx, ovarian
            , control=bsgw.control(iter=800, nskip=100))
plot(est)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

