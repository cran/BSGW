\name{predict.bsgw}
\alias{predict.bsgw}
\alias{summary.predict.bsgw}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Predict method for bsgw model fits
}
\description{
Calculates log-likelihood and hazard/cumulative hazard/survival functions over a user-supplied vector time values, based on BSGW model object.
}
\usage{
\method{predict}{bsgw}(object, newdata=NULL, tvec=NULL, burnin=object$control$burnin, ncores=1, ...)
\method{summary}{predict.bsgw}(object, idx=1:length(object$median$survreg.scale), burnin=object$burnin, pval=0.05
  , popmean=identical(idx,1:length(object$median$survreg.scale)), make.plot=TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{For \code{predict.bsgw}, an object of class "bsgw", usually the result of a call to \link{bsgw}; for \code{summary.predict.bsgw}, an object of class "predict.bsgw", usually the result of a call to \code{predict.bsgw}.}
  \item{newdata}{An optional data frame in which to look for variables with which to predict. If omiited, the fitted values (training set) are used.}
  \item{tvec}{An optional vector of time values, along which time-dependent entities (hazard, cumulative hazard, survival) will be predicted. If omitted, only the time-independent entities (currently only log-likelihood) will be calculated. If a single integer is provided for \code{tvec}, it is interpreted as number of time points, equally spaced from \code{0} to \code{object$tmax: tvec <- seq(from=0.0, to=object$tmax, length.out=tvec)}.}
  \item{burnin}{Number of samples to discard from the beginning of each MCMC chain before calculating median value(s) for time-independent entities.}
  \item{ncores}{Number of cores to use for parallel prediction.}
  \item{...}{Further arguments to be passed to/from other methods.}
  \item{idx}{Index of observations (rows of \code{newdata} or training data) for which to generate summary statistics. Default is the entire data.}
  \item{pval}{Desired p-value, based on which lower/upper bounds will be calculated. Default is \code{0.05}.}
  \item{popmean}{Whether population averages must be calculated or not. By default, population averages are only calculated when the entire data is included in prediction.}
  \item{make.plot}{Whether population mean and other plots must be created or not.}
}
\details{
The time-dependent predicted objects (except \code{loglike}) are three-dimensional arrays of size (\code{nsmp x nt x nobs}), where \code{nsmp} = number of MCMC samples, \code{nt} = number of time values in \code{tvec}, and \code{nobs} = number of rows in \code{newdata}. Therefore, even for modest data sizes, these objects can occupy large chunks of memory. For example, for \code{nsmp=1000, nt=100, nobs=1000}, the three objects \code{h, H, S} have a total size of 2.2GB. Since applying \code{quantile} to these arrays is time-consuming (as needed for calculation of median and lower/upper bounds), we have left such summaries out of the scope of \code{predict} function. Users can instead apply \code{summary} to the prediction object to obtain summary statistics. During cross-validation-based selection of shrinkage parameter \code{lambda}, there is no need to supply \code{tvec} since we only the log-likelihood value. This significantly speeds up the parameter-tuning process. The function \code{summary.predict.bsgw} allows the user to calculates summary statistics for a subset (or all of) data, if desired. This approach is in line with the overall philosophy of delaying the data summarization until necessary, to avoid unnecessary loss in accuracy due to premature blending of information contained in individual samples.
}
\value{
The function \code{predict.bsgw} returns as object of class "predict.bsgw" with the following fields:
  \item{tvec}{Actual vector of time values (if any) used for prediction.}
  \item{burnin}{Same as input.}
  \item{median}{List of median values for predicted entities. Currently, only \code{loglike} and \code{survreg.scale} median is produced. See 'Details' for explanation.}
  \item{smp}{List of MCMC samples for predicted entities. Elements include \code{h} (hazard function), \code{H} (cumulative hazard function), \code{S} (survival function), \code{survreg.scale} (inverse of shape parameter in \code{rweibull}), and \code{loglike} (model log-likelihood). All functions are evaluated over time values specified in \code{tvec}.}
  \item{km.fit}{Kaplan-Meyer fit of the data used for prediction (if data contains response fields).}
The function \code{summary.predict.bsgw} returns a list with the following fields:
  \item{lower}{A list of lower-bound values for \code{h}, \code{H}, \code{S}, \code{hr} (hazard ratio of \code{idx[2]} to \code{idx[1]} observation), and \code{S.diff} (survival probability of \code{idx[2]} minus \code{idx[1]}). The last two are only included if \code{length(idx)==2}.}
  \item{median}{List of median values for same entities described in \code{lower}.}
  \item{upper}{List of upper-bound values for same entities described in \code{lower}.}
  \item{popmean}{Lower-bound/median/upper-bound values for population average of survival probability.}
  \item{km.fit}{Kaplan-Meyer fit associated with the prediction object (if available).}
}

\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\examples{
est <- bsgw(Surv(futime, fustat) ~ ecog.ps + rx, ovarian
            , control=bsgw.control(iter=800, nskip=100))
pred <- predict(est, tvec=100)
predsumm <- summary(pred, idx=1:10)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

