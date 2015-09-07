\name{summary.bsgw}
\alias{summary.bsgw}
\alias{print.summary.bsgw}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Summarizing Bayesian Survival Generalized Weibull (BSGW) model fits
}
\description{
\code{summary} method for class "bsgw".
}
\usage{
\method{summary}{bsgw}(object, pval = 0.05, burnin = object$control$burnin, ...)
\method{print}{summary.bsgw}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{An object of class "bsgw", usually the result of a call to \link{bsgw}.}
  \item{x}{An object of class "summary.bsgw", usually the result of a call to \code{summary.bsgw}.}
  \item{pval}{Desired p-value, based on which lower/upper bounds will be calculated. Default is 0.05.}
  \item{burnin}{Number of samples to discard from the beginning of each MCMC chain before calculating median and lower/upper bounds.}
  \item{...}{Further arguments to be passed to/from other methods.}
}
\value{
The function \code{summary.bsgw} calculates median as well as lower/upper bounds for all model coefficients, given the supplied p-value. It also calculates the p-value for coefficients being significant smaller/larger than zero. It contains returns an object of class "summary.bsgw" with the following elements:
  \item{call}{The matched call.}
  \item{pval}{Same as input.}
  \item{burnin}{Same as input.}
  \item{coefficients}{A \emph{p x 4} matrix with columns for the estimated coefficient median, its lower and upper bounds given the user-supplied p-value, and the p-value for being smaller/larger than zero.}
  \item{survreg.scale}{List of \code{lower}, \code{median}, and \code{upper} values of the survreg-style scale parameter (i.e. inverse of shape parameter in \code{rweibull}) for the training-set population.}
}

\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\seealso{
See \link{summary} for a description of the generic method. 

The model fitting function is \link{bsgw}.
}
\examples{
est <- bsgw(Surv(futime, fustat) ~ ecog.ps + rx, ovarian
            , control=bsgw.control(iter=800, nskip=100))
summary(est, pval=0.1)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

