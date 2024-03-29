\encoding{latin1}

\name{seqcost}

\alias{seqcost}

\title{Define substitution and indel costs}

\description{
 The function proposes different ways to generate substitution costs
(supposed to reflect state dissimilarities) and possibly indel costs. Proposed methods are:
\code{"CONSTANT"} (same cost for all substitutions), \code{"TRATE"} (derived from the observed transition rates), \code{"FUTURE"} (Chi-squared distance between conditional state distributions \code{lag} positions ahead), \code{"FEATURES"} (Gower distance between state features), \code{"INDELS"}, \code{"INDELSLOG"} (based on estimated indel costs)
The substitution-cost matrix is intended to serve as \code{sm} argument in the \code{\link{seqdist}} function that computes distances between sequences.
 }

\details{
 The substitution-cost matrix has dimension \eqn{ns*ns}, where
\eqn{ns} is the number of states in the \link{alphabet} of the
sequence object. The element \eqn{(i,j)} of the matrix is the cost of
substituting state \eqn{i} with state \eqn{j}. It defines the dissimilarity between

With method \code{CONSTANT}, the substitution costs are all set equal to the \code{cpal} value, the default value being 2.

With method \code{TRATE}
(transition rates), the transition rates between all pairs of
states is first computed (using the \link{seqtrate} function). Then, the
substitution cost between states \eqn{i} and \eqn{j} is obtained with
the formula

 \deqn{SC(i,j) = cval - P(i,j) -P(j,i)}

where \eqn{P(i,j)} is the rate of transition from state \eqn{i} to
\eqn{j} \code{lag} positions ahead.

With method \code{FUTURE}, the cost between \eqn{i} and \eqn{j} is the Chi-squared distance between the vector (\eqn{d(alphabet | i)}) of rates of transition from states \eqn{i} and
\eqn{j} to all the states in the alphabet \code{lag} positions ahead:

 \deqn{SC(i,j) = ChiDist(d(alphabet | i), d(alphabet | j))}


With method \code{FEATURES}, each state is characterized by the variables \code{state.prop}, and the cost between \eqn{i} and \eqn{j} is computed as the Gower distance between their vectors of \code{state.prop} values.

With methods \code{INDELS} and \code{INDELSLOG}, values of indels are first derived from the state relative frequencies \eqn{f_i}. For \code{INDELS}, \eqn{indel_i = 1/f_i}, and for \code{INDELSLOG}, \eqn{indel_i = \log[2/(1 + f_i)]}{indel_i = log[2/(1 + f_i)]}.
Substitution costs are then set as \eqn{SC(i,j) = indel_i + indel_j}.
}


\usage{
seqcost(seqdata, method, cval=NULL, with.missing=FALSE,
    miss.cost=NULL, time.varying=FALSE, weighted=TRUE, transition="both", lag=1,
    missing.trate=FALSE, state.prop=NULL, prop.weights=NULL, prop.type=list(),
    proximities=FALSE)
}

 \arguments{
  \item{seqdata}{a sequence object as returned by the \link{seqdef} function.}

  \item{method}{Character string. How to generate the costs. One of \code{"CONSTANT"} (same cost for all substitutions), \code{"TRATE"} (derived from the observed transition rates), \code{"FUTURE"} (Chi-squared distance between conditional state distributions \code{lag} positions ahead), \code{"FEATURES"} (Gower distance between state features), \code{"INDELS"}, \code{"INDELSLOG"} (based on estimated indel costs).}

  \item{cval}{Scalar. For method \code{CONSTANT}, the single substitution cost. \cr
  For method \code{"TRATE"}, a base value from which transition probabilities are subtracted.\cr
  If \code{NULL}, \code{cval=2} is used, unless \code{transition}
  is \code{"both"} and \code{time.varying} is \code{TRUE}, in which case \code{cval=4}.}

    \item{with.missing}{Logical. Should an additional entry be added in the matrix for the missing states?
    If \code{TRUE}, the \sQuote{missing} state is also added to state alphabet. Use this if you want to compute
    distances with missing values inside the sequences. See \cite{Gabadinho et al. (2010)} for more details on the options for handling missing values when computing distances between sequences.}

    \item{miss.cost}{Scalar or vector. Cost for substituting the missing state. Default is \code{cval}.}

    \item{time.varying}{Logical. If \code{TRUE} return an \code{\link{array}} with a distinct matrix for each time unit. Time is the third dimension (subscript) of the returned array.}

    \item{weighted}{Logical. Should weights in \code{seqdata} be used when applicable?}

    \item{transition}{Character string. Only used if \code{method="TRATE"} and \code{time.varying=TRUE}. On which transition are rates based? Should be one of \code{"previous"} (from previous state), \code{"next"} (to next state) or \code{"both"}.}

    \item{lag}{Integer. For methods \code{TRATE} and \code{FUTURE} only. Time ahead to which transition rates are computed
    (default is \code{lag=1}).}

  \item{missing.trate}{Logical. For methods \code{TRATE} and \code{FUTURE} only.
    If \code{TRUE}, substitution costs with missing state are also based on transition rates. If \code{FALSE} (default value), the substitution cost for the missing state are set as \code{miss.cost}.}
}

\value{
 A matrix of size \eqn{ns*ns}, where
\eqn{ns} is the number of states in the alphabet of the sequence object.
}

\seealso{
 \code{\link{seqtrate}}, \code{\link{seqdef}}, \code{\link{seqdist}}.
}

\references{
Gabadinho, A., G. Ritschard, N. S. M�ller and M. Studer (2011). Analyzing and Visualizing State Sequences in R with TraMineR. \emph{Journal of Statistical Software} \bold{40}(4), 1-37.

Gabadinho, A., G. Ritschard, M. Studer and N. S. M�ller (2010). Mining Sequence Data in
\code{R} with the \code{TraMineR} package: A user's guide. Department of Econometrics and
Laboratory of Demography, University of Geneva.

Studer, M. and G. Ritschard (2014). "A Comparative Review of Sequence Dissimilarity Measures". \emph{LIVES Working Papers}, \bold{33}. NCCR LIVES, Switzerland, 2014. DOI: \url{http://dx.doi.org/10.12682/lives.2296-1658.2014.33}
}

\examples{
## Defining a sequence object with columns 10 to 25
## in the 'biofam' example data set
data(biofam)
biofam.seq <- seqdef(biofam,10:25)

## Optimal matching using transition rates based substitution-cost matrix
## and insertion/deletion costs of 3
trcost <- seqcost(biofam.seq, method="TRATE")
biofam.om <- seqdist(biofam.seq,method="OM",indel=3,sm=trcost)

## Optimal matching using constant value (2) substitution-cost matrix
## and insertion/deletion costs of 3
ccost <- seqcost(biofam.seq, method="CONSTANT", cval=2)
biofam.om.c2 <- seqdist(biofam.seq, method="OM",indel=3,sm=ccost)

## Displaying the distance matrix for the first 10 sequences
biofam.om.c2[1:10,1:10]

## =================================
## Example with weights and missings
## =================================
data(ex1)
ex1.seq <- seqdef(ex1,1:13, weights=ex1$weights)

## Unweighted
subm <- seqcost(ex1.seq, method="TRATE", with.missing=TRUE, weighted=FALSE)
ex1.om <- seqdist(ex1.seq, method="OM", sm=subm, with.missing=TRUE)

## Weighted
subm.w <- seqcost(ex1.seq, method="TRATE", with.missing=TRUE, weighted=TRUE)
ex1.omw <- seqdist(ex1.seq, method="OM", sm=subm.w, with.missing=TRUE)

ex1.om == ex1.omw
}

\author{Matthias Studer and Alexis Gabadinho (first version) (with Gilbert Ritschard for the help page)}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Dissimilarity measures}
