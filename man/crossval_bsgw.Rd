\name{bsgw.crossval}
\alias{bsgw.crossval}
\alias{bsgw.crossval.wrapper}
\alias{bsgw.generate.folds}
\alias{bsgw.generate.folds.eventbalanced}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Convenience functions for cross-validation-based selection of shrinkage parameter in the bsgw model.
}
\description{
\code{bsgw.crossval} calculates cross-validation-based, out-of-sample log-likelihood of a bsgw model for a data set, given the supplied folds. \code{bsgw.crossval.wrapper} applies \code{bsgw.crossval} to a set of combinations of shrinkage parameters (\code{lambda},\code{lambdas}) and produces the resulting vector of log-likelihood values as well as the specific combination of shrinkage parameters associated with the maximum log-likelihood. \code{bsgw.generate.folds} generates random partitions, while \code{bsgw.generate.folds.eventbalanced} generates random partitions with events evenly distributed across partitions. The latter feature is useful for cross-valiation of small data sets with low event rates, since it prevents over-accumulation of events in one or two partitions, and lack of events altogether in other partitions.
}
\usage{
bsgw.generate.folds(ntot, nfold=5)
bsgw.generate.folds.eventbalanced(formula, data, nfold=5)
bsgw.crossval(data, folds, all=FALSE, print.level=1, control=bsgw.control(), ...)
bsgw.crossval.wrapper(data, folds, all=FALSE, print.level=1, control=bsgw.control()
  , lambda.vec=exp(seq(from=log(0.01), to=log(100), length.out = 10)), lambdas.vec=NULL
  , lambda2=if (is.null(lambdas.vec)) cbind(lambda=lambda.vec, lambdas=lambda.vec)
      else as.matrix(expand.grid(lambda=lambda.vec, lambdas=lambdas.vec))
  , plot=TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ntot}{Number of observations to create partitions for. It must typically be set to \code{nrow(data)}.}
  \item{nfold}{Number of folds or partitions to generate.}
  \item{formula}{Survival formula, used to extract the binary \code{status} field from the data. Right-hand side of the formula is ignored, so a formula of the form \code{Surv(time,status)~1} is sufficient.}
  \item{data}{Data frame used in model training and prediction.}
  \item{folds}{An integer vector of length \code{nrow(data)}, defining fold/partition membership of each observation. For example, in 5-fold cross-validation for a data set of 200 observations, \code{folds} must be a 200-long vector with elements from the set \code{{1,2,3,4,5}}. Convenience functions \code{bsgw.generate.folds} and \code{bsgw.generate.folds.eventbalanced} can be used to generate the \code{folds} vector for a given survival data frame.}
  \item{all}{If \code{TRUE}, estimation objects from each cross-validation task is collected and returned for diagnostics purposes.}
  \item{print.level}{Verbosity of progress report.}
  \item{control}{List of control parameters, usually the output of \link{bsgw.control}.}
  \item{lambda.vec}{Vector of shrinkage parameters to be tested for scale-parameter coefficients.}
  \item{lambdas.vec}{Vector of shrinkage parameters to be tested for shape-parameter coefficients.}
  \item{lambda2}{A data frame that enumerates all combinations of \code{lambda} and \code{lambdas} to be tested. By default, it is constructed from forming all permutations of \code{lambda.vec} and \code{lambdas.vec}. If \code{lambdas.vec=NULL}, it will only try equal values of the two parameters in each combination.}
  \item{plot}{If \code{TRUE}, and if the \code{lambda} and \code{lambdas} entries in \code{lambda2} are identical, a plot of \code{loglike} as a function of either vector is produced.}
  \item{...}{Other arguments to be passed to \link{bsgw}.}
}

\value{
Functions \code{bsgw.generate.folds} and \code{bsgw.generate.folds.eventbalanced} produce integer vectors of length \code{ntot} or \code{nrow(data)} respectively. The output of these functions can be directly passed to \code{bsgw.crossval} or \code{bsgw.crossval.wrapper}. Function \code{bsgw.crossval} returns the log-likelihood of data under the assumed bsgw model, calculated using a cross-validation scheme with the supplied \code{fold} parameter. If \code{all=TRUE}, the estimation objects for each of the \code{nfold} estimation jobs will be returned as the "estobjs" attribute of the returned value. Function \code{bsgw.crossval.wrapper} returns a list with elements \code{lambda} and \code{lambdas}, the optimal shrinkage parameters for scale and shape coefficients, respectively. Additionally, the following attributes are attached:
\item{loglike.vec}{Vector of log-likelihood values, one for each tested combination of \code{lambda} and \code{lambdas}.}
\item{loglike.opt}{The maximum log-likelihood value from the \code{loglike.vec}.}
\item{lambda2}{Data frame with columns \code{lambda} and \code{lambdas}. Each row of this data frame contains one combination of shrinkage parameters that are tested in the wrapper function.}
\item{estobjs}{If \code{all=TRUE}, a list of length \code{nrow(lambda2)} is returned, with each element being itself a list of \code{nfold} estimation objects associated with each call to the \code{bsgw} function. This object can be examined by the user for diagnostic purposes, e.g. by applying plot against each object.}
}

\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\examples{
folds <- bsgw.generate.folds.eventbalanced(Surv(futime, fustat) ~ 1, ovarian, 5)
cv <- bsgw.crossval(ovarian, folds, formula=Surv(futime, fustat) ~ ecog.ps + rx
  , control=bsgw.control(iter=100, nskip=10), print.level = 3)
cv2 <- bsgw.crossval.wrapper(ovarian, folds, formula=Surv(futime, fustat) ~ ecog.ps + rx
  , control=bsgw.control(iter=100, nskip=10)
  , print.level=3, lambda.vec=exp(seq(from=log(0.1), to=log(1), length.out = 3)))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
