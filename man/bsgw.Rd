\name{bsgw}
\alias{BSGW}
\alias{bsgw}
\alias{print.bsgw}
\alias{bsgw.control}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bayesian Survival using Generalized Weibull Regression
}
\description{
Bayesian survival model - with stratification and shrinkage - using Weibull regression on both scale and shape parameters, resulting in time-dependent (i.e. dynamic) hazard ratios.
}
\usage{
bsgw(formula, data, formulas=formula, weights, subset, na.action=na.fail, init="survreg"
  , ordweib=FALSE, scale=0, control=bsgw.control(), print.level=2)
bsgw.control(scalex=TRUE, iter=1000, burnin=round(iter/2), sd.thresh=1e-4
  , lambda=0.0, lambdas=lambda, nskip=round(iter/10), alpha.min=0.1, alpha.max=10.0
  , beta.max=log(20), betas.max=5.0, memlim.gb=8)
\method{print}{bsgw}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula}{Survival formula expressing the time/status variables as well as covariates used in regression on scale parameter. Currently, only right and left censoring is supported. Must include intercept term.}
  \item{data}{Data frame containing the covariates and response variable.}
  \item{formulas}{Formula expressing the covariates used in regression on shape parameter. No left-hand side is necessary since the response variable information is extracted from \code{formula}. Default value is \code{formula}. Must include intercept term.}
  \item{weights}{Optional vector of case weights. *Not supported yet*}
  \item{subset}{Subset of the observations to be used in the fit. *Not supported yet*}
  \item{na.action}{Missing-data filter function. *Not supported yet (only na.fail behavior works)*}
  \item{init}{Initialization behavior. Currently, three options are supported: 1) If \code{init="survreg"}, an ordinary Weibull regression is performed and coefficients are used to initialize the bsgw MCMC run. 2) If \code{init} is a \code{survreg} object, e.g. from a previous Weibull regression fit, the object can be directly passed as parameter. 3) If \code{init} is any other value, or if \code{survreg} produces error or warning, we simply set all coefficients to zero.}
  \item{ordweib}{If \code{TRUE}, a Bayesian ordinary Weibull model is estimated, in which any covariates in \code{formulas} are stripped away, and the inverse-logit transformation in the shape-parameter regression is replaced with a simple exponential transformation. If shrinkage parameters are kept at 0, the result is a Bayesian equivalent of an ordinary Weibull regression.}
  \item{scale}{If \code{scale>0}, the value of the shape parameter is fixed, i.e. not estimated from data.}
  \item{control}{See \code{bsgw.control} for a description of the parameters inside the \code{control} list.}
  \item{print.level}{Controlling verbosity level.}
  \item{scalex}{If \code{TRUE}, each covariate vector is centered and scaled before model estimation. The scaling parameters are saved in return object, and used in subsequent calls to \code{predict} function. Users are strongly advised against turning this feature off, since the quality of Gibbs sampling MCMC is greatly enhanced by covariate centering and scaling.}
  \item{iter}{Number of MCMC samples to draw.}
  \item{burnin}{Number of initial MCMC samples to discard before calculating summary statistics.}
  \item{sd.thresh}{Threshold for standard deviation of a covariate (after possible centering/scaling). If below the threshold, the corresponding coefficient is removed from sampling, i.e. its value is clamped to zero.}
  \item{lambda}{Bayesian Lasso shrinkage parameter for scale-parameter coefficients.}
  \item{lambdas}{Bayesian Lasso shrinkage parameter for shape-parameter coefficients.}
  \item{nskip}{Controlling how often to print progress report during MCMC run. For example, if \code{nskip=10}, progress will be reported after 10,20,30,... samples.}
  \item{alpha.min}{Lower bound on the shape parameter.}
  \item{alpha.max}{Upper bound on the shape parameter.}
  \item{beta.max}{Upper bound on absolute value of coefficients of scale parameter (with the exception of the intercept).}
  \item{betas.max}{Upper bound on absolute value of coefficients of shape parameter (with the exception of the intercept).}
  \item{memlim.gb}{User-specified limit on total memory (in GB) available during prediction. Hazard, cumulative hazard, and survival prediction objects are all three-dimensional arrays which can quickly grow very large, depending on data length, number of MCMC samples collected, and number of time points along which prediction is made.}
  \item{x}{Object of class 'bsgw', usually the result of a call to the \code{bsgw}.}
  \item{...}{Arguments to be passed to/from other methods.}
}

\value{
The function \code{bsgw.control} returns a list with elements identical to the input parameters. The function \code{bsgw} returns an object of class \code{bsgw}, with the following components:
\item{call}{The matched call.}
\item{formula}{Same as input.}
\item{formulas}{Same as input.}
\item{weights}{Same as input. *Not supported yet*}
\item{subset}{Same as input. *Not supported yet*}
\item{na.action}{Same as input. *Not supported yet* (current behavior is \code{na.fail})}
\item{init}{Initial values for scale and shape coefficients used in MCMC sampling, either by performing an ordinary Weibull regression or by extracting estimated coefficients from a previously-performed such regression.}
\item{ordweib}{Same as input.}
\item{survreg.scale.ref}{Value of scale parameter, estimated using ordinary Weibull regression by calling the \code{survreg} function in the \code{survival} package.}
\item{ordreg}{The \code{"survreg"} object returned from calling the same function for initialization of coefficients.}
\item{scale}{Same as input.}
\item{control}{Same as input.}
\item{X}{Model matrix used for regression on scale parameter, after potential centering and scaling. The corresponding vector of coefficients is called \code{beta}.}
\item{Xs}{Model matrix used for regression on shape parameter, after potential centering and scaling. The corresponding vector of coefficients is called \code{betas}.}
\item{y}{Survival response variable (time and status) used in the model.}
\item{contrasts}{The contrasts used for scale-parameter coefficients.}
\item{contrastss}{The contrasts used for shape-parameter coefficients.}
\item{xlevels}{A record of the levels of the factors used in fitting for scale parameter regression.}
\item{xlevelss}{A record of the levels of the factors used in fitting for shape parameter regression.}
\item{terms}{The terms object used for scale parameter regression.}
\item{termss}{The terms object used for shape parameter regression.}
\item{colnamesX}{Names of columns for \code{X}, also names of scale coefficients.}
\item{colnamesXs}{Names of columns for \code{Xs}, also names of shape coefficients.}
\item{apply.scale.X}{Index of columns of \code{X} where scaling has been applied.}
\item{apply.scale.Xs}{Index of columns of \code{Xs} where scaling has been applied.}
\item{centerVec.X}{Vector of centering parameters for columns of \code{X} indicated by \code{apply.scale.X}.}
\item{scaleVec.X}{Vector of scaling parameters for columns of \code{X} indicated by \code{apply.scale.X}.}
\item{centerVec.Xs}{Vector of centering parameters for columns of \code{Xs} indicated by \code{apply.scale.Xs}.}
\item{scaleVec.Xs}{Vector of scaling parameters for columns of \code{Xs} indicated by \code{apply.scale.Xs}.}
\item{idx}{Vector of indexes into \code{X} for which sampling occured. All columns of \code{X} whose standard deviation falls below \code{sd.thresh} are excluded from sampling and their corresponding coefficients are clamped to \code{0}.}
\item{idxs}{Vector of indexes into \code{Xs} for which sampling occured. All columns of \code{Xs} whose standard deviation falls below \code{sd.thresh} are excluded from sampling and their corresponding coefficients are clamped to \code{0}.}
\item{median}{List of median values, with elements including \code{beta} (coefficients of scale regression), \code{betas} (coefficients of shape regression), \code{survreg.scale} (value of \code{surgreg}-style scale parameter for all training set observations).}

\item{smp}{List of coefficient samples, with the following elements: 1) \code{beta} (scale parameter coefficients), 2) \code{betas} (shape parameter coefficients), 3) \code{lp} (vector of linear predictor for scale parameter, within-sample), 4) \code{loglike} (log-likelihood of model), 5) \code{logpost} (log-posterior of mode, i.e. log-likelihood plus the shrinkage term). The last two entities are used during within-sample prediction of response, i.e. during a subsequent call to \code{predict}. Each parameter has \code{control$iter} samples.}
\item{km.fit}{Kaplan-Meyer fit to training data. Used in \link{plot.bsgw} method.}
\item{tmax}{Maximum time value in training set. Used in \link{predict.bsgw} for automatic selection of the \code{tvec} parameter.}
}
\references{
Mazucheli J., Louzada-Neto F. and Achnar J.A. (2002). Lifetime models with nonconstant shape parameters. \emph{Confiabilidade. III Jornada Regional de Estatistica e II Semana da Estatistica, Maringa}.

Neal R.M. (2003). Slice Sampling. \emph{Annals of Statistics}, \bold{31}, 705-767.

Park T. and Casella G. (2008). The Bayesian Lasso. \emph{Journal of the American Statistical Association}, \bold{103}, 681-686.
}
\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\seealso{
For calculating median and lower/upper bounds on coefficients, use \link{summary.bsgw}.

For prediction, use \link{predict.bsgw}.
}
\examples{
## model estimation using 800 samples, printing progress every 100 samples
library("survival")
data(ovarian)
est <- bsgw(Surv(futime, fustat) ~ ecog.ps + rx, ovarian
            , control=bsgw.control(iter=400, nskip=100))

## comparing shape of Weibull curves between ordinary Weibull and bsgw
## since in bsgw shape is dependent on covariates, only a population average is meaningful
## Note that survreg-style scale is inverse of bsgw shape parameter, see survreg help page
west <- survreg(Surv(futime, fustat) ~ ecog.ps + rx, ovarian)
cat("constant survreg-style scale parameter:", west$scale, "\n")
cat("population average of survreg-style scale parameter from bsgw model:"
  , mean(est$median$survreg.scale), "\n")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

